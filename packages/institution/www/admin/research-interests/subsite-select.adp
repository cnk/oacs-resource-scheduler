<master>
<property name="title">@title@</property>
<property name="context_bar">@context_bar@</property>
<script language="javascript" src="research-interest-procs.js"></script>

<table cellpadding="2" cellspacing="2" border="0" width="100%">
<tr><td bgcolor="#ffffcc">
<span class="primary-header">@title@</span> &nbsp;&nbsp;
<a  href="@subsite_url@institution/admin/personnel/detail?personnel_id=@personnel_id@#research-info">Don't Save &amp; Return to Step 3</a>
</td></tr></table>

<p><if @user_id@ eq @personnel_id@>	Your</if>
	<else>	@personnel_name@'s</else> 
	profile may be shown on several web sites.

You may choose to have a different set of research interests displayed on the profile page for each web site. 
If <if @user_id@ eq @personnel_id@> you</if> <else>	@personnel_name@ </else> doesn't have 
a research interest for a certain web site, <if @user_id@ eq @personnel_id@> your</if> <else>	his </else> "Default" research interest
will be shown on the profile page for that web site. 

<br><br>
<table cellpadding=0 cellspacing=0 width=80%>
<tr><td>
<h3 style="color: maroon; display: inline">Choose the web site</h3> for which you wish to add/edit research interests:
	<if @personnel_subsite_list:rowcount@ gt 0>
		<blockquote>
			<multiple name="personnel_subsite_list">
				<a href="@personnel_subsite_list.select_subsite_url@">
					@personnel_subsite_list.subsite_name@
				</a>
				<if @this_subsite_id@ eq @personnel_subsite_list.subsite_id@>
					<b style="color: maroon">*</b>
				</if>
				<br>
			</multiple>
		</blockquote>
	</if><else>
		<i>None</i>
	</else>
</p>
<p><b style="color: maroon">*</b> This website.</p>
</td></tr>
</table>
<br><br>


