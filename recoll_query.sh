# Query recoll index database and return in rofi dmenu mode

# dev version:
#recoll -t -N -F filename -q 'river' 2>&1 | sed -n '4,10p' | awk -F' ' '{print $2}' | xargs -n1 -I % sh -c 'echo % | base64 -d; echo '

PDFVIEWER='evince'

QUERY=$(rofi -config ~/.config/rofi/config_oneliner -lines 0 -dmenu -p \
	'Recoll search. Type in the word to query:')

# Arrays
declare -a ARR_URL
declare -a ARR_FILENAME
declare -a ARR_ABS

if [[ "$QUERY" = '' ]]; then
	exit
fi

~/recoll/bin/recoll -t -F 'url filename abstract' -q "$QUERY" 2>&1 | \
	sed -n '4,$p' | \
	# has to put everything below inside {}
{
	while IFS=" " read c1 c2 c3;do
		# Decode base64 and append to arrays
		ARR_URL+=("$(echo $c1 | base64 -d)")
		ARR_FILENAME+=("$(echo $c2 | base64 -d)")
		ARR_ABS+=("$(echo $c3 | base64 -d)")
	done 

# Compose rofi string
ROFI_STR=""
for i in ${!ARR_URL[*]}; do
	# Separate entries using "|"
	strii="$(echo -e "${ARR_FILENAME[$i]}\n    ${ARR_ABS[$i]} |" | \
		sed 's/\.\.\./\n /g')"
	ROFI_STR+="$strii"
done

echo "$ROIF_STR"

# Get user select idx(s), remove leading "-" with sed
choice_idx=($(echo -e "$ROFI_STR" | \
	rofi click-to-exit false -dmenu -multi-select -format -i -eh 8 -sep '|' -config ~/.config/rofi/config_recoll -lines 6 | \
	sed 's/^-//g'))

#echo "${choice_idx[*]}"
#echo "${#choice_idx[@]}"

for i in ${!choice_idx[*]}; do
	cii=${choice_idx[$i]}
	if [[ ! $cii = '' ]]; then
		choice_url="${ARR_URL[$cii]}"
		#echo "$choice_url"
		$PDFVIEWER "$choice_url" &
	fi
done
}

