#/bin/bash
for i in $(cat brew_formulae.txt);
do brew install $i
done

# generate a new list from an old machine with 'brew list --full-name -1' 
