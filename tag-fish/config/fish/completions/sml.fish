# Completion script for fish.
# Copy this script to ~/.config/fish/completions
#
# TODO: Add server details 
# TODO: Add remote file path completion
# TODO: Add machine types in new server

# helpers 

function __fish_sml_list_projects
  command sml projects
end 

function __fish_sml_list_servers
  set cmd (commandline -opc)
  command sml server list $cmd[-1]
end

function __fish_sml_list_environments
  set cmd (commandline -opc)
  command sml environment list $cmd[-2]
end

# common options

complete -c sml -f
complete -c sml -l help -d 'Display help and exit.'

# list available servers, when server is an option (i.e. --server)
# this assumes the Project is in the fourth position

function __fish_sml_server_is_option
  set cmd (commandline -opc)
  if [ (count $cmd) -ge 1 ]; and [ $cmd[-1] = '--server' ]
    return 0 
  end
  return 1
end

function __fish_sml_list_servers_if_option
  set cmd (commandline -opc)
  command sml server list $cmd[4]
end

complete -c sml -n "__fish_sml_server_is_option" -x -a "(__fish_sml_list_servers_if_option)"

# list available environments, when environment is an option (i.e. --environment)
# this assumes the Project is in the fourth position

function __fish_sml_environment_is_option
  set cmd (commandline -opc)
  if [ (count $cmd) -ge 1 ]; and [ $cmd[-1] = '--environment' ]
    return 0 
  end
  return 1
end

function __fish_sml_list_environments_if_option
  set cmd (commandline -opc)
  command sml environment list $cmd[4]
end

complete -c sml -n "__fish_sml_environment_is_option" -x -a "(__fish_sml_list_environments_if_option)"

# list available server types, when type is an option (i.e. --type)

function __fish_sml_type_is_option
  set cmd (commandline -opc)
  if [ (count $cmd) -ge 1 ]; and [ $cmd[-1] = '--type' ]
    return 0 
  end
  return 1
end

complete -c sml -n "__fish_sml_type_is_option" -x -a "jupyter jupyterlab rstudio zeppelin"

# environment

complete -c sml -n "__fish_is_first_token" -a environment -d "Manipulate SherlockML server environments."

complete -c sml -n "__fish_seen_subcommand_from environment; and __fish_is_token_n 3" -x -a apply -d "Apply an environment to the server."
complete -c sml -n "__fish_seen_subcommand_from environment; and __fish_seen_subcommand_from apply; and __fish_is_token_n 4" -x -a "(__fish_sml_list_projects)"
complete -c sml -n "__fish_seen_subcommand_from environment; and __fish_seen_subcommand_from apply; and __fish_is_token_n 5" -x -a "(__fish_sml_list_servers)"
complete -c sml -n "__fish_seen_subcommand_from environment; and __fish_seen_subcommand_from apply; and __fish_is_token_n 6" -x -a "(__fish_sml_list_environments)"

complete -c sml -n "__fish_seen_subcommand_from environment; and __fish_is_token_n 3" -x -a list -d "List your environments."
complete -c sml -n "__fish_seen_subcommand_from environment; and __fish_seen_subcommand_from list; and __fish_is_token_n 4" -x -a "(__fish_sml_list_projects)"
complete -c sml -n "__fish_seen_subcommand_from environment; and __fish_seen_subcommand_from list" -s v -l verbose -d "Print extra information about environments."

complete -c sml -n "__fish_seen_subcommand_from environment; and __fish_is_token_n 3" -x -a logs -d "Stream the logs for a server environment application."
complete -c sml -n "__fish_seen_subcommand_from environment; and __fish_seen_subcommand_from logs; and __fish_is_token_n 4" -x -a "(__fish_sml_list_projects)"
complete -c sml -n "__fish_seen_subcommand_from environment; and __fish_seen_subcommand_from logs; and __fish_is_token_n 5" -x -a "(__fish_sml_list_servers)"
complete -c sml -n "__fish_seen_subcommand_from environment; and __fish_seen_subcommand_from logs" -s s -l step -d "Display only the logs for this step."

complete -c sml -n "__fish_seen_subcommand_from environment; and __fish_is_token_n 3" -x -a status -d "Get the execution status for an environment."
complete -c sml -n "__fish_seen_subcommand_from environment; and __fish_seen_subcommand_from status; and __fish_is_token_n 4" -x -a "(__fish_sml_list_projects)"
complete -c sml -n "__fish_seen_subcommand_from environment; and __fish_seen_subcommand_from status; and __fish_is_token_n 5" -x -a "(__fish_sml_list_servers)"

# file

complete -c sml -n "__fish_is_first_token" -a file -d "Manipulate files in a SherlockML project."

complete -c sml -n "__fish_seen_subcommand_from file; and __fish_is_token_n 3" -x -a get -d "Copy a file from the SherlockML workspace to the local machine."
complete -c sml -n "__fish_seen_subcommand_from file; and __fish_is_token_n 3" -x -a put -d "Copy a local file to the SherlockML workspace."
complete -c sml -n "__fish_seen_subcommand_from file; and __fish_is_token_n 3" -x -a sync-down -d "Sync remote files down from project with rsync."
complete -c sml -n "__fish_seen_subcommand_from file; and __fish_is_token_n 3" -x -a sync-up -d "Sync local files up to a project with rsync."

complete -c sml -n "__fish_seen_subcommand_from file; and __fish_is_token_n 4" -x -a "(__fish_sml_list_projects)"
complete -c sml -n "__fish_seen_subcommand_from file" -l server -d "Name or ID of server to use."

# home

complete -c sml -n "__fish_is_first_token" -a home -d "Open the SherlockML home page."

# login

complete -c sml -n "__fish_is_first_token" -a login -d "Write SherlockML credentials to file."

# projects

complete -c sml -n "__fish_is_first_token" -a projects -d "List accessible SherlockML projects."
complete -c sml -n "__fish_seen_subcommand_from projects" -s v -l verbose -d "Print extra information about projects."

# server

complete -c sml -n "__fish_is_first_token" -a server -d "Manipulate SherlockML servers."

complete -c sml -n "__fish_seen_subcommand_from server; and __fish_is_token_n 3" -x -a list -d "List your SherlockML servers."
complete -c sml -n "__fish_seen_subcommand_from server; and __fish_seen_subcommand_from list" -s v -l verbose -d "Print extra information about servers."
complete -c sml -n "__fish_seen_subcommand_from server; and __fish_seen_subcommand_from list" -s a -l all -d "Show all servers, not just running ones."

complete -c sml -n "__fish_seen_subcommand_from server; and __fish_is_token_n 3" -x -a new -d "Create a new SherlockML server."
complete -c sml -n "__fish_seen_subcommand_from server; and __fish_seen_subcommand_from new; and __fish_is_token_n 4" -x -a "(__fish_sml_list_projects)"
complete -c sml -n "__fish_seen_subcommand_from server; and __fish_seen_subcommand_from new; and not __fish_seen_subcommand_from --cores; and not __fish_seen_subcommand_from --machine-type" -l cores -d "Number of CPU cores  [default: 1]."
complete -c sml -n "__fish_seen_subcommand_from server; and __fish_seen_subcommand_from new; and not __fish_seen_subcommand_from --memory; and not __fish_seen_subcommand_from --machine-type" -l memory -d "Server memory in GB  [default: 4]."
complete -c sml -n "__fish_seen_subcommand_from server; and __fish_seen_subcommand_from new; and not __fish_seen_subcommand_from --type" -l type -d "Server type  [default: jupyter]."
complete -c sml -n "__fish_seen_subcommand_from server; and __fish_seen_subcommand_from new; and not __fish_seen_subcommand_from --machine-type; and not __fish_seen_subcommand_from --cores; and not __fish_seen_subcommand_from --memory" -l machine-type -d "Machine type for a dedicated instance."
complete -c sml -n "__fish_seen_subcommand_from server; and __fish_seen_subcommand_from new; and not __fish_seen_subcommand_from --version" -l version -d "Server image version [advanced]."
complete -c sml -n "__fish_seen_subcommand_from server; and __fish_seen_subcommand_from new; and not __fish_seen_subcommand_from --name" -l name -d "Name to assign to the server."
complete -c sml -n "__fish_seen_subcommand_from server; and __fish_seen_subcommand_from new; and not __fish_seen_subcommand_from --environment" -l environment -d "Environments to apply to the server."
complete -c sml -n "__fish_seen_subcommand_from server; and __fish_seen_subcommand_from new; and not __fish_seen_subcommand_from --wait" -l wait -d "Wait until the server is running before exiting."

complete -c sml -n "__fish_seen_subcommand_from server; and __fish_is_token_n 3" -x -a open -d "Open a SherlockML server in your browser."
complete -c sml -n "__fish_seen_subcommand_from server; and __fish_seen_subcommand_from open; and __fish_is_token_n 4" -x -a "(__fish_sml_list_projects)"
complete -c sml -n "__fish_seen_subcommand_from server; and __fish_seen_subcommand_from open" -l server -d "Name or ID of server to use."

complete -c sml -n "__fish_seen_subcommand_from server; and __fish_is_token_n 3" -x -a terminate -d "Terminate a SherlockML server."
complete -c sml -n "__fish_seen_subcommand_from server; and __fish_seen_subcommand_from terminate; and __fish_is_token_n 4" -x -a "(__fish_sml_list_projects)"
complete -c sml -n "__fish_seen_subcommand_from server; and __fish_seen_subcommand_from terminate; and __fish_is_token_n 5" -x -a "(__fish_sml_list_servers)"

# shell

complete -c sml -n "__fish_is_first_token" -a shell -d "Open a shell on an SherlockML server."
complete -c sml -n "__fish_seen_subcommand_from shell; and __fish_is_token_n 3" -x -a "(__fish_sml_list_projects)"
complete -c sml -n "__fish_seen_subcommand_from shell; and __fish_is_token_n 4" -x -a "(__fish_sml_list_servers)"

# version

complete -c sml -n "__fish_is_first_token" -a version -d "Print the sml version number."
