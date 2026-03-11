-- Add keymap hint to the left side of status bar with rounded edges
Status:children_add(function()

	local pill_bg = "#89b4fa"
	local pill_fg = "#313244"
	local sep_left = ""
	local sep_right = ""

	return ui.Line {
		ui.Span(sep_left):fg(pill_bg),
		ui.Span(" F1/~=help | .=hidden "):fg(pill_fg):bg(pill_bg),
		ui.Span(sep_right):fg(pill_bg),
		ui.Span("  "),
	}
end, 100, Status.LEFT)
