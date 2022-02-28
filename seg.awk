#!/usr/bin/env awk -f

BEGIN {
	if (ARGC == 1) {
		exit 1
	}
	FS="[<>\"]"
}

(FNR == 1) {
	print FILENAME
	current_segment="front"
}

/p xml:id=\"/{
	# $3 : paragraph id
	# $5 : paragraph language
	# $7 : paragraph contents
	printf "%s ", $3
	if (tolower($7) ~ /^([0-9.]* *)?(povzetek|izvleček|abstract)$/) {
		current_segment="abstract"
		printf "segment abstract"
	} else if (tolower($7) ~ /^([0-9.]* *)?(ključne besede|key ?words)(:.*)?$/) {
		current_segment="keywords"
		printf "segment keywords"
	} else if (tolower($7) ~ /^([0-9.]* *)?(kazalo|table of contents)/) {
		current_segment="toc"
		printf "segment toc"
	} else if (tolower($7) ~ /^([0-9.]* *)?(kazalo kratic|kratice( in akronimi)|table of (key ?words|abbreviations))$/) {
		current_segment="toa"
		printf "segment %s ", $7
	} else if (tolower($7) ~ /(uvod|introduction)$/) {
		current_segment="body"
		printf "chapter UVOD"
	} else if (tolower($7) ~ /^([0-9.]* *)?(zaključ[a-z]+|sklep[a-z]*( misli)?|conclusion[a-z]?)$/) {
		current_segment="conclusion"
		printf "segment conclusion"
	} else if (tolower($7) ~ /^([0-9.]* *)?(seznam virov|viri|prilog[a-z]*( [0-9]+: .+)?|(uporabljena )?literatura( in viri)?|source[a-z]*)$/) {
		current_segment="back"
		printf "segment %s ", $7
	} else if ($7 ~ /^([0-9\.]* )+[A-Z][A-Za-z ]+$|Poglavje [0-9]+[ :]+[A-Za-z ]+$/) {
		printf "chapter %s", $7
	} else {
		printf "%s%s ", current_segment, toupper($5)
	}
	printf "\n"
}
