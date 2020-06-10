#!/bin/bash
# ref: https://www.howtogeek.com/howto/30184/10-ways-to-generate-a-random-password-from-the-command-line/

DIGIT=${1:-16}

< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${DIGIT};echo;


