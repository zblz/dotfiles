function k8scontext -d 'Set kubectl context'
    kubectl config get-contexts -o name | fzy | xargs kubectl config use-context
end
