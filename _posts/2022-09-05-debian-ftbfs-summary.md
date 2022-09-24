---
title: debian ftbfs summary
category: debian-riscv
layout: post
---
* content
{:toc}

这个页面作为搜集、整理ftbfs的解决方案。

# FTBFS
https://wiki.debian.org/qa.debian.org/FTBFS

## patch
### size of array ‘_compile_time_assert__’ is negative
```bash
cc -DHAVE_CONFIG_H -I. -I.. -DPACKAGE_SRC_DIR=\""."\" -DPACKAGE_DATA_DIR=\""/usr/share"\"  -Wdate-time -D_FORTIFY_SOURCE=2 -Wall -g -g -O2 -ffile-prefix-map=/<<PKGBUILDDIR>>=. -fstack-protector-strong -Wformat -Werror=format-security -fPIE -c -o pmask.o pmask.c
pmask.c: In function ‘install_pmask’:
pmask.c:32:54: error: size of array ‘_compile_time_assert__’ is negative
   32 | #define COMPILE_TIME_ASSERT(condition) {typedef char _compile_time_assert__[(condition) ? 1 : -1];}
      |                                                      ^~~~~~~~~~~~~~~~~~~~~~
pmask.c:34:9: note: in expansion of macro ‘COMPILE_TIME_ASSERT’
   34 |         COMPILE_TIME_ASSERT((1 << MASK_WORD_BITBITS) == MASK_WORD_BITS);
      |         ^~~~~~~~~~~~~~~~~~~
pmask.c: In function ‘init_pmask’:
pmask.c:40:36: warning: unused variable ‘error’ [-Wunused-variable]
   40 |         int words, total_words, x, error = 0;
      |                                    ^~~~~
pmask.c: In function ‘get_serialized_pmask_size’:
pmask.c:105:13: warning: unused variable ‘words’ [-Wunused-variable]
  105 |         int words = 1 + ((w-1) >> MASK_WORD_BITBITS);
      |             ^~~~~
make[3]: *** [Makefile:495: pmask.o] Error 1
make[3]: *** Waiting for unfinished jobs....
make[3]: Leaving directory '/<<PKGBUILDDIR>>/src'
make[2]: *** [Makefile:410: all-recursive] Error 1
make[2]: Leaving directory '/<<PKGBUILDDIR>>'
make[1]: *** [Makefile:342: all] Error 2
make[1]: Leaving directory '/<<PKGBUILDDIR>>'
dh_auto_build: error: make -j4 returned exit code 2
make: *** [debian/rules:9: binary-arch] Error 25
dpkg-buildpackage: error: debian/rules binary-arch subprocess returned exit status 2
```

```bash
--- open-invaders-0.3.orig/headers/pmask.h
+++ open-invaders-0.3/headers/pmask.h
@@ -37,7 +37,7 @@ confusing.
 //don't worry about setting it incorrectly
 //you'll get a compile error if you do, not a run-time error
 #if defined(__alpha__) || defined(__ia64__) || (defined(__x86_64__) && defined(__LP64__)) || defined(__s390x__) || (defined(__sparc__)
+&& defined(__arch64__)) \
-      || defined(__powerpc64__) || defined(__aarch64__) || (defined(__mips64) && defined(__LP64__))
+      || defined(__powerpc64__) || defined(__aarch64__) || (defined(__mips64) && defined(__LP64__)) || (defined(__riscv) &&
+defined(__LP64__))
        #define MASK_WORD_BITBITS 6
 #else
        #define MASK_WORD_BITBITS 5

```
### -lpthread ftbfs
在 glibc 2.34 之前， 有一个ftbfs是这样的  , 来自[here](https://buildd.debian.org/status/fetch.php?pkg=neochat&arch=riscv64&ver=22.06-1&stamp=1656147982&raw=0)

```bash
[100%] Linking CXX executable ../bin/neochat
cd /<<PKGBUILDDIR>>/obj-riscv64-linux-gnu/src && /usr/bin/cmake -E cmake_link_script CMakeFiles/neochat.dir/link.txt --verbose=1
/usr/bin/c++ -g -O2 -ffile-prefix-map=/<<PKGBUILDDIR>>=. -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -fno-operator-names -fno-exceptions -Wall -Wextra -Wcast-align -Wchar-subscripts -Wformat-security -Wno-long-long -Wpointer-arith -Wundef -Wnon-virtual-dtor -Woverloaded-virtual -Werror=return-type -Werror=init-self -Wvla -Wdate-time -Wsuggest-override -Wlogical-op -fcoroutines -Wl,--enable-new-dtags -Wl,-z,relro -Wl,-z,now CMakeFiles/neochat.dir/neochat_autogen/mocs_compilation.cpp.o CMakeFiles/neochat.dir/controller.cpp.o CMakeFiles/neochat.dir/actionshandler.cpp.o CMakeFiles/neochat.dir/emojimodel.cpp.o CMakeFiles/neochat.dir/customemojimodel.cpp.o CMakeFiles/neochat.dir/customemojimodel+network.cpp.o CMakeFiles/neochat.dir/clipboard.cpp.o CMakeFiles/neochat.dir/matriximageprovider.cpp.o CMakeFiles/neochat.dir/messageeventmodel.cpp.o CMakeFiles/neochat.dir/messagefiltermodel.cpp.o CMakeFiles/neochat.dir/roomlistmodel.cpp.o CMakeFiles/neochat.dir/roommanager.cpp.o CMakeFiles/neochat.dir/neochatroom.cpp.o CMakeFiles/neochat.dir/neochatuser.cpp.o CMakeFiles/neochat.dir/userlistmodel.cpp.o CMakeFiles/neochat.dir/publicroomlistmodel.cpp.o CMakeFiles/neochat.dir/userdirectorylistmodel.cpp.o CMakeFiles/neochat.dir/utils.cpp.o CMakeFiles/neochat.dir/main.cpp.o CMakeFiles/neochat.dir/notificationsmanager.cpp.o CMakeFiles/neochat.dir/sortfilterroomlistmodel.cpp.o CMakeFiles/neochat.dir/chatdocumenthandler.cpp.o CMakeFiles/neochat.dir/devicesmodel.cpp.o CMakeFiles/neochat.dir/filetypesingleton.cpp.o CMakeFiles/neochat.dir/login.cpp.o CMakeFiles/neochat.dir/stickerevent.cpp.o CMakeFiles/neochat.dir/chatboxhelper.cpp.o CMakeFiles/neochat.dir/commandmodel.cpp.o CMakeFiles/neochat.dir/webshortcutmodel.cpp.o CMakeFiles/neochat.dir/blurhash.cpp.o CMakeFiles/neochat.dir/blurhashimageprovider.cpp.o CMakeFiles/neochat.dir/joinrulesevent.cpp.o CMakeFiles/neochat.dir/collapsestateproxymodel.cpp.o CMakeFiles/neochat.dir/neochataccountregistry.cpp.o CMakeFiles/neochat.dir/colorschemer.cpp.o CMakeFiles/neochat.dir/trayicon_sni.cpp.o CMakeFiles/neochat.dir/runner.cpp.o CMakeFiles/neochat.dir/neochatconfig.cpp.o CMakeFiles/neochat.dir/neochat_autogen/YCDLW3T4OG/qrc_res.cpp.o CMakeFiles/neochat.dir/neochat_autogen/YCDLW3T4OG/qrc_res_desktop.cpp.o -o ../bin/neochat  /usr/lib/riscv64-linux-gnu/libKF5SonnetCore.so.5.94.0 /usr/lib/riscv64-linux-gnu/libKF5Kirigami2.so.5.94.0 /usr/lib/riscv64-linux-gnu/libKF5Notifications.so.5.94.0 /usr/lib/riscv64-linux-gnu/libQuotient.so.0.6.11 /usr/lib/riscv64-linux-gnu/libcmark.so.0.30.2 /usr/lib/riscv64-linux-gnu/libqt5keychain.so.0.13.2 /usr/lib/riscv64-linux-gnu/libKF5KIOWidgets.so.5.94.0 /usr/lib/riscv64-linux-gnu/libQt5QuickControls2.so.5.15.4 /usr/lib/riscv64-linux-gnu/libQt5Quick.so.5.15.4 /usr/lib/riscv64-linux-gnu/libQt5QmlModels.so.5.15.4 /usr/lib/riscv64-linux-gnu/libQt5Qml.so.5.15.4 /usr/lib/riscv64-linux-gnu/libQt5Multimedia.so.5.15.4 /usr/lib/riscv64-linux-gnu/libKF5ConfigWidgets.so.5.94.0 /usr/lib/riscv64-linux-gnu/libKF5Codecs.so.5.94.0 /usr/lib/riscv64-linux-gnu/libKF5Auth.so.5.94.0 /usr/lib/riscv64-linux-gnu/libKF5KIOGui.so.5.94.0 /usr/lib/riscv64-linux-gnu/libKF5WindowSystem.so.5.94.0 /usr/lib/riscv64-linux-gnu/libX11.so /usr/lib/riscv64-linux-gnu/libKF5KIOCore.so.5.94.0 /usr/lib/riscv64-linux-gnu/libQt5Network.so.5.15.4 /usr/lib/riscv64-linux-gnu/libKF5AuthCore.so.5.94.0 /usr/lib/riscv64-linux-gnu/libKF5JobWidgets.so.5.94.0 /usr/lib/riscv64-linux-gnu/libKF5Service.so.5.94.0 /usr/lib/riscv64-linux-gnu/libKF5I18n.so.5.94.0 /usr/lib/riscv64-linux-gnu/libKF5CoreAddons.so.5.94.0 /usr/lib/riscv64-linux-gnu/libKF5DBusAddons.so.5.94.0 /usr/lib/riscv64-linux-gnu/libKF5Solid.so.5.94.0 /usr/lib/riscv64-linux-gnu/libKF5Completion.so.5.94.0 /usr/lib/riscv64-linux-gnu/libKF5ConfigGui.so.5.94.0 /usr/lib/riscv64-linux-gnu/libKF5ConfigCore.so.5.94.0 /usr/lib/riscv64-linux-gnu/libQt5DBus.so.5.15.4 /usr/lib/riscv64-linux-gnu/libQt5Xml.so.5.15.4 /usr/lib/riscv64-linux-gnu/libKF5WidgetsAddons.so.5.94.0 /usr/lib/riscv64-linux-gnu/libQt5Widgets.so.5.15.4 /usr/lib/riscv64-linux-gnu/libQt5Gui.so.5.15.4 /usr/lib/riscv64-linux-gnu/libQt5Concurrent.so.5.15.4 /usr/lib/riscv64-linux-gnu/libQt5Core.so.5.15.4 
/usr/bin/ld: CMakeFiles/neochat.dir/neochatroom.cpp.o: undefined reference to symbol '__atomic_exchange_1@@LIBATOMIC_1.0'
/usr/bin/ld: /usr/lib/riscv64-linux-gnu/libatomic.so.1: error adding symbols: DSO missing from command line
```
可以使用下面的方法:
```bash
<bunk> +ifneq (,$(filter $(DEB_HOST_ARCH), riscv64))
<bunk> +  export DEB_LDFLAGS_MAINT_APPEND = -Wl,--no-as-needed -latomic -Wl,--as-needed
<bunk> +endif
```

### gcc-12  ftbfs

1. 

```bash
-I/usr/include/libpng16 -I/usr/include/SDL2 -c -o IOGfxSurfaceGL2.o IOGfxSurfaceGL2.cpp
> gfx_fonts.cpp: In function ‘void setup_font(TTF_Font*)’:
> gfx_fonts.cpp:296:44: error: invalid conversion from ‘const char*’ to ‘char*’ [-fpermissive]
>   296 |   char *familyname = TTF_FontFaceFamilyName(font);

```
详见 #1015106

### unrecognized command-line option ‘-m64’ '-m32'

[libtree](https://buildd.debian.org/status/fetch.php?pkg=libtree&arch=riscv64&ver=3.1.1-1&stamp=1652907182&raw=0)

```bash
cc: error: unrecognized command-line option ‘-m64’
cc: error: unrecognized command-line option ‘-m32’
```
解决方案是，在相关的测试fail中，过滤掉不属于这个架构的测试:

```bash
--- a/tests/05_32_bits/Makefile
+++ b/tests/05_32_bits/Makefile
@@ -2,11 +2,13 @@
 # Make sure the 64 bits versions are not picked up.
 
 LD_LIBRARY_PATH=
+CPU_ARCH=$(shell uname -m)
 
 .PHONY: clean
 
 all: check
 
+ifeq ($(CPU_ARCH), $(filter x86_64 amd64 i686 i386 ppc% sparc64,$(CPU_ARCH)))
 lib64/libx.so:
 	mkdir -p $(@D)
 	echo 'int a(){return 42;}' | $(CC) -shared -Wl,-soname,$(@F) -m64 -o $@ -nostdlib -x c -
@@ -25,6 +27,11 @@
 	../../libtree exe32
 	../../libtree exe64
 
+else
+check:
+	@echo Architecture does not support -m32 or -m64 options. Do nothing.
+endif
+
 clean:
 	rm -rf lib32 lib64 exe*
```
`filter`在这里是匹配返回值的意思。

# 交付

https://gist.github.com/hack3ric/c6fbbc7055f19b6024340384b4fc750a

