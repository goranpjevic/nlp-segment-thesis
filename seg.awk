#!/usr/bin/env awk -f

BEGIN {
	if (ARGC != 2) {
		exit 1
	}
	FS="[<>\"]"

	current_segment="front"
}

/p xml:id=\"/{
	print $3 ": " current_segment toupper($5)
	# language is in $5
	if (tolower($7) ~ /povzetek|abstract/) {
		current_segment="abstract"
	}
}
