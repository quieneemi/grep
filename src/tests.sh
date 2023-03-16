#!/bin/bash

OS=$(uname -s)
query="grep"
path="text.txt"
template="template.txt"
method="md5"
if [ $OS = "Linux" ]
then
method="md5sum"
fi

tests=(
    "$query $path $path"
    "-i unix $path"
    "-v $query $path"
    "-c $query $path"
    "-l $query $path $path $path"
    "-n $query $path"

    "-o $query $path"
    "-h $query $path $path"
    "$query -s 123123"
    "-f $template $path"
)

function test {
    grep=$(grep $1 2>/dev/null | $method)
    my_grep=$(./my_grep $1 2>/dev/null | $method)

    if [ "$grep" != "$my_grep" ]
    then
    echo "FAILED $1"
    else
    echo "OK $1"
    fi
}

for i in ${!tests[*]}
do
test "${tests[$i]}"
done

echo "my_grep tests complete"
