function smlsh -a query -d 'SSH to a SherlockML server'
  sml projects -v | tail -n +2 | fzy -q "$query" -p 'project> ' | \
    read -l project
  set -l project_id (echo $project | cut -d ' ' -f 1)
  set -l servers (sml server list $project_id)
  if test (count $servers) -eq 0
    echo 'No servers in project'
    return
  else if test (count $servers) -eq 1
    set server $servers[1]
  else
    echo -e (string join '\n' $servers) | fzy -p 'server> ' | \
      read -l server
  end
  sml shell $project_id $server -A
end
