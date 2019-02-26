# Gate-Code

uses https://github.com/branning/hs100

Requires supervise: https://cr.yp.to/daemontools/supervise.html

needs python module evdev

add a task in crontab:
# Every day at 5am restart the gate so that you make sure the gate is running and also this resets the USB-controlled power strip because sometimes it bugs
0 5 * * * /home/blake/excursion/yassine/start-gate.sh
