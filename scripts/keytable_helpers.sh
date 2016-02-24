VERSION_WITH_KEYTABLE_SUPPORT="2.1"

keytable_tmux_version_ok() {
	$CURRENT_DIR/scripts/check_tmux_version.sh "$VERSION_WITH_KEYTABLE_SUPPORT"
}

get_keytable_arguments() {
	local keytable="$(get_tmux_option "$copycat_keytable_option" "$default_keytable")"
	if keytable_tmux_version_ok; then
		echo "-T $keytable"
	else
		echo ""
	fi
}
