#!/bin/bash

name="sophimp"
echo $name
name="gooyuan"
echo $name

echo "current script: $0"
echo "params count: $#"
echo "first param: $1"

for i in "$*"; do
    echo $i
done

for i in "$@"; do
    echo $i
done

a=0
b=2

if [ $a -a $b ]
then
    echo "$a -le $b"
fi

echo "current process: $$"
echo "last process: $!"
echo "success: $?"

function define()
{
    echo function can define post?
}
