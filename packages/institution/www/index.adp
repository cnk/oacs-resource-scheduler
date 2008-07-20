<master>
<include src="tree"
	&="subsite_id"
	&roots="subsite_trunks"
	&="show"
	&="hide"
	&="root_group_id"
	title=" ">

<ul><li><a href="@personnel_search_url@">View Personnel</a></li>
	<if @admin_url@ not nil><li><a href="@admin_url@">Administrator Access</a></li></if>
</ul>
