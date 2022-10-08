---
title: debian python debug tips
category: debian-riscv
layout: post
---
* content
{:toc}

```bash
gdb -ex r --args python3 -m pytest -rsx -v -s src/sas/qtgui/Calculators/UnitTesting/GenericScatteringCalculator.py::Plotter3DTest
```