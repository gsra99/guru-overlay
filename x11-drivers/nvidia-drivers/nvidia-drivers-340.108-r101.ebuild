# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit multilib-build systemd toolchain-funcs unpacker

NV_URI="https://download.nvidia.com/XFree86/"

DESCRIPTION="NVIDIA Accelerated Graphic Driver - libs and tools"
HOMEPAGE="https://www.nvidia.com/download/index.aspx"
SRC_URI="
	amd64? ( ${NV_URI}Linux-x86_64/${PV}/NVIDIA-Linux-x86_64-${PV}.run )
	x86? ( ${NV_URI}Linux-x86/${PV}/NVIDIA-Linux-x86-${PV}.run )
	${NV_URI}nvidia-modprobe/nvidia-modprobe-${PV}.tar.bz2
	${NV_URI}nvidia-persistenced/nvidia-persistenced-${PV}.tar.bz2
	${NV_URI}nvidia-settings/nvidia-settings-${PV}.tar.bz2
	${NV_URI}nvidia-xconfig/nvidia-xconfig-${PV}.tar.bz2
"

LICENSE="GPL-2 MIT NVIDIA-r2"
SLOT="0/${PV%%.*}"
KEYWORDS="-* amd64 x86"
IUSE="static-libs +tools +X"

COMMON_DEPEND="
	acct-group/video
	acct-user/nvpd
	net-libs/libtirpc
"
RDEPEND="
	${COMMON_DEPEND}
	x11-drivers/nvidia-kmod:${SLOT}
	static-libs? ( !media-video/nvidia-settings[static-libs(-)] )
	tools? ( media-video/nvidia-settings )
	X? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXext[${MULTILIB_USEDEP}]
		<x11-base/xorg-server-21.2
	)
"
DEPEND="
	${COMMON_DEPEND}
	static-libs? (
		x11-base/xorg-proto
		x11-libs/libX11
		x11-libs/libXext
	)
"
BDEPEND="
	app-misc/pax-utils
	virtual/pkgconfig
"

S="${WORKDIR}"

QA_PREBUILT="usr/bin/nvidia-cuda-mps-* usr/bin/nvidia-debugdump usr/bin/nvidia-smi usr/lib*"

DOCS=(
	README.txt NVIDIA_Changelog
	nvidia-settings/doc/{FRAMELOCK,NV-CONTROL-API}.txt
)
HTML_DOCS=( html/. )

src_prepare() {
	# make user patches usable across versions
	rm nvidia-modprobe && mv nvidia-modprobe{-${PV},} || die
	rm nvidia-persistenced && mv nvidia-persistenced{-${PV},} || die
	rm nvidia-settings && mv nvidia-settings{-${PV},} || die
	rm nvidia-xconfig && mv nvidia-xconfig{-${PV},} || die

	default

	mv tls/libnvidia-tls.so.${PV} . || die
	if [[ -d 32 ]]; then
		mv 32/tls/libnvidia-tls.so.${PV} 32 || die
	fi

	sed 's/__USER__/nvpd/' \
		nvidia-persistenced/init/systemd/nvidia-persistenced.service.template \
		> "${T}/nvidia-persistenced.service" || die

	sed "s|@LIBDIR@|${EPREFIX}/usr/$(get_libdir)|" \
		"${FILESDIR}/nvidia.xorg-conf" > "${T}/nvidia.xorg-conf" || die

	gzip -d nvidia-{cuda-mps-control,smi}.1.gz || die
}

src_compile() {
	nvidia-drivers_make() {
		emake -C nvidia-${1} ${2} \
			PREFIX="${EPREFIX}/usr" \
			HOST_CC="$(tc-getBUILD_CC)" \
			HOST_LD="$(tc-getBUILD_LD)" \
			NV_VERBOSE=1 STRIP_CMD="true" OUTPUTDIR=out
	}

	tc-export AR CC LD OBJCOPY

	# 340.xx persistenced doesn't auto-detect libtirpc
	LIBS=$($(tc-getPKG_CONFIG) --libs libtirpc || die) \
		common_cflags=$($(tc-getPKG_CONFIG) --cflags libtirpc || die) \
		nvidia-drivers_make persistenced

	nvidia-drivers_make modprobe
	use X && nvidia-drivers_make xconfig

	if use static-libs; then
		nvidia-drivers_make settings/src build-xnvctrl
	fi
}

src_install() {
	nvidia-drivers_make_install() {
		emake -C nvidia-${1} install \
			DESTDIR="${D}" \
			PREFIX="${EPREFIX}/usr" \
			LIBDIR="${ED}/usr/$(get_libdir)" \
			NV_VERBOSE=1 MANPAGE_GZIP=0 OUTPUTDIR=out
	}

	nvidia-drivers_libs_install() {
		local nvidia_libdir="/usr/$(get_libdir)/nvidia"
		nvidia_ldpaths+=( "${nvidia_libdir}" )

		local libs=(
			libGLESv1_CM.so
			libGLESv2.so
			libcuda.so
			libnvcuvid.so
			libnvidia-compiler.so
			libnvidia-encode.so
			libnvidia-glcore.so
			libnvidia-ml.so
			libnvidia-opencl.so
			libnvidia-tls.so
		)
		if use X; then
			libs+=(
				libEGL.so
				libGL.so
				libnvidia-eglcore.so
				libnvidia-fbc.so
				libnvidia-glsi.so
				libnvidia-ifr.so
				libvdpau_nvidia.so
			)
		fi

		local src_libdir=.
		if multilib_is_native_abi; then
			libs+=(
				libnvidia-cfg.so
				libnvidia-wfb.so
			)
		else
			local src_libdir+=/32
		fi

		exeinto ${nvidia_libdir}

		local lib soname
		for lib in "${libs[@]}"; do
			doexe ${src_libdir}/${lib}.${PV}

			# auto-detect soname and create appropriate symlinks
			soname=$(scanelf -qF'%S#F' ${lib}.${PV}) || die "Scanning ${lib}.${PV} failed"
			if [[ ${soname} && ${soname} != ${lib}.${PV} ]]; then
				dosym ${lib}.${PV} ${nvidia_libdir}/${soname} || die
			fi
			dosym ${lib}.${PV} ${nvidia_libdir}/${lib} || die
		done
	}

	local nvidia_ldpaths=()

	multilib_foreach_abi nvidia-drivers_libs_install

	if use X; then
		exeinto /usr/$(get_libdir)/xorg/modules/drivers
		doexe nvidia_drv.so

		exeinto /usr/$(get_libdir)/nvidia/xorg
		newexe libglx.so{.${PV},}
		# Symlink to the old location because better safe than sorry
		dosym ../../../nvidia/xorg/libglx.so \
			/usr/$(get_libdir)/opengl/nvidia/extensions/libglx.so

		insinto /usr/share/X11/xorg.conf.d
		newins "${T}/nvidia.xorg-conf" 10-nvidia.conf

		newenvd - "000nvidia" <<-EOF
			LDPATH="$( IFS=:; echo "${nvidia_ldpaths[*]}" )"
		EOF
	fi

	insinto /etc/OpenCL/vendors
	doins nvidia.icd

	insinto /etc/nvidia
	newins nvidia-application-profiles{-${PV},}-rc
	insinto /usr/share/nvidia
	newins nvidia-application-profiles{-${PV},}-key-documentation

	# install built helpers
	nvidia-drivers_make_install modprobe
	# allow video group to load mods and create devs (bug #505092)
	fowners root:video /usr/bin/nvidia-modprobe
	fperms 4710 /usr/bin/nvidia-modprobe

	nvidia-drivers_make_install persistenced
	newconfd "${FILESDIR}/nvidia-persistenced.confd" nvidia-persistenced
	newinitd "${FILESDIR}/nvidia-persistenced.initd" nvidia-persistenced
	systemd_dounit "${T}/nvidia-persistenced.service"

	use X && nvidia-drivers_make_install xconfig

	if use static-libs; then
		dolib.a nvidia-settings/src/libXNVCtrl/libXNVCtrl.a

		insinto /usr/include/NVCtrl
		doins nvidia-settings/src/libXNVCtrl/NVCtrl{Lib,}.h
	fi

	dobin nvidia-cuda-mps-control
	doman nvidia-cuda-mps-control.1
	dobin nvidia-cuda-mps-server

	dobin nvidia-debugdump
	dobin nvidia-bug-report.sh

	dobin nvidia-smi
	doman nvidia-smi.1

	# elogind suspend script
	exeinto $(get_libdir)/elogind/system-sleep
	newexe "${FILESDIR}"/nvidia-sleep.elogind nvidia-sleep.sh
}

pkg_postinst() {
	if use tools; then
		elog "You have merged ${PN} with USE=\"tools\", which is provided"
		elog "to maintain compatibility with Gentoo's main tree."
		elog
		elog "It is not guaranteed to remain in the future, so in order to prevent"
		elog "nvidia-settings from being removed unintentionally, make sure it is"
		elog "in your world set by running:"
		elog
		elog "  emerge --noreplace media-video/nvidia-settings"
		elog
	fi
}
