#!/bin/bash

while :
do
	list=$(ps -ef | grep gopls | awk '{print $8 "," $2}' | grep -e "gopls,")
	#echo $list
	for i in ${list}
	do
		pid=$(echo ${i} | sed -e "s/.*,//g") 
		#echo ${pid}
		if $(ps -ef | grep cpulimit | grep -q ${pid})
		then # match 
			echo PID${pid} is limited already.
		else # unmatch
			cpulimit --pid ${pid} --limit 50 --background
		fi
	done
	sleep 5
done

