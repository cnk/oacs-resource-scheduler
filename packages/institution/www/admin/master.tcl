
set subsite_url [site_node_closest_ancestor_package_url]

if {[template::util::is_nil title]}			{set title ""}
if {[template::util::is_nil context]}		{set context ""}
if {[template::util::is_nil stylesheets]}	{
	set stylesheets				""	;# References to CSS files
}
