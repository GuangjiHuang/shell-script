#!/bin/bash
# ============================================================
# show-weather.sh — 显示天气 + 日历 + 大字时钟
# 依赖: curl, toilet/figlet (可选)
# ============================================================

DateColumn=34
TimeColumn=61

# 获取天气 (可修改城市)
CITY="${WEATHER_CITY:-Shenzhen}"
curl "wttr.in/${CITY}?0" --silent --max-time 3 > /tmp/vr-now-weather || true

readarray -t aWeather < /tmp/vr-now-weather
rm -f /tmp/vr-now-weather

# 天气是否有效
weather_ok=false
if [[ "${aWeather[0]:-}" == "Weather report:"* ]]; then
    weather_ok=true
    echo "${aWeather[@]}"
else
    echo "+============================+"
    echo "| Weather unavailable now!!! |"
    echo "| Check with: curl wttr.in/${CITY}?0 |"
    echo "+============================+"
fi
echo ""

# ─── 日历 ───
tput sc
i=0
while [ $((++i)) -lt 10 ]; do tput cuu1; done

if [ "$weather_ok" = true ]; then
    Column=$((DateColumn - 10))
    tput cuf "$Column"
    printf '          '
else
    tput cuf "$DateColumn"
fi

cal > /tmp/vr-terminal1 2>/dev/null
tr -cd '\11\12\15\40\60-\136\140-\176' < /tmp/vr-terminal1 > /tmp/vr-terminal
rm -f /tmp/vr-terminal1

CalLineCnt=1
Today="$(date +'%e')"

printf '\033[32m'

while IFS= read -r Cal; do
    printf '%s' "$Cal"
    if [ "$CalLineCnt" -gt 2 ]; then
        tput cub 22
        for ((j = 0; j <= 18; j += 3)); do
            Test="${Cal:$j:2}"
            if [ "$Test" = "$Today" ]; then
                printf '\033[7m'
                printf '%s' "$Today"
                printf '\033[0m'
                printf '\033[32m'
                tput cuf 1
            else
                tput cuf 3
            fi
        done
    fi
    tput cud1
    tput cuf "$DateColumn"
    CalLineCnt=$((++CalLineCnt))
done < /tmp/vr-terminal

printf '\033[00m'
echo ""
tput rc

# ─── 时间 ───
tput sc
i=0
while [ $((++i)) -lt 9 ]; do tput cuu1; done
tput cuf "$TimeColumn"

if hash toilet 2>/dev/null; then
    date '+%I:%M %P' | toilet -f future --filter border > /tmp/vr-terminal
elif hash figlet 2>/dev/null; then
    date '+%I:%M %P' | figlet > /tmp/vr-terminal
else
    date '+%I:%M %P' > /tmp/vr-terminal
fi

while IFS= read -r Time; do
    printf '\033[01;36m'
    printf '%s' "$Time"
    tput cud1
    tput cuf "$TimeColumn"
done < /tmp/vr-terminal

tput rc
rm -f /tmp/vr-terminal
exit 0
