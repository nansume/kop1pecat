PREFIX ?= /usr/local

compile:
	luac -s -o pastecat.out include/*.lua pastecat.lua
	printf %s\\n '#!/bin/lua' > shebang.out
	cat shebang.out pastecat.out > pastecat.luac

install:
	mkdir -p $(DESTDIR)/var/www/wpastecat/
	mkdir -p $(DESTDIR)$(PREFIX)/lib/lua/io/
	mkdir -p $(DESTDIR)$(PREFIX)/lib/lua/os/
	chmod +x pastecat.lua
	install -Dvm 644 include/io.execute.lua $(DESTDIR)$(PREFIX)/lib/lua/io/execute.lua
	install -Dvm 644 include/os.isdir.lua $(DESTDIR)$(PREFIX)/lib/lua/os/isdir.lua
	install -Dvm 644 include/os.isfile.lua $(DESTDIR)$(PREFIX)/lib/lua/os/os.isfile.lua
	install -Dvm 755 pastecat.lua $(DESTDIR)/var/www/pastecat.cgi
	install -Dbvm 644 pastecat.conf $(DESTDIR)$(PREFIX)/etc/pastecat.conf

install-strip: compile
	chmod +x pastecat.luac
	cp -l pastecat.luac pastecat.cgi
	mkdir -p $(DESTDIR)/var/www/wpastecat/
	install -Dvm 755 pastecat.cgi $(DESTDIR)/var/www/pastecat.cgi
	install -Dvm 755 pastecat.html $(DESTDIR)/var/www/wpastecat/index.html
	install -Dbvm 644 pastecat.conf $(DESTDIR)$(PREFIX)/etc/pastecat.conf

clean:
	rm -f pastecat.lua
	rm -f pastecat.luac
	rm -f pastecat.cgi
	rm -f *.out

.PHONY: clean
