#!/bin/sh

grep -o "pcre:\"[^\"]\+" $1 | sed 's/pcre:"//' 
