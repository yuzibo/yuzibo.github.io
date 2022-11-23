---
title: Debian python ftbfs summary
category: debian-riscv
layout: post
---
* content
{:toc}


```bash
> Relevant part (hopefully):
> >  debian/rules clean
> > dh clean --with python3 --buildsystem=pybuild
> >    dh_auto_clean -O--buildsystem=pybuild
> > I: pybuild base:240: python3.10 setup.py clean 
> > /<<PKGBUILDDIR>>/setup.py:3: DeprecationWarning: The distutils
package is deprecated and slated for removal in Python 3.12. Use
setuptools or check PEP 632 for potential alternatives
> >   from distutils.core import setup
> > /usr/lib/python3/dist-packages/_distutils_hack/__init__.py:18:
UserWarning: Distutils was imported before Setuptools, but importing
Setuptools also replaces the `distutils` module in `sys.modules`. This
may lead to undesirable behaviors or errors. To avoid these issues,
avoid using distutils directly, ensure that setuptools is installed in
the traditional way (e.g. not an editable install), and/or make sure
that setuptools is always imported before distutils.
> >   warnings.warn(
> > /usr/lib/python3/dist-packages/_distutils_hack/__init__.py:33:
UserWarning: Setuptools is replacing distutils.
> >   warnings.warn("Setuptools is replacing distutils.")
> > /usr/lib/python3.10/distutils/dist.py:274: UserWarning: Unknown
distribution option: 'install_requires'
> >   warnings.warn(msg)
> > running clean
> > Traceback (most recent call last):
> >   File "/<<PKGBUILDDIR>>/setup.py", line 6, in <module>
> >     setup(name='azure-cosmos',
> >   File "/usr/lib/python3.10/distutils/core.py", line 148, in setup
> >     dist.run_commands()
> >   File "/usr/lib/python3.10/distutils/dist.py", line 966, in
run_commands
> >     self.run_command(cmd)
> >   File "/usr/lib/python3.10/distutils/dist.py", line 983, in
run_command
> >     cmd_obj = self.get_command_obj(command)
> >   File "/usr/lib/python3.10/distutils/dist.py", line 858, in
get_command_obj
> >     cmd_obj = self.command_obj[command] = klass(self)
> >   File "/usr/lib/python3/dist-packages/setuptools/__init__.py",
line 158, in __init__
> >     super().__init__(dist)
> >   File "/usr/lib/python3/dist-
packages/setuptools/_distutils/cmd.py", line 59, in __init__
> >     raise TypeError("dist must be a Distribution instance")
> > TypeError: dist must be a Distribution instance
> > E: pybuild pybuild:379: clean: plugin distutils failed with: exit
code=1: python3.10 setup.py clean 
> > dh_auto_clean: error: pybuild --clean -i python{version} -p 3.10
returned exit code 13
> > make: *** [debian/rules:6: clean] Error 25

# patch

-﻿#!/usr/bin/env python
+#!/usr/bin/env python
 
-from distutils.core import setup
 import setuptools
+from distutils.core import setup
 
```

1. https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1022488