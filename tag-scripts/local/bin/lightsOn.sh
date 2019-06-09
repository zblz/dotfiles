#!/bin/bash
# lightsOn.sh

# Copyright (c) 2013 iye.cba at gmail com
# url: https://github.com/iye/lightsOn
# This script is licensed under GNU GPL version 2.0 or above

# Description: Bash script that prevents the screensaver and display power
# management (DPMS) to be activated when you are watching Flash Videos
# fullscreen on Firefox and Chromium.
# Can detect mplayer, minitube, and VLC when they are fullscreen too.
# Also, screensaver can be prevented when certain specified programs are running.
# lightsOn.sh needs xscreensaver or kscreensaver to work.

# HOW TO USE: Start the script with the number of seconds you want the checks
# for fullscreen to be done. Example:
# "./lightsOn.sh 120 &" will Check every 120 seconds if Mplayer, Minitube
# VLC, Firefox, Chrome or Chromium are fullscreen and delay screensaver and Power Management if so.
# You want the number of seconds to be ~10 seconds less than the time it takes
# your screensaver or Power Management to activate.
# If you don't pass an argument, the checks are done every X seconds.
# Where X is calculated based on your system sleep time, with a minimum of $default_sleep_delay.
#
# An optional array variable exists here to add the names of programs that will delay the screensaver if they're running.
# This can be useful if you want to maintain a view of the program from a distance, like a music playlist for DJing,
# or if the screensaver eats up CPU that chops into any background processes you have running,
# such as realtime music programs like Ardour in MIDI keyboard mode.
# If you use this feature, make sure you use the name of the binary of the program (which may exist, for instance, in /usr/bin).

# DEBUG=0 for no output
# DEBUG=1 for sleep prints
# DEBUG=2 for everything
DEBUG=0

# this is actually the minimum allowed dynamic delay; also the default (if something fails)
default_sleep_delay=50

# Modify these variables if you want this script to detect if Mplayer,
# VLC, Minitube, or Firefox or Chromium Flash Video are Fullscreen and disable
# xscreensaver/kscreensaver and PowerManagement.
mplayer_detection=1
kodi_detection=1
vlc_detection=1
chromium_flash_detection=1
chromium_html5_detection=1
chromium_pepper_flash_detection=1
chrome_pepper_flash_detection=1
chrome_html5_detection=1

# Names of programs which, when running, you wish to delay the screensaver.
delay_progs=('impressive') # For example ('ardour2' 'gmpc')

# Role of windows that, when present, should delay the screensaver
# skype call windows have role "CallWindow"
delay_roles=('CallWindow' 'browser-window')

# YOU SHOULD NOT NEED TO MODIFY ANYTHING BELOW THIS LINE

log() {
    if [ $DEBUG -eq 2 ]; then
        echo $@
    elif [ $DEBUG -eq 1 ]; then
        if [ "$(echo $@ | grep -c "sleeping for")" == "1" ]; then
            echo $@
        fi
    fi
}

# enumerate all the attached screens
displays=""
while read id
do
    displays="$displays $id"
done < <(xvinfo | sed -n 's/^screen #\([0-9]\+\)$/\1/p')

checkDelayProgs()
{
    log "checkDelayProgs()"
    for prog in "${delay_progs[@]}"; do
        if [ `pgrep -lfc "$prog"` -ge 1 ]; then
            log "checkDelayProgs(): Delaying the screensaver because a program on the delay list, \"$prog\", is running..."
            delayScreensaver
            break
        fi
    done
}

checkDelayRoles()
{
    log "checkDelayRoles()"
    for display in $displays; do
        activ_win_ids=$(DISPLAY=:${display} xprop -root _NET_CLIENT_LIST_STACKING | sed 's/.*# //' | sed 's/,//g')
        for activ_win_id in $activ_win_ids; do
            win_role=`xprop -id $activ_win_id | grep "WM_WINDOW_ROLE(STRING)"`
            if [[ -n $win_role ]]; then
                for title in "${delay_roles[@]}"; do
                    if [[ $win_role = *$title* ]]; then
                        log "checkDelayRoles(): Delaying screensaver because window with role \"$title\" found..."
                        delayScreensaver
                        break
                    fi
                done
            fi
        done
    done
}

checkFullscreen()
{
    log "checkFullscreen()"
    # loop through every display looking for a fullscreen window
    for display in $displays
    do
        #get id of active window and clean output
        #activ_win_id=`DISPLAY=:0.${display} xprop -root _NET_ACTIVE_WINDOW | cut -f 2 -d '#'`
        #activ_win_id=$(DISPLAY=:${display} xprop -root _NET_CLIENT_LIST_STACKING | sed 's/.*\, //')
        #previously used _NET_ACTIVE_WINDOW, but it didn't work with some flash
        #players (eg. Twitch.tv) in firefox. Using sed because id lengths can
        #vary.
        activ_win_ids=$(DISPLAY=:${display} xprop -root _NET_CLIENT_LIST_STACKING | sed 's/.*# //' | sed 's/,//g')

        # Skip invalid window ids (commented as I could not reproduce a case
        # where invalid id was returned, plus if id invalid
        # isActivWinFullscreen will fail anyway.)
        #if [ "$activ_win_id" = "0x0" ]; then
        #     continue
        #fi

        # Check if Active Window (the foremost window) is in fullscreen state
        for activ_win_id in $activ_win_ids; do
            if [[ -n $activ_win_id ]]; then
                isActivWinFullscreen=`DISPLAY=:0.${display} xprop -id $activ_win_id | grep _NET_WM_STATE_FULLSCREEN`
                isActivWinAbove=`DISPLAY=:0.${display} xprop -id $activ_win_id | grep _NET_WM_STATE_ABOVE`
                #log "checkFullscreen(): Display: $display isFullScreen: \"$isActivWinFullscreen\""
                #log "checkFullscreen(): Display: $display isAbove: \"$isActivWinAbove\""
                if [[ "$isActivWinFullscreen" = *NET_WM_STATE_FULLSCREEN* || "$isActivWinAbove" = *NET_WM_STATE_ABOVE* ]];then
                    activ_win_title=`xprop -id $activ_win_id | grep "WM_CLASS(STRING)" | cut -f 2 -d "="`
                    log "checkFullscreen(): Fullscreen detected $activ_win_title"
                    isAppRunning $activ_win_id
                    var=$?
                    if [[ $var -eq 1 ]];then
                        delayScreensaver
                        return
                    fi
                # If no Fullscreen active => set dpms on
                else
                    xset dpms
                fi
            fi
        done
        log "checkFullscreen(): NO fullscreen detected"
    done
}

isAppRunning()
{
    activ_win_id=$1
    log "isAppRunning()"
    #Get title of active window
    activ_win_title=`xprop -id $activ_win_id | grep "WM_CLASS(STRING)"`

    # Check if user want to detect Video fullscreen on Chromium, modify variable chromium_flash_detection if you dont want Chromium detection
    if [ $chromium_flash_detection == 1 ];then
        if [[ "$activ_win_title" = *exe* || "$activ_win_title" = *chromium* ]];then
        # Check if Chromium Flash process is running
            flash_process=`pgrep -lfc ".*chromium.*flashp.*"`
            if [[ $flash_process -ge 1 ]];then
                log "isAppRunning(): chromium flash fullscreen detected"
                return 1
            fi
        fi
    fi

    # Check if user want to detect html5 fullscreen on Chromium, modify variable chrome_html5_detection if you dont want Chromium html5 detection.
    if [ $chromium_html5_detection == 1 ];then
        if [[ "$activ_win_title" = *chromium* ]];then
        # Check if Chromium html5 process is running
            chromium_process=`pgrep -lfc "chromium"`
            if [[ $chromium_process -ge 1 ]];then
                log "isAppRunning(): chromium html5 fullscreen detected"
                return 1
            fi
        fi
    fi

    # Check if user want to detect flash fullscreen on Chromium, modify variable chromium_pepper_flash_detection if you dont want Chromium pepper flash detection.
    if [ $chromium_pepper_flash_detection == 1 ];then
        if [[ "$activ_win_title" = *chromium* ]];then
        # Check if Chromium Flash process is running
            chrome_process=`pgrep -lfc "chromium-browser --type=ppapi "`
            if [[ $chrome_process -ge 1 ]];then
                log "isAppRunning(): chromium flash fullscreen detected"
                return 1
            fi
        fi
    fi

    # Check if user want to detect flash fullscreen on Chrome, modify variable chrome_pepper_flash_detection if you dont want Chrome pepper flash detection.
    if [ $chrome_pepper_flash_detection == 1 ];then
        if [[ "$activ_win_title" = *google-chrome* ]];then
        # Check if Chrome Flash process is running
            chrome_process=`pgrep -lfc "(c|C)hrome --type=ppapi "`
            if [[ $chrome_process -ge 1 ]];then
                log "isAppRunning(): chrome flash fullscreen detected"
                return 1
            fi
        fi
    fi

    # Check if user want to detect html5 fullscreen on Chrome, modify variable chrome_html5_detection if you dont want Chrome html5 detection.
    if [ $chrome_html5_detection == 1 ];then
        if [[ "$activ_win_title" = *google-chrome* ]];then
        # Check if Chrome html5 process is running
            #chrome_process=`pgrep -lfc "(c|C)hrome --type=gpu-process "`
            # Sorry, I didn't see any gpu-process in my pc
            chrome_process=`pgrep -lfc "(c|C)hrome"`
            if [[ $chrome_process -ge 1 ]];then
                log "isAppRunning(): chrome html5 fullscreen detected"
                return 1
            fi
        fi
    fi

    #check if user want to detect mplayer fullscreen, modify variable mplayer_detection
    if [ $mplayer_detection == 1 ];then
        if [[ "$activ_win_title" = *mplayer* || "$activ_win_title" = *MPlayer* ]];then
            #check if mplayer is running.
            #mplayer_process=`pgrep -l mplayer | grep -wc mplayer`
            mplayer_process=`pgrep -lc mplayer`
            if [ $mplayer_process -ge 1 ]; then
                log "isAppRunning(): mplayer fullscreen detected"
                return 1
            fi
        fi
    fi

    #check if user want to detect kodi fullscreen, modify variable kodi_detection
    if [ $kodi_detection == 1 ];then
        if [[ "$activ_win_title" = *Kodi* || "$activ_win_title" = *kodi* ]];then
            #check if kodi is running.
            kodi_process=`pgrep -lc kodi`
            if [ $kodi_process -ge 1 ]; then
                log "isAppRunning(): kodi fullscreen detected"
                return 1
            fi
        fi
    fi

    # Check if user want to detect vlc fullscreen, modify variable vlc_detection
    if [ $vlc_detection == 1 ];then
        if [[ "$activ_win_title" = *vlc* ]];then
            #check if vlc is running.
            #vlc_process=`pgrep -l vlc | grep -wc vlc`
            vlc_process=`pgrep -lc vlc`
            if [ $vlc_process -ge 1 ]; then
                log "isAppRunning(): vlc fullscreen detected"
                return 1
            fi
        fi
    fi

return 0
}

delayScreensaver()
{
    # reset inactivity time counter so screensaver is not started
    log "delayScreensaver(): Delaying with xdg-screensaver..."
    xdg-screensaver reset

    #Check if DPMS is on. If it is, deactivate. If it is not, do nothing.
    dpmsStatus=`xset -q | grep -ce 'DPMS is Enabled'`
    if [ $dpmsStatus == 1 ];then
        xset -dpms
        # moved to checkFullscreen().
        #xset dpms
    fi
}

_sleep()
{
    if [ $dynamicDelay -eq 0 ]; then
        log "sleeping for $delay"
        sleep $delay
    else
        if [ -f /sys/class/power_supply/AC/online ]; then
            if [ "$(cat /sys/class/power_supply/AC/online)" == "1" ]; then
                system_sleep_delay=$(gsettings get org.gnome.settings-daemon.plugins.power sleep-display-ac 2>/dev/null)
            else
                system_sleep_delay=$(gsettings get org.gnome.settings-daemon.plugins.power sleep-display-battery 2>/dev/null)
            fi
        fi
        if [ "$(echo $system_sleep_delay | egrep -c "^[0-9]+$")" == "1" ]; then
            if [ $system_sleep_delay -le $(($default_sleep_delay+5)) ]; then
                sleep_delay=$default_sleep_delay
            else
                sleep_delay=$(($system_sleep_delay-5))
            fi
        else
            sleep_delay=$default_sleep_delay
        fi
        log "sleeping for $sleep_delay (system idle timeout is $system_sleep_delay)"
        sleep $sleep_delay
    fi
}

delay=$1
dynamicDelay=0

# If argument empty, use dynamic delay.
if [ -z "$1" ];then
    dynamicDelay=1
    log "no delay specified, dynamicDelay=1"
fi

# If argument is not integer quit.
if [[ $1 = *[^0-9]* ]]; then
    echo "The Argument \"$1\" is not valid, not an integer"
    echo "Please use the time in seconds you want the checks to repeat."
    echo "You want it to be ~10 seconds less than the time it takes your screensaver or DPMS to activate"
    exit 1
fi

while true
do
    checkDelayProgs
    checkDelayRoles
    checkFullscreen
    _sleep $delay
done

exit 0
