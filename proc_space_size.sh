#!/bin/bash

fecho() {
    echo "`date '+%Y%m%d %H:%M:%S'` $@"
}

process="hello"
if [ $# -ge 1 ]; then
    process="$1"
fi

log="/tmp/heap.log"
pid=`pidof $process` 
if [ $? -eq 0 ]; then 
    fecho "find process $process, pid:$pid"
else
    fecho "find process $process, failed"
    exit 1
fi

cat /proc/${pid}/status | grep Vm  
#cat /proc/${pid}/maps | grep heap > $log
cat /proc/${pid}/maps > $log

#awk -F '[\\- ]' '{beg=strtonum("0x"$1); end=strtonum("0x"$2); printf("%s-%s %s %dK\n",$1, $2, $NF, (end-beg)/1024);}' $log
#awk -F '[\\- ]' '{beg=strtonum("0x"$1); end=strtonum("0x"$2); printf("%s %dK\n",$0, (end-beg)/1024);}' $log
awk -F '[\\- ]' '{
    beg=strtonum("0x"$1); 
    end=strtonum("0x"$2); segSize=end-beg; totSize+=segSize; 
    printf("%s %dK\n",$0, segSize/1024);
}
    END{ 
    printf("totSize %dK\n", totSize/1024);
}' $log 
