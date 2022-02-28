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
	printf "%s ", $3
	if (tolower($7) ~ /^([0-9]* *)?(povzetek|izvleček|abstract)$/) {
		current_segment="abstract"
		printf "chapter %s ", $7
	} else if (tolower($7) ~ /^([0-9]* *)?(ključne besede|key ?words)(:.*)?$/) {
		current_segment="keywords"
		printf "chapter %s ", $7
	} else if (tolower($7) ~ /^([0-9]* *)?(kazalo|table of contents)$/) {
		current_segment="toc"
		printf "chapter %s ", $7
	} else if (tolower($7) ~ /^([0-9]* *)?(kazalo kratic|table of (key ?words|abbreviations))$/) {
		current_segment="toa"
		printf "chapter %s ", $7
	} else if (tolower($7) ~ /(uvod|introduction)$/) {
		current_segment="body"
		printf "chapter UVOD"
	} else if (tolower($7) ~ /^([0-9]* *)?(zaključ[a-z]+|sklep[a-z]?|conclusion[a-z]?)$/) {
		current_segment="conclusion"
		printf "chapter %s ", $7
	} else if (tolower($7) ~ /^([0-9]* *)?(seznam virov|viri|prilog[a-z]*|literatura|source[a-z]*)$/) {
		current_segment="back"
		printf "chapter %s ", $7
	} else if ($7 ~ /^([0-9\.]* )+[A-Z][A-Z ]+$|Poglavje [0-9]+/) {
		printf "chapter %s", $7
	} else {
		printf "%s%s ", current_segment, toupper($5)
	}
	printf "\n"
}
