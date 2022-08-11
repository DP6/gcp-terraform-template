for d in ./src/functions/* ; do
    if [[ -f "$d/tsconfig.json" ]]
    then
        npm i -g typescript
        (cd $d; npm run build; npm run move)
    fi
done