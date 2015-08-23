for j in *pdf ; do
    echo -n $j
    rm -f /tmp/tmp_$j
    rm -f /tmp/head_$j
    for ((i=1;i<=`pdfinfo $j|grep Pages|awk '{print $2}'`;i++)); do
        o=`pdftotext -f 1 -l 1 -x 0 -y 0 -W 560 -H 60 $j - | grep [0-9]`
        o=$((($o % 2) + 1))
        echo -n .
        echo -n $i
        if [[ $(( ($i + $o) % 2 )) == 0 ]]; then
            # even page number, slightly left
            pdftotext -f $i -l $i -nopgbrk -x 60 -y 110 -W 230 -H 680 $j - >> /tmp/tmp_$j
            pdftotext -f $i -l $i -nopgbrk -x 300 -y 110 -W 230 -H 680 $j - >> /tmp/tmp_$j
            pdftotext -f $i -l $i -nopgbrk -x 60 -y 110 -W 16 -H 680 $j - >> /tmp/head_$j
            pdftotext -f $i -l $i -nopgbrk -x 300 -y 110 -W 16 -H 680 $j - >> /tmp/head_$j
        else
            # odd page number. slightly right
            pdftotext -f $i -l $i -nopgbrk -x 68 -y 118 -W 230 -H 680 $j - >> /tmp/tmp_$j
            pdftotext -f $i -l $i -nopgbrk -x 308 -y 118 -W 230 -H 680 $j - >> /tmp/tmp_$j
            pdftotext -f $i -l $i -nopgbrk -x 68 -y 110 -W 16 -H 680 $j - >> /tmp/head_$j
            pdftotext -f $i -l $i -nopgbrk -x 308 -y 110 -W 16 -H 680 $j - >> /tmp/head_$j
        fi
    done
    cat /tmp/tmp_$j | sed 's/泝/① /g' | sed 's/沴/② /g' | sed 's/沊/③ /g' | sed 's///g' | \
        sed 's/（/(/g' | sed 's/）/)/g' | sed 's/〔/[/g' | sed 's/〕/]/g' | sed "s/’/\'/g" > `echo $j | sed 's/pdf/txt/'`
    cp /tmp/head_$j head_$j.txt
    echo .
done
for i in [012]*.txt ; do echo $i; ./parse.pl $i > parsed/$i ; done
for i in head_* ; do echo -n $i ; echo -n "    ";cat $i | sed 's///g' | grep -v ^〔 | grep -v ^$ > parsed/$i ; done
