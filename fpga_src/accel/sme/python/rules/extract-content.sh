#!/bin/sh

grep -o "content:\"[^\"]\+" $1 | sed 's/content:"//'
