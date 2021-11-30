function k8slogs-old --description 'Logs for a pod' --argument container
  if test -z $container
      set -l container "-c $container"
  end

  kubectl get namespaces --no-headers  | fzy -p 'namespace > ' | \
    awk '{print $1}' | read -l namespace
  kubectl get pods --no-headers --namespace $namespace | fzy -p 'pod > '| \
    awk '{print $1}' | read -l pod
  kubectl logs -f $pod --namespace $namespace $container --since 12h
end
