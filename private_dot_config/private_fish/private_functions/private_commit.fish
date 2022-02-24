# `commit feat terraform update lock file` => `feat(terraform): update lock file`
# `commit feat! terraform update lock file` => `feat(terraform)!: update lock file`
# `commit chore^ update README => `chore: update README`
# `commit fix!^ rename README => `fix!: rename README`
function commit --description 'git conventional commits'
    set commit_message
    if count $argv > /dev/null
        set commit_type $argv[1]
        # Do not include commit scope and do not include breaking change
        if string match '*^' $commit_type > /dev/null
            set commit_type (string trim --chars="^" $commit_type)
            set commit_description (string join " " $commit_description $argv[2..-1])
            set commit_message "$commit_type: $commit_description"
        # Do not include commit scope and include breaking change
        else if string match '*!^' $commit_type > /dev/null
            set commit_type (string trim --chars="!^" $commit_type)
            set commit_description (string join " " $commit_description $argv[2..-1])
            set commit_message "$commit_type!: $commit_description"   
        # Include commit scope and optionally include breaking change
        else
            set commit_scope $argv[2]
            set breaking_change_char ""
            if string match '*!' $commit_type > /dev/null
                set breaking_change_char "!"
                set commit_type (string trim --chars="!" $commit_type)
            end
            set commit_description (string join " " $commit_description $argv[3..-1])
            set commit_message "$commit_type($commit_scope)$breaking_change_char: $commit_description"
        end
        git commit -s -m "$commit_message"
    else
        set whatthecommit (curl -s http://whatthecommit.com/index.txt)
        set commit_message "chore: $whatthecommit"
        git commit -s -m "$commit_message" -m "Commit generated by whatthecommit.com"
    end
    if type -q lolcat
        printf "\nCommit message ~ "%s"\n" $commit_message | lolcat
    else
        printf "\nCommit message ~ "%s"\n" $commit_message
    end
end
