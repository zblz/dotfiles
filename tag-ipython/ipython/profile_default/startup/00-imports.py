from __future__ import division,print_function

import numpy as np

try:
    import astropy.units as u
except ImportError:
    pass

try:
    # matplotlib
    import matplotlib as mpl
    import matplotlib.pyplot as plt
    #plt.style.use('seaborn-whitegrid')
    #plt.style.use('seaborn-deep')
except (ImportError, RuntimeError):
    pass

try:
    import line_profiler
    ip.define_magic('lprun', line_profiler.magic_lprun)
except ImportError:
    pass

# https://gist.github.com/taldcroft/547c0b6e0ae15e0c970d

# ip = get_ipython()

# def import_astropy(self, arg):
    # ip.ex('import astropy')
    # ip.ex('print(astropy.__version__)')
    # ip.ex('from astropy.io import ascii')
    # ip.ex('from astropy import table')
    # ip.ex('from astropy.table import Table, QTable, Column, MaskedColumn')
    # #ip.ex('from astropy.table.table_helpers import TimingTables, simple_table, complex_table')
    # ip.ex('from astropy.time import Time, TimeDelta')
    # ip.ex('from astropy.coordinates import SkyCoord, ICRS, FK4, FK5')
    # ip.ex('import astropy.constants as const')
    # ip.ex("u.def_unit(['mec2', 'mc2'], (const.m_e*const.c**2).cgs, namespace=u.__dict__)")
    # #ip.ex('import astropy.units as u')

# ip.define_magic('astro', import_astropy)
