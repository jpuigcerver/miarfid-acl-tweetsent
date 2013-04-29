#!/bin/bash

for f in $@; do
    awk '{print $1, $2}' $f > ${f}.tkn.1
    awk '{for(i=3;i<=NF;++i){ printf("%s ", $i);} printf("\n"); }' $f | \
	tr -d \' | tr -d \" | python tokenizer/twokenize.py | \
        python -c "
import re,sys
for l in sys.stdin:
    l = l.strip().split()
    for w in l:
	w = w.lower()
    	if w[:4] == 'http' or w[:3] == 'www': 
	    print '__URL__',
	    continue
        if w[0] == '@':
            print '@USERID',
            continue
	w = w.decode('utf-8')
        d = re.sub(r'([A-Za-z\!\?\.\¡\¿])\1+', r'\1', w, flags=re.U)
        d = re.sub(r'[\'\"]', r'', d, flags=re.U)
        print d.encode('utf-8'),
    print ''
" > ${f}.tkn.2
    paste ${f}.tkn.1 ${f}.tkn.2 > ${f}.tkn
    rm ${f}.tkn.1 ${f}.tkn.2
done
