# sample ipython_config.py
import socket,sys
hostname=socket.gethostname()

c = get_config()

c.TerminalIPythonApp.display_banner = False
#c.InteractiveShellApp.log_level = 30
# if hostname=='mizar' and sys.version_info.major==2:
    # c.InteractiveShellApp.extensions = [
        # 'line_profiler',
        # 'memory_profiler',
    # ]
    # c.TerminalIPythonApp.extensions = [
        # 'line_profiler',
        # 'memory_profiler',
    # ]
#c.InteractiveShellApp.exec_lines = [
    #'from __future__ import division',
    #'import numpy as np',
    #'import astropy.constants as const',
    #'import astropy.units as u',
    #'import sys',
    #'sys.tracebacklimit = 100',
#]
#c.InteractiveShellApp.exec_files = [
#]
c.InteractiveShell.autoindent = True
c.InteractiveShell.colors = 'Linux'
c.InteractiveShell.confirm_exit = False
c.InteractiveShell.deep_reload = False
c.InteractiveShell.editor = 'vim'
c.InteractiveShell.xmode = 'Context'
c.InteractiveShell.autocall = 2

# c.PromptManager.in_template  = 'In [\#]: '
# c.PromptManager.in2_template = '   .\D.: '
# c.PromptManager.out_template = 'Out[\#]: '
# c.PromptManager.justify = True

c.PrefilterManager.multi_line_specials = True

c.AliasManager.user_aliases = [
 ('la', 'ls -al'),
 ('lt', 'ls -lhtr')
]
