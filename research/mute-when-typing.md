- [Problem](#sec-1)
- [Solution](#sec-2)
  - [Define keyboard and audio source](#sec-2-1)
  - [in a temp folder, touch a keypress file on every keypress](#sec-2-2)
  - [create mute file when the keypress file is updated](#sec-2-3)
  - [when the mute file is delete unmute](#sec-2-4)
  - [when the mute file is create mute](#sec-2-5)
  - [remove the mutefile if there hasn't been keystrokes in a while](#sec-2-6)
  - [Wait for all those async processes to exit](#sec-2-7)


# Problem<a id="sec-1"></a>

While on meetings my keyoard is really loud!

So let's solve that by muting my microphone while I'm typing!

# Solution<a id="sec-2"></a>

## Define keyboard and audio source<a id="sec-2-1"></a>

```sh
# Find via `xinput --list --name-only`
KEYBOARD="Kinesis Advantage2 Keyboard"
# Find via `pactl list sources | grep Name: | awk -F:\  '{print $2}' | grep input`
AUDIO_SOURCE="alsa_input.usb-Plantronics_Plantronics_Savi_7xx-M-00.analog-mono"
AUDIO_SOURCE="alsa_input.usb-0b0e_Jabra_SPEAK_510_USB_501AA5D89CCB020A00-00.analog-mono"
# touched on keypress
KEYPRESS_FILE=keypress
# exists while recent keypres
MUTE_FILE=mute
```

## in a temp folder, touch a keypress file on every keypress<a id="sec-2-2"></a>

```sh
cd $(mktemp -d)
# set -x
# set -e
(
while read keypress; do
    touch $KEYPRESS_FILE
done < <(xinput test-xi2 --root "$KEYBOARD")
) 2>&1 &
```

## create mute file when the keypress file is updated<a id="sec-2-3"></a>

```sh
(
    while read file; do
        if [ $file == $KEYPRESS_FILE ] ; then
            touch $MUTE_FILE
        fi
    done < <(inotifywait  -e create,attrib,modify --format '%f' --quiet . --monitor)
) 2>&1 &
```

## when the mute file is delete unmute<a id="sec-2-4"></a>

```sh
(
    while read file; do
        if [ $file == $MUTE_FILE ] ; then
            echo "UNMUTING"
            pactl set-source-mute $AUDIO_SOURCE 0
            # mute with alsa
            # amixer -D pulse sset Capture cap
            # mute everything with pactl
            # pactl list sources | grep Name: | awk -F:\  '{print $2}' | grep -v monitor \
            #     | xargs -n 1 -I X pactl set-source-mute X 0
            # get the currenty active window, send alt+a to mute-unmute
            # aw=$(xdotool getactivewindow)
            # xdotool search --name 'Zoom Meeting ID: .*' \
            #         windowactivate --sync \
            #         key alt+a \
            #         windowactivate $aw
        fi
    done < <(inotifywait  -e delete --format '%f' --quiet . --monitor)
) 2>&1 &
```

## when the mute file is create mute<a id="sec-2-5"></a>

```sh
(
    while read file; do
        if [ $file == $MUTE_FILE ] ; then
            echo "MUTING"
            pactl set-source-mute $AUDIO_SOURCE 1
            # amixer -D pulse sset Capture nocap
            # unmute everything with pactl
            # pactl list sources | grep Name: | awk -F:\  '{print $2}' | grep -v monitor \
            #     | xargs -n 1 -I X pactl set-source-mute X 1
            # aw=$(xdotool getactivewindow)
            # xdotool search --name 'Zoom Meeting ID: .*' \
            #         windowactivate --sync \
            #         key alt+a \
            #         windowactivate $aw
        fi
    done < <(inotifywait  -e create --format '%f' --quiet . --monitor)
) 2>&1 &
```

## remove the mutefile if there hasn't been keystrokes in a while<a id="sec-2-6"></a>

```sh
(
    while true ; do
        if [ ! -f $KEYPRESS_FILE ] ; then
            sleep 0.1
            continue
        elif [ ! -f $MUTE_FILE ] ; then
            sleep 0.1
            continue
        fi
        LAST_KEYSTROKE_TIME=$(ls -l  --time-style=+%H%M%S%N $KEYPRESS_FILE | awk '{print $6}')
        CURRENT_TIME=$(date +%H%M%S%N)
        TIME_SINCE_LAST_KEYSTROKE=$(($CURRENT_TIME - $LAST_KEYSTROKE_TIME))
        if [ $TIME_SINCE_LAST_KEYSTROKE -ge 200000000 ] ; then
            if [ -f $MUTE_FILE ] ; then
                rm $MUTE_FILE && sleep 0.1 && rm -f $MUTE_FILE
            fi
        fi
    done
) 2>&1 &
```

## Wait for all those async processes to exit<a id="sec-2-7"></a>

```sh
wait
```
