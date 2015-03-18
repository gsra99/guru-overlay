hello
# guru-overlay
## Get it!
There are two easy ways to get the overlay onto your system:


### 1. Git
1. `emerge -av git`
2. `mkdir /usr/local/portage`
3. `cd /usr/local/portage`
4. `git clone git://github.com/gsra99/guru-overlay.git`
5. Modify `/etc/make.conf`:

        PORTDIR_OVERLAY="/usr/local/portage/guru-overlay/"


### 2. Layman
If you don't know what `layman` is then please read the [documentation][docs-layman] first.

1. `emerge -av layman`
2. Modify `/etc/layman/layman.cfg`:

        overlays  : http://www.gentoo.org/proj/en/overlays/repositories.xml
                    https://raw.github.com/gsra99/guru-overlay/master/repositories.xml

3. `layman --list`
4. `layman --add guru-overlay`

[docs-layman]: http://www.gentoo.org/proj/en/overlays/userguide.xml
