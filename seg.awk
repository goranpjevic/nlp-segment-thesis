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
	if (tolower($7) ~ /^([0-9]* *)?(povzetek|abstract)$/) {
		current_segment="abstract"
	} else if (tolower($7) ~ /^([0-9]* *)?(ključne besede|key ?words)$/) {
		current_segment="keywords"
	} else if (tolower($7) ~ /^([0-9]* *)?(kazalo|table of contents)$/) {
		current_segment="toc"
	} else if (tolower($7) ~ /^([0-9]* *)?(kazalo kratic|table of key ?words)$/) {
		current_segment="toa"
	} else if (tolower($7) ~ /^([0-9]* *)?(uvod|introduction)$/) {
		current_segment="body"
	} else if (tolower($7) ~ /^([0-9]* *)?(zaključ.+|sklep.?|conclusion.?)$/) {
		current_segment="conclusion"
	} else if (tolower($7) ~ /^([0-9]* *)?(seznam virov|viri|prilog.*|source.*)$/) {
		current_segment="back"
	}

}
