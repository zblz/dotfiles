try:
    import numpy as np
except ImportError:
    pass

try:
    import astropy.units as u
except ImportError:
    pass

try:
    # matplotlib
    import matplotlib as mpl
    import matplotlib.pyplot as plt
    # plt.style.use('seaborn-whitegrid')
    # plt.style.use('seaborn-deep')
except (ImportError, RuntimeError):
    pass
