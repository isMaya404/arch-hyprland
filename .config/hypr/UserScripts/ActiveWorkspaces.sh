#!/bin/bash

direction="$1" # "next" or "prev"
current=$(hyprctl activeworkspace -j | jq '.id')
workspaces=($(hyprctl workspaces -j | jq '.[] | select(.windows > 0) | .id' | sort -n))

if [[ ${#workspaces[@]} -eq 0 ]]; then
  exit 0 # No active workspaces
fi

index=-1
for i in "${!workspaces[@]}"; do
  if [[ "${workspaces[$i]}" -eq "$current" ]]; then
    index=$i
    break
  fi
done

if [[ $index -eq -1 ]]; then
  exit 0 # Current workspace not found
fi

if [[ "$direction" == "next" ]]; then
  next_index=$((index + 1))
  [[ $next_index -ge ${#workspaces[@]} ]] && next_index=0 # Loop around
elif [[ "$direction" == "prev" ]]; then
  next_index=$((index - 1))
  [[ $next_index -lt 0 ]] && next_index=$((${#workspaces[@]} - 1)) # Loop around
fi

hyprctl dispatch workspace "${workspaces[$next_index]}"
