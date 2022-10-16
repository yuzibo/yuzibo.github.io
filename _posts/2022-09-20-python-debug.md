---
title: python debug tips
category: debian-riscv
layout: post
---
* content
{:toc}

# 基本的调试命令
```bash
gdb -ex r --args python3 -m pytest -rsx -v -s src/sas/qtgui/Calculators/UnitTesting/GenericScatteringCalculator.py::Plotter3DTest
```

## 找出违规包(offending package)
该问题的thread在[mail list](https://lists.debian.org/debian-python/2022/10/msg00014.html)。基本情况是，由于之前手动安装某个package(python),导致引发了setuptools的bug:

```python
vimer@dev:~/build/rfs/packages/test_dir$ sudo pip3 install sphinxcontrib-ditaa
Collecting sphinxcontrib-ditaa
   Using cached sphinxcontrib-ditaa-1.0.1.tar.gz (7.5 kB)
   Preparing metadata (setup.py) ... error
   error: subprocess-exited-with-error

   × python setup.py egg_info did not run successfully.
   │ exit code: 1
   ╰─> [30 lines of output]
       Traceback (most recent call last):
         File "<string>", line 2, in <module>
         File "<pip-setuptools-caller>", line 34, in <module>
        File "/tmp/pip-install-c2wygkxs/sphinxcontrib-ditaa_10e1c64028af47e59b8fc5bf20b6901c/setup.py", line 8, in <module>
           setup(
        File "/usr/lib/python3/dist-packages/setuptools/__init__.py", line 86, in setup
           _install_setup_requires(attrs)
        File "/usr/lib/python3/dist-packages/setuptools/__init__.py", line 75, in _install_setup_requires
           dist = MinimalDistribution(attrs)
        File "/usr/lib/python3/dist-packages/setuptools/__init__.py", line 57, in __init__
           super().__init__(filtered)
        File "/usr/lib/python3/dist-packages/setuptools/dist.py", line 474, in __init__           for ep in metadata.entry_points(group='distutils.setup_keywords'):         File "/usr/lib/python3.10/importlib/metadata/__init__.py", line 1009, in entry_points
           return SelectableGroups.load(eps).select(**params)
        File "/usr/lib/python3.10/importlib/metadata/__init__.py", line 459, in load
           ordered = sorted(eps, key=by_group)
        File "/usr/lib/python3.10/importlib/metadata/__init__.py", line 1006, in <genexpr>
           eps = itertools.chain.from_iterable(
        File "/usr/lib/python3.10/importlib/metadata/_itertools.py", line 16, in unique_everseen
           k = key(element)
        File "/usr/lib/python3.10/importlib/metadata/__init__.py", line 941, in _normalized_name
           return self._name_from_stem(stem) or super()._normalized_name
        File "/usr/lib/python3.10/importlib/metadata/__init__.py", line 622, in _normalized_name
           return Prepared.normalize(self.name)
        File "/usr/lib/python3.10/importlib/metadata/__init__.py", line 871, in normalize
           return re.sub(r"[-_.]+", "-", name).lower().replace('-', '_')
         File "/usr/lib/python3.10/re.py", line 209, in sub
           return _compile(pattern, flags).sub(repl, string, count)
       TypeError: expected string or bytes-like object
       [end of output]

  note: This error originates from a subprocess, and is likely not a problem with pip.
error: metadata-generation-failed

× Encountered error while generating package metadata.
╰─> See above for output.
```

在肥猫老师的帮助下，这个问题很快解决了，主要是通过这个命令:
```bash
strace -eopenat python -c "from importlib.metadata import entry_points; print(entry_points(group='sphinx.builders'))"
```
这里的一个新鲜事物是`strace`,之前有用过这个命令，但是没想到还可以用在这里。这是这个bug带来的最大收获。其次，为什么这里可以通过`entry_points`找到触发问题的入口呢？这是我目前不理解的地方。