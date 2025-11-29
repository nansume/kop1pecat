# Kop1peCat

The pastecat service by Lua for your own self-hosting.

* Other alternatives: catbin, fiche, pastebin.

---

## Features

- NoJS - Working in console/term, in text-mode web browser, e.g., ELinks, Links, and Lynx.
- NoDB - Only text files.
- Auto generic name, e.g., zHd4wYGs.text
- Simple lua script for CGI, e.g., httpd busybox.
- Auto remove old files.
- Limit maxsize file.
- Limit maxsize upload directory.
- No remote file deletion, only upload.

---

## Issue

- Probably insecure!

---

## Requirements

- Lua-5.4.6
- Lualib: os.isdir
- Lualib: os.isfile
- Lualib: io.execute
- httpd busybox + with CGI support

---

## Install

Install without compile script in one file.
```
  $ sudo make PREFIX=/ install
```
Install and compile script to Bytecode a one file with strip debug info (recomended).

```
  $ sudo make PREFIX=/ install-strip
```
---

## Manual Install

```
  $ sudo cp include/execute.lua /lib/lua/io/
  $ sudo cp include/*.lua /lib/lua/os/
  $ sudo cp pastecat.lua /var/www/pastecat.cgi
  $ sudo cp pastecat.conf /etc/pastecat.conf
  $ sudo chmod +x /var/www/pastecat.cgi
  $ sudo mkdir /var/www/wpastecat/
  $ sudo cp pastecat.html /var/www/wpastecat/index.html
```
---

## Setup

Setup for httpd over inetd (Not secure!)
```
  $ sudo echo "80 stream tcp nowait www-user httpd httpd -i -h /var/www -c /etc/httpd.conf" \
 > /etc/inetd.conf
```

---

## Extras

Delete files older than 7 days.
```
  $ sudo echo "0 0 */1 * * find /var/www/wpastecat/*.text -mtime +7 -exec rm -- {} \;" \
 > /var/spool/cron/crontabs/www-user
```

Additional it variable to run httpd daemon:
```
add: LUAPATH=/lib/lua:${LUAPATH}
```
---

## License

This work is multi-licensed under either GPLv3 or MIT license or UnLicense.

 * GNU GPLv3 [LICENSE.GPLv3](http://www.gnu.org/licenses/gpl-3.0.html)
 * MIT license ([LICENSE.MIT](//nansume/kop1pecat/raw/master/LICENSE.MIT) or http://opensource.org/licenses/MIT)
 * UnLicense ([UNLICENSE](//nansume/kop1pecat/raw/master/UNLICENSE) or http://unlicense.org/)
