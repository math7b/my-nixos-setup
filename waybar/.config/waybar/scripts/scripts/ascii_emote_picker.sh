#!/usr/bin/env bash

emotes_file="$HOME/.config/waybar/ascii-emotes.txt"
tmp_file="$(mktemp)"

declare -A emote_ranks
declare -A emote_used
declare -A rank_emotes
declare -a emote_lines

max_rank=-1

# Step 1: Load and normalize the file
while IFS= read -r line; do
    # Check and extract emote, rank, and used flag
    if [[ "$line" == *"|||"* ]]; then
        emote="${line%%|||*}"
        rest="${line#*||| }"
        rank="${rest%%||||*}"
        used="${rest##*|||| }"

        # Strip whitespace
        emote="${emote%" "}"
        rank="${rank//[[:space:]]/}"
        used="${used//[[:space:]]/}"
    else
        emote="$line"
        rank=""
        used="0"
    fi

    # Assign max_rank + 1 if rank is missing
    if [[ -z "$rank" ]]; then
        ((max_rank++))
        rank=$max_rank
    else
        (( rank > max_rank )) && max_rank=$rank
    fi

    # If used flag missing
    [[ -z "$used" ]] && used=0

    emote_ranks["$emote"]=$rank
    emote_used["$emote"]=$used
    emote_lines+=("$emote")
done < "$emotes_file"

# Step 2: Sort by rank ascending and show in rofi
sorted_emotes=$(for emote in "${!emote_ranks[@]}"; do
    echo -e "${emote_ranks[$emote]}\t$emote"
done | sort -n | cut -f2)

choice=$(echo "$sorted_emotes" | rofi -dmenu -p "Emote:")
[ -z "$choice" ] && exit 0

current_rank=${emote_ranks[$choice]}
used_flag=${emote_used[$choice]}

if [[ "$used_flag" -eq 0 ]]; then
    # First-time use — promote to rank 0 if available
    target_rank=0
    while true; do
        found_conflict=0
        for emote in "${!emote_ranks[@]}"; do
            if [[ "${emote_ranks[$emote]}" -eq "$target_rank" && "${emote_used[$emote]}" -eq 1 ]]; then
                found_conflict=1
                break
            fi
        done

        if [[ "$found_conflict" -eq 0 ]]; then
            break  # found free spot
        else
            ((target_rank++))
        fi
    done

    # Shift others if needed
    for emote in "${!emote_ranks[@]}"; do
        if [[ "${emote_ranks[$emote]}" -eq "$target_rank" ]]; then
            emote_ranks[$emote]=$current_rank
        fi
    done

    emote_ranks[$choice]=$target_rank
    emote_used[$choice]=1

else
    # Already used → try to promote if possible
    new_rank=$((current_rank - 1))
    if (( new_rank >= 0 )); then
        for emote in "${!emote_ranks[@]}"; do
            if [[ "${emote_ranks[$emote]}" -eq "$new_rank" ]]; then
                # Swap
                emote_ranks[$emote]=$current_rank
                emote_ranks[$choice]=$new_rank
                break
            fi
        done

        # If no conflict, assign directly
        if [[ "${emote_ranks[$choice]}" -eq "$current_rank" ]]; then
            emote_ranks[$choice]=$new_rank
        fi
    fi
fi

# Copy selected emote to clipboard
wl-copy "$choice"

# Rewrite file with updated data
{
    for emote in "${emote_lines[@]}"; do
        rank="${emote_ranks[$emote]}"
        used="${emote_used[$emote]}"
        echo "$emote ||| $rank |||| $used"
    done
} > "$emotes_file"
