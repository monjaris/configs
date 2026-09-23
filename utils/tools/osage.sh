#/usr/bin/env bash

install_date=$(stat -c %W /)
current_date=$(date +%s)
difference=$((current_date - install_date))
days=$((difference / 86400))
years="$((days / 365))y"
remaining_days=$((days % 365))
months="$((remaining_days / 30))m"
final_days="$((remaining_days % 30))d"

echo "$years, $months, $final_days"
