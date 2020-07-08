#!/bin/bash
datediff() {
    d1=$(date -d "$1" +%s)
    d2=$(date -d "$2" +%s)
    echo $(( (d1 - d2) / 86400 )) 
}

index=0
limday=7
date=$(date --rfc-3339=date)

yc compute snapshot list |awk '{print $2}' > /tmp/IDs 
sed -i '1,3d;/^$/d' /tmp/IDs

while read line; do
    array[$index]="$line"
    index=$(($index+1))
done < /tmp/IDs

for ((a=0; a < ${#array[*]}; a++))
        do
        create_date=$(yc compute snapshot get ${array[$a]}|grep create|cut -c14-23)
        diff=$(datediff $date $create_date)
        if (( "$diff" << "$limday" ))
                then
#               echo $create_date >> /var/log/snapshot_deleted.log
#               echo $diff >> /var/log/snapshot_deleted.log

#в этом состоянии скрипт ничего не удаляемт. Вместо этого он вычисляет старость снапшотов
#и выводит все снапшоты старше $limday на экран (информацию по каждому из них)
#если нужно, чтобы он удалял, коментируем следующую строку и раскоментируем строчку через

                yc compute snapshot get ${array[$a]} # >> /var/log/snapshot_deleted.log
#               yc compute snapshot rm ${array[$a]}

                else
                echo ''
#               echo ${array[$a]} "разница меньше " $limday
                fi
done
rm /tmp/IDs
