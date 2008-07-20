<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>
<master>
<property name="title">@page_title@</property>
<property name="context">@context@</property>

<table cellpadding="2" cellspacing="2" border="0" width="100%">
	<tr><td bgcolor="#ffffcc">
			<span class="primary-header">@page_title@</span> &nbsp;&nbsp;
			<a  href="@party_detail_url@#research">Return to Step 3</a>
		</td>
	</tr>
</table>

<br>
<br>

<table class="layout">
	<tr><td><if @n_items@ gt 0>
				<include src="list" &="items" &="personnel_id">
			</if><else>
				<i>None</i><br>
			</else>
		</td>
	</tr>
</table>

<if @create_p@>
	<ul><li><a	href="@title_create_url@"
				title="Click here to create a title for @owner_name@ that will associate @owner_name@ with a group that is not listed above.">
				Create a Title for @owner_name@ in a Different Group
			</a>
		</li>
	</ul>
</if>
