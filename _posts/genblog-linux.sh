#!/bin/bash

`touch $1`
echo --- >> $1
echo title: >> $1;
echo layout: >> $1;
echo category: >> $1;
echo --- >> $1

`cat $1 && vim $1`


