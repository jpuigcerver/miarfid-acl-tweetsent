#!/usr/bin/env python
# -*- coding: utf-8 -*-
from sys import argv, exit, stderr, stdin, stdout
from nltk.stem.snowball import SpanishStemmer

def LoadVocabulary(fname):
    V = {}
    try:
        fvoc = open(fname, 'r')
        for w in fvoc:
            w = w.strip().decode('utf-8')
            if w not in V: 
                V[w] = len(V)
        fvoc.close()
        return V
    except Exception as ex:
        stderr.write('Exception: %s\n' % str(ex))
        return None

def LoadLabels(fname):
    try:
        L = {}
        fl = open(fname, 'r')
        for l in fl:
            l = l.split()
            if len(l) < 2: continue
            if l[1] == 'NONE':
                L[l[0]] = 1
            elif l[1] == 'N+':
                L[l[0]] = 2
            elif l[1] == 'N':
                L[l[0]] = 3
            elif l[1] == 'NEU':
                L[l[0]] = 4
            elif l[1] == 'P':
                L[l[0]] = 5
            elif l[1] == 'P+':
                L[l[0]] = 6
            else:
                stderr.write('Warning: Unknown label "%s"\n' % l[1])
        fl.close()
        return L
    except Exception as ex:
        stderr.write('Exception: %s\n' % str(ex))
        return None

def ProcessCorpus(V, L):
    try:
        stem = SpanishStemmer()
        for l in stdin:
            l = l.split()
            if len(l) < 3: 
                stderr.write('Warning: Short line: \"%s\"\n' % ' '.join(l))
                continue
            tid = l[0]
            uid = l[1]
            lv = [0 for w in V]
            for w in l[2:]:
                w = stem.stem(w.decode('utf-8'))
                d = V.get(w, None)
                if d is None: 
                    #stderr.write('Warning: \"%s\" not in the lexicon\n' % w);
                    continue
                lv[d] = lv[d] + 1
            if sum(lv) == 0:
                stderr.write('Warning: %s with null vector. Label: %d\n' % (tid, L[l[0]]) )
            stdout.write('%d ' % L[l[0]])
            for i in range(len(lv)):
                stdout.write('%d:%d ' % (i+1, lv[i]))
            stdout.write('# %s %s\n' % (tid, uid))
        return 0
    except Exception as ex:
        stderr.write('Exception: %s\n' % repr(ex))
        return 1

def main():
    if len(argv) < 3:
        stderr.write('Usage: %s <vocab> <labels>\n' % argv[0])
        return 1
    # Load vocabulary
    V = LoadVocabulary(argv[1])
    if V is None: return 1
    L = LoadLabels(argv[2])
    if L is None: return 1
    return ProcessCorpus(V, L)

if __name__ == '__main__':
    exit(main())
