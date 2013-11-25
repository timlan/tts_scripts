#!/bin/bash

cons=(b d g k l p r t w)
fn=(c f h j m n s v x y z)
aff=(t~s t~c d~z d~j ^)
vowel=(a e i o u q - \' '$' '?' /)

# iterate through vowels first, then each type

for each_vowel in "${vowel[@]}"; do
  # vowel only
  echo "$each_vowel"

  # cons vowel
  for each_cons in "${cons[@]}"; do
    echo "$each_cons$each_vowel"
    # cons vowel fn
    for each_fn in "${fn[@]}"; do
      echo "$each_cons$each_vowel$each_fn"
    done
    # cons vowel aff
    for each_aff in "${aff[@]}"; do
      echo "$each_cons$each_vowel$each_aff"
    done
  done

  # vowel fn
  for each_fn in "${fn[@]}"; do
    echo "$each_vowel$each_fn"
  done

  # aff vowel
  for each_aff in "${aff[@]}"; do
    echo "$each_vowel$each_aff"
    # aff vowel fn
    #for each_fn in "${fn[@]}"; do
    #  echo "$each_aff$each_vowel$each_fn"
    #done
  done
done
