# guru-overlay
## Get it!
### Layman
If you don't know what `layman` is then please read the [documentation][docs-layman] first.

1. `emerge -av layman`
2. `wget -o /etc/layman/overlays/guru-overlay.xml 
https://raw.githubusercontent.com/gsra99/guru-overlay/master/repositories.xml -f -a guru-overlay`
3. `layman -a guru-overlay`

[docs-layman]: http://www.gentoo.org/proj/en/overlays/userguide.xml
