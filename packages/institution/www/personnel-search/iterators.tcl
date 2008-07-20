# positions of results that are before and after the 'page' currently being viewed
set prev [max 1 [min $rowcount [expr $position - $maxrows]]]
set next [max 1 [min $rowcount [expr $position + $maxrows]]]

# the position-value of the last possible 'position' that can be used for pagination
set last_position [max 1 [expr $rowcount - (($rowcount - 1) % $maxrows)]]

# position-values of the results that are visible on the current 'page'
set first_visible $position
set last_visible [min $rowcount [expr $position + $maxrows - 1]]

# ranges for (possibly) preceding and successive results
set prev_lo [expr $prev - ($prev % $maxrows) + 1]
set prev_hi [max 1 [expr $first_visible - 1]]

set next_lo [expr $next - ($next % $maxrows) + 1]
set next_hi [min $rowcount [expr $last_visible + 1 + $maxrows]]

