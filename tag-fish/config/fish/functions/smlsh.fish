function smlsh --description 'Connect to a SML instance'
  sml projects -v | tail -n +2 | fzy | read -l project_result
  set -l project_id (echo $project_result | cut -d ' ' -f 1)
  sml servers $project_id | fzy | read -l server_result
  sml shell $project_id $server_result
end
