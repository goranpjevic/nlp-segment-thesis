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

/^[ \t]*<p xml:id=\"/{
	# $3 : paragraph id
	# $5 : paragraph language
	# $7 : paragraph contents
	printf "%s ", $3
	if (tolower($7) ~ /^([0-9\.]* *)?(povzetek|izvleček|abstract)$/) {
		printf "segment %s", current_segment="abstract"
	} else if (tolower($7) ~ /^([0-9\.]* *)?(ključne besede|key ?words)(:.*)?$/) {
		printf "segment %s", current_segment="keywords"
	} else if (tolower($7) ~ /^([0-9\.]* *)?(kazalo)/) {
		printf "segment %s", current_segment="toc"
	} else if (tolower($7) ~ /^([0-9\.]* *)?(kazalo kratic|kratice( in akronimi))$/) {
		printf "segment %s", current_segment="toa"
	} else if (tolower($7) ~ /(uvod)$/) {
		current_segment="body"
		printf "chapter UVOD"
	} else if (tolower($7) ~ /^([0-9\.]* *)?(zaključ[a-z]+|sklep[a-z]*( misli)?)$/) {
		printf "segment %s", current_segment="conclusion"
	} else if (tolower($7) ~ /^([0-9\.]* *)?((seznam )?vir(i|ov)|prilog(a|e)( [0-9]+: .+)?|(uporabljena )?literatura( in viri)?)$/) {
		current_segment="back"
		printf "chapter %s ", $7
	} else if ($7 ~ /^([0-9\.]* )+[A-Z][A-Za-z ]+$|Poglavje [0-9]+([ :]+[A-Za-z ]+)?$/) {
		printf "chapter %s", $7
	} else {
		printf "%s ", current_segment
		if (current_segment == "abstract" || current_segment == "keywords") {
			printf "%s ", toupper($5)
		}
	}
	printf "\n"
}
