# sample ipython_config.py

config = get_config()

config.TerminalIPythonApp.display_banner = False

config.InteractiveShell.autoindent = True
config.InteractiveShell.colors = 'Linux'
config.InteractiveShell.confirm_exit = False
config.InteractiveShell.editor = 'vim'
config.InteractiveShell.xmode = 'Context'
config.InteractiveShell.autocall = 2

config.PrefilterManager.multi_line_specials = True

config.AliasManager.user_aliases = [
    ('la', 'ls -al'),
    ('lt', 'ls -lhtr')
]
