#!/bin/bash -e
for i in $(eval echo "{1..$1}")
do
  echo '{"hello":"world"}' | fluent-cat test.test
done
