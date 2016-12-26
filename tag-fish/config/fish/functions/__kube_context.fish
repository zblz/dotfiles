function __kube_context --description 'Write out the kubernetes context'
    if not command -s kubectl >/dev/null
    return 1
  end
  set -l kube_context (command kubectl config current-context)

  test -n "$kube_context"
  or return

  set -l split_kube_context (string split '.' $kube_context)
  set -l kube_short_context $split_kube_context[1]

  echo -n -s "[" $kube_short_context "]"
end
