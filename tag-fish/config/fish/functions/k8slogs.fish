function k8slogs --description 'Logs for a pod' --argument namespace --argument container
  if test -z $namespace
    echo "Missing argument NAMESPACE"
    return 1
  end

  if test -z $container
      set -l container "-c $container"
  end

  kubectl get pods -o=custom-columns=NAME:.metadata.name --namespace $namespace | \
    tail -n+2 | \
    fzy | \
    read -l pod
  echo $pod
  kubectl logs -f $pod --namespace $namespace $container --since 12h
end
