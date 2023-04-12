#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar
# 等待进程被终止
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit
# Launch Polybar, using default config location ~/.config/polybar/config.ini
if type "xrandr"; then
    IFS=$'\n'  # must set internal field separator to avoid dumb
    for entry in $(xrandr --query | grep " connected"); do
        mon=$(cut -d" " -f1 <<< "$entry")
        status=$(cut -d" " -f3 <<< "$entry")

        tray_pos=""
        if [ "$status" == "primary" ]; then
            tray_pos="right"
            MONITOR=$mon TRAY_POS=$tray_pos polybar -r bar1 2>&1 | tee -a /tmp/polybar-monitor-"$mon".log & disown
        fi

    done
    unset IFS  # avoid mega dumb by resetting the IFS
    monitorCount=$(xrandr --listactivemonitors| grep Monitors|cut -d':' -f2)
    if [ $monitorCount > 1 ]; then
        extmon=$(xrandr --listactivemonitors| tail -fn1|cut -d'+' -f2|cut -d' ' -f1)
        EXT_MON=$extmon polybar bar2 2>&1 | tee -a /tmp/polybar2.log & disown
    fi
fi
echo "Ploybar launched..."

