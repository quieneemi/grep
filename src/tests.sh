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
    "$query $path"
    "$query $path $path"
    "$path -e [grep] -e [0-9]"
    "$path -e [grep] -e [0-9] -f $template"
    "$path -e [grep]"
    "$query $path -i"
    "$query $path -v"
    "$query $path -c"
    "$query $path -l"
    "$query $path -n"
    "$query $path $path -h"
    "$query $path $path -s"
    "$query $path -f $template"

    "$path -e [0-9]"
    "$path -e [grep] -i"
    "-e [grep] -i $path"
    "$path -e [grep] -v"
    "$path -e [grep] -c"
    "$path -e [grep] -l"
    "$path -e [grep] -n"
    "$path $path -e [grep] -h"
    "$path $path -e [grep] -s"
    "$path -e [grep] -f $template"
    "$path -e [grep] -iv"
    "$path -e [grep] -ivc"
    "$path -e [grep] -ivcl"
    "$path -e [grep] -ivcln"
    "$path $path -e [grep] -ivclnh"
    "$path $path -e [grep] -ivclnhs"
    "$path $path -e [grep] -ivclnhs -f $template"
    "$path -e [grep] -vc"
    "$path -e [grep] -vcl"
    "$path -e [grep] -vcln"
    "$path $path -e [grep] -vclnh"
    "$path $path -e [grep] -vclnhs"
    "$path $path -e [grep] -vclnhs -f $template"
    "$path -e [grep] -cl"
    "$path -e [grep] -cln"
    "$path $path -e [grep] -clnh"
    "$path $path -e [grep] -clnhs"
    "$path $path -e [grep] -clnhs -f $template"
    "$path -e [grep] -ln"
    "$path $path -e [grep] -lnh"
    "$path $path -e [grep] -lnhs"
    "$path $path -e [grep] -lnhs -f $template"
    "$path $path -e [grep] -nh"
    "$path $path -e [grep] -nhs"
    "$path $path -e [grep] -nhs -f $template"
    "$path $path -e [grep] -hs"
    "$path $path -e [grep] -hs -f $template"
    "$path $path -e [grep] -s -f $template"

    "$path -f $template -i"
    "$path -f $template -v"
    "$path -f $template -c"
    "$path -f $template -l"
    "$path -f $template -n"
    "$path $path -f $template -h"
    "$path $path -f $template -s"
    "$path -f $template -iv"
    "$path -f $template -ivc"
    "$path -f $template -ivcl"
    "$path -f $template -ivcln"
    "$path $path -f $template -ivclnh"
    "$path $path -f $template -ivclnhs"
    "$path -f $template -vc"
    "$path -f $template -vcl"
    "$path -f $template -vcln"
    "$path $path -f $template -vclnh"
    "$path $path -f $template -vclnhs"
    "$path -f $template -cl"
    "$path -f $template -cln"
    "$path $path -f $template -clnh"
    "$path $path -f $template -clnhs"
    "$path -f $template -ln"
    "$path $path -f $template -lnh"
    "$path $path -f $template -lnhs"
    "$path $path -f $template -nh"
    "$path $path -f $template -nhs"
    "$path $path -f $template -hs"

    "$query $path -iv"
    "$query $path -ivc"
    "$query $path -ivcl"
    "$query $path -ivcln"
    "$query $path $path -ivclnh"
    "$query $path $path -ivclnhs"
    "$query $path -icl"
    "$query $path -icln"
    "$query $path $path -iclnh"
    "$query $path $path -iclnhs"
    "$query $path $path -iclnhs -f $template"
    "$query $path -iln"
    "$query $path $path -ilnh"
    "$query $path $path -ilnhs"
    "$query $path $path -ilnhs -f $template"
    "$query $path $path -inh"
    "$query $path $path -inhs"
    "$query $path $path -inhs -f $template"
    "$query $path $path -ihs"
    "$query $path $path -ihs -f $template"

    "$query $path -vc"
    "$query $path -vcl"
    "$query $path -vcln"
    "$query $path $path -vclnh"
    "$query $path $path -vclnhs"
    "$query $path $path -vclnhs -f $template"
    "$query $path -vln"
    "$query $path $path -vlnh"
    "$query $path $path -vlnhs"
    "$query $path $path -vlnhs -f $template"
    "$query $path $path -vnh"
    "$query $path $path -vnhs"
    "$query $path $path -vnhs -f $template"
    "$query $path $path -vhs"
    "$query $path $path -vhs -f $template"
    "$query $path -vs -f $template"

    "$query $path -cl"
    "$query $path -cln"
    "$query $path $path -clnh"
    "$query $path $path -clnhs"
    "$query $path $path -clnhs -f $template"
    "$query $path $path -cnh"
    "$query $path $path -cnhs"
    "$query $path $path -cnhs -f $template"
    "$query $path $path -chs"
    "$query $path $path -chs -f $template"
    "$query $path $path -cs -f $template"
    "$query $path $path -c -f $template"

    "$query $path -ln"
    "$query $path $path -lnh"
    "$query $path $path -lnhs"
    "$query $path $path -lnhs -f $template"
    "$query $path $path -lhs"
    "$query $path $path -lhs -f $template"
    "$query $path $path -ls -f $template"

    "$query $path $path -nh"
    "$query $path $path -nhs"
    "$query $path $path -nhs -f $template"
    "$query $path $path -ns -f $template"

    "$query $path $path -hs"
    "$query $path $path -hs -f $template"

    "$query $path $path -s -f $template"
)

simple=(
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

# for i in ${!tests[*]}
# do
# test "${tests[$i]}"
# done

for i in ${!simple[*]}
do
test "${simple[$i]}"
done

echo "my_grep tests complete"
