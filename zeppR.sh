#!/bin/bash
# primitive launcher - pkill needed to end process! 
# R -e "shiny::runApp('.', launch.browser = TRUE)"

# kill app on exiting tab: 
PIDFILE=".zeppR.pid"

if [ -f "$PIDFILE" ]; then
    PID=$(cat "$PIDFILE")

    if kill -0 "$PID" 2>/dev/null; then
        kill "$PID"
        rm "$PIDFILE"
        exit 0
    else
        rm "$PIDFILE"
    fi
fi

R -e "shiny::runApp('.', launch.browser = function(url) system2('firefox', url))" &
echo $! > "$PIDFILE"
