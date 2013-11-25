#!/bin/bash

cons=(b d g k l p r t w '"' '!')
fn=(c f h j m n s v x y z '*' '#' ':')
aff=(t~s t~c d~z d~j ^)
vowel=(a e i o u q - / \' '$' '?')

declare -A ermapping

ermapping['"']=k
ermapping['!']=p
ermapping['*']=c
ermapping['#']=m
ermapping[':']=x

function isinarray()
{
  for eachElement in "${@:2}"; do
    if [ "$eachElement" = "$1" ]; then
      return 0
    fi
  done
  return 1;
}

function getNextChar()
{
  word="$1"
  index="$2"
  if [ "$index" -ge "${#word}" ]; then
    echo ""
    return
  fi
  if [ $(( $index + 3 )) -le "${#word}" ] && isinarray "${input:$index:3}" "${aff[@]}"; then
    echo "${input:$index:3}"
    return
  fi
  echo "${input:$index:1}"
}

if [ "$#" -eq 0 ]; then
  echo "Usage: $0 <word>" >&2
  echo "  Where <word> is the word to split." >&2
  echo "  Outputs as CSV (unquoted)." >&2
fi

while [ "$#" -gt 0 ]; do

  input="$1"

  if isinarray "$(getNextChar "$input" 0)" "${fn[@]}" || isinarray "$(getNextChar "$input" 0)" "${aff[@]}"; then
    input='?'"$input"
  fi

  i="$(( ${#input} - 1 ))"

  if isinarray "${input:$i:1}" "${cons[@]}"; then
    input="$input"'?'
  fi

  index=0

  curChar="$(getNextChar "$input" $index)"

  while [ "$curChar" != "" ]; do
    if [ "${ermapping["$curChar"]}" != "" ]; then
      curChar="${ermapping["$curChar"]}"
    fi
    if [ "$(getNextChar "$input" "$(( $index + ${#curChar} ))")" = "" ]; then
      echo "$curChar"
      let index+="${#curChar}"
      curChar="$(getNextChar "$input" $index)"
      continue
    fi
    if isinarray "$curChar" "${vowel[@]}"; then
      if [ "$(getNextChar "$input" "$(( $index + ${#curChar} ))")" = "$curChar" ]; then
        echo -n "$curChar"'^,'
        let index+="${#curChar}"
        curChar="$(getNextChar "$input" $index)"
        continue
      fi
      if isinarray "$(getNextChar "$input" "$(( $index + ${#curChar} ))")" "${fn[@]}" || isinarray "$(getNextChar "$input" "$(( $index + ${#curChar} ))")" "${aff[@]}"; then
        echo -n "$curChar"
        let index+="${#curChar}"
        curChar="$(getNextChar "$input" $index)"
        continue
      fi
      echo -n "$curChar,"
    elif isinarray "$curChar" "${fn[@]}" || isinarray "$curChar" "${aff[@]}"; then
      echo -n "$curChar,"
    else
      echo -n "$curChar"
    fi
    let index+="${#curChar}"
    curChar="$(getNextChar "$input" $index)"
  done

  shift

done
