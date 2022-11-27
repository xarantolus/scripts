$arg = $args[0]

$display_right = "\\.\DISPLAY1"
$display_left = "\\.\DISPLAY2"

if ($arg -eq $null) {
	$right = & ddccli -B -m $display_right

	if ($right -eq "0") {
		$arg = "light"
	} else {
		$arg = "dark"
	}
}


if ($arg -eq "light") {
	# we are already in dark mode, set light
	& ddccli -b 52 -c 75 -m $display_right
	& ddccli -b 50 -c 50 -m $display_left
} else {
	# we are in light mode, set dark
	& ddccli -b 0 -c 75 -m $display_right
	& ddccli -b 35 -c 50 -m $display_left
}





