#! /usr/bin/env bash
function gitStatus() {

	local currentStatus=`git status 2> /dev/null`

	# if there is no status information available, exit
	if [ -z "$currentStatus" ]; then
		exit 0
	fi
	
	local aheadCount=0
	local deleted=0
	local modified=0
	local added=0
	local untracked=false
	
	while read -r line; do
		if [[ "$line" =~ ahead.*([0-9]+) ]]; then
			aheadCount=${BASH_REMATCH[1]}
	 	elif [[ "$line" =~ "deleted:" ]]; then
			let deleted++
		elif [[ "$line" =~ "modified:" || "$line" =~ "renamed:" ]]; then
			let modified++
		elif [[ "$line" =~ "new file:" ]]; then
			let added++
		elif [[ "$line" =~ "Untracked files:" ]]; then
			untracked=true
		fi
	done <<< "$currentStatus"

	local openBracket="["
	local branch=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	local aheadText=
	local addedText=
	local modifiedText=
	local deletedText=
	local untrackedText=
	local closeBracket="]"

	# ahead count
	if [ $aheadCount -gt 0 ]; then
		aheadText="(+$aheadCount)"
	fi

	# files added: +
	if [ $added -gt 0 ]; then
		addedText=" +$added"
	fi

	# files modified: ~
	if [ $modified -gt 0 ]; then
		modifiedText=" ~$modified"
	fi
	
	# files deleted: -
	if [ $deleted -gt 0 ]; then
		deletedText=" -$deleted"
	fi	
	
	# new file(s) exist: !
	if $untracked; then
		untrackedText=" !"
	fi

	echo $openBracket$branch$aheadText$addedText$modifiedText$deletedText$untrackedText$closeBracket
}
