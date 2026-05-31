# shellcheck shell=bash
# Print the basename of the current pane's working directory.

# shellcheck source=lib/tmux_adapter.sh
source "${TMUX_POWERLINE_DIR_LIB}/tmux_adapter.sh"

run_segment() {
	basename "$(tp_get_tmux_cwd)"
	return 0
}
