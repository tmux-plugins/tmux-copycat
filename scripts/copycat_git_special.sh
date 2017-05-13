#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PANE_CURRENT_PATH="$1"

source "$CURRENT_DIR/helpers.sh"

git_root() {
	local git_dir="$PANE_CURRENT_PATH"
        while [[ "$git_dir" != "$HOME" &&
                 "$git_dir" != "/" &&
                 "$git_dir" != "" &&
                 ! -d "$git_dir/.git" ]]; do
            git_dir=${git_dir%/*}
        done
        echo "$git_dir"
}

GIT_ROOT="$(git_root)"


git_status_files() {
	local git_working_dir="$GIT_ROOT"
	local git_dir="$GIT_ROOT/.git"
	echo "$(git --git-dir="$git_dir" --work-tree="$git_working_dir" status --porcelain)"
}

count_subdirs() {
	local path=$1
	local depth="${path//[^\/]}"
	echo "${#depth}"
}

create_relative_path() {
	num_subdirs=$1
	filepath=${2#\/}

	local relpath=""
	for (( i=0; i<$num_subdirs; i++ ))
	do
		relpath="${relpath}../"
	done
	echo "${relpath}${filepath}"
}

find_common_path() {
	local filename=$1
	local subdir=$2

	while [ -n "$subdir" ]; do
		if [ "$filename" == "${filename#$subdir}" ]; then
			subdir=${subdir%/*}
		else
			break
		fi
	done
	echo "$subdir"
}

relative_path_to() {
	local filename="/$1"
	local subdir=${PANE_CURRENT_PATH#$GIT_ROOT}
        local depth="$(count_subdirs "$subdir")"
        local path="$filename"

	common_path=$(find_common_path $filename $subdir)
	if [ -n "${common_path}" ]; then
		local num_subdirs="$(count_subdirs "$common_path")"
		depth=$(($depth - $num_subdirs))
		path="${filename#$common_path}"
        fi
	echo "$(create_relative_path "$depth" "$path")"
}

formatted_git_status() {
	local raw_git_status="$(git_status_files)"
	local filenames="$(echo "$raw_git_status" | cut -c 4-)"

	# output of git_status_files will match output in the root of the repo
	if [ $GIT_ROOT == $PANE_CURRENT_PATH ]; then
		echo "${filenames}"
	else
		# git shows the files as relative to the current subdirectory
		# of the repo
		local paths=""
		for filename in $filenames; do
			paths="${paths}$(relative_path_to "$filename")\n"
		done
		echo -e $paths
	fi
}

exit_if_no_results() {
	local results="$1"
	if [ -z "$results" ]; then
		display_message "No results!"
		exit 0
	fi
}

concatenate_files() {
	local git_status_files="$(formatted_git_status)"
	exit_if_no_results "$git_status_files"

	local result=""
	# Undefined until later within a while loop.
	local file_separator
	while read -r line; do
		result="${result}${file_separator}${line}"
		file_separator="|"
	done <<< "$git_status_files"
	echo "$result"
}

# Creates one, big regex out of git status files.
# Example:
# `git status` shows files `foo.txt` and `bar.txt`
# output regex will be:
# `(foo.txt|bar.txt)
git_status_files_regex() {
	local concatenated_files="$(concatenate_files)"
	local regex_result="(${concatenated_files})"
	echo "$regex_result"
}

main() {
	local search_regex="$(git_status_files_regex)"
	# starts copycat mode
	$CURRENT_DIR/copycat_mode_start.sh "$search_regex"
}
main
