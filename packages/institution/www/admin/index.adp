<master>

<span class="primary-header">Institution Admin: Groups &amp; Personnel</span>
<br><br>
<include src="groups/tree"
	&roots="subsite_trunks"
	&="subsite_id"
	&="show"
	&="hide">

<if @group_create_url@ not nil>
	<a href="@group_create_url@">Add a Top-Level Group</a>
</if>

<ul><li><a href="@personnel_search_url@">Search For Personnel</a></li>
    <li><a href="@group_search_url@">Search For Group</a></li>
    <if @user_list_url@ not nil>
		<li><a href="@user_list_url@">Search For Users</a></li>
    </if>
    <if @personnel_create_url@ not nil>
		<li><a href="@personnel_create_url@">Add A New Personnel</a></li>
    </if>
    <if @physician_create_url@ not nil>
		<li><a href="@physician_create_url@">Add A New Physician</a></li>
    </if>

	<li><a href=@publication_upload_url@>Upload Publications from EndNote</a> </li>

	<if @categories_url@ not nil>
		<li><a href="@categories_url@">Categories</a></li>
    </if>
</ul>
