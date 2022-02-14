function kpod --description 'fuzzy searches through pods'
set pods (
    kubectl get pods --all-namespaces | \
    tail -n +2 | \
    fzf -m | \
    awk '{ print $1"|"$2 }'
)

for pod in $pods
    echo $pod | tr '|' ' ' && set namespace $1 && set pod_name $2 | xargs -n2 fish -c "kubectl -n \$namespace get pod \$podname"
    echo '---'
end
end