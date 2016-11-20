#!/bin/bash

# low battery in %
LOW_BATTERY="10"
# very low battery in %
VERY_LOW_BATTERY="7"
# critical battery in % (execute action)
CRITICAL_BATTERY="4"
# action
ACTION="systemctl hibernate"



while true; do
    if grep -q 1 /sys/class/power_supply/AC/online; then
        #echo "AC connected, sleeping for 10 minutes..."
        touch /tmp/stop_blink
        sleep 600
        continue
    fi
    BATLEVEL=`cat /sys/devices/platform/smapi/BAT0/remaining_percent`
    POWER=`cat /sys/devices/platform/smapi/BAT0/power_avg`
    CAPACITY=`cat /sys/devices/platform/smapi/BAT0/remaining_capacity`
    MINLEFT=$(echo "scale=2; -1*$CAPACITY/$POWER*60" | bc -l)


    if [ "$BATLEVEL" -le "$CRITICAL_BATTERY" ]; then
        notify-send -u critical "La bateria és criticament baixa - ${BATLEVEL}% ($MINLEFT min)."
        notify-send -u critical "L'ordinador entrarà en hibernació en 10 segons!"
        sleep 10
        $ACTION
    elif [ "$BATLEVEL" -le "$VERY_LOW_BATTERY" ]; then
        notify-send -u critical "La bateria és molt baixa - ${BATLEVEL}% ($MINLEFT min)."
        notify-send -u critical "L'ordinador entrarà en hibernació quan la bateria estigui per sota de ${CRITICAL_BATTERY}%"
        touch /tmp/stop_blink
        sleep 1
        sudo $HOME/bin/blink_powerlight.sh 0.25 &
    elif [ "$BATLEVEL" -le "$LOW_BATTERY" ]; then
        notify-send -u critical "La bateria és baixa - ${BATLEVEL}% ($MINLEFT min)."
        touch /tmp/stop_blink
        sleep 1
        sudo $HOME/bin/blink_powerlight.sh 0.5 &
    else
        touch /tmp/stop_blink
    fi
    #echo "Battery - ${BATLEVEL}% ($MINLEFT min)."
    factor=20
    sleeps=$(echo $MINLEFT*60/$factor | bc )
    #echo "Sleeping for $(echo $sleeps/60 | bc ) minutes..."
    sleep $sleeps
done
