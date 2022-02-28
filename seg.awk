#!/usr/bin/env awk -f

BEGIN {
	if (ARGC != 2) {
		exit 1
	}
	FS="[<>\"]"

	current_segment="front"
}

/p xml:id=\"/{
	print $3 ": " current_segment
	# language is in $5
	if (tolower($7) ~ /povzetek/) {
		current_segment="abstract" toupper($5)
	}
}
