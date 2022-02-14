function ksvc --description 'fuzzy searches through services'
set svcs (
    kubectl get svc --all-namespaces | \
    tail -n +2 | \
    fzf -m | \
    awk '{ print $1"|"$2 }'
)

for svc in $svcs
    echo $svc | tr '|' ' ' && set namepace $1 && set service $2 | xargs -n2 fish -c "kubectl -n \$namespace get svc \$service"
    echo '---'
end
end