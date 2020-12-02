#!/bin/bash
# ref: https://www.howtogeek.com/howto/30184/10-ways-to-generate-a-random-password-from-the-command-line/

PATTERN_ALL="!@:;_A-Z-a-z-0-9"
PATTERN_ALNUM="A-Za-z0-9"
DIGIT=${1:-16}
PARAM=${2:-"all"}

if [[ ${PARAM} = "alnum" ]]
then
	< /dev/urandom tr -dc ${PATTERN_ALNUM} | head -c${DIGIT};echo;
else
	< /dev/urandom tr -dc ${PATTERN_ALL} | head -c${DIGIT};echo;
fi



