#!/usr/bin/zsh 
MAXNUM=16

# Start from KloudGen2 so that that they can all copy their method from KloudGen1
for (( i = 2; i < $MAXNUM+1; i++ )); do
FILENAME="HelpSource/Classes/KloudGen$i.schelp"
echo "Generating $FILENAME...

"

echo "TITLE:: KloudGen$i
summary:: A $i channel granular cloud generator
categories:: UGens>GranularSynthesis
related:: Classes/KloudGen, Classes/PlayBuf

A $i output channel cloud synthesis UGEN. 

See LINK::Guides/KloudGen:: for more information on how to use it + examples. 

CLASSMETHODS::
COPYMETHOD:: KloudGen1 *ar

" > $FILENAME

done
