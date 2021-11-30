function smlsh -a project_query -d 'SSH to a SherlockML server'
  sml projects -v | tail -n +2 | fzy -q "$project_query" -p 'project > ' | \
    read -l project
  set -l project_id (echo $project | cut -d ' ' -f 1)
  set -l servers (sml server list $project_id)
  if test (count $servers) -eq 1 # If there is only one server, use that
    set server $servers[1]
  else
    echo -e (string join '\n' $servers) | fzy -p "server > " | read server
  end

  sml shell $project_id $server
end
