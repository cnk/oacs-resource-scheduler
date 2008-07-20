<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>
<master>
<property name="title">@title@</property>
<property name="context">@context@</property>

<if @step@ not nil>
	<table cellpadding="2" cellspacing="2" border="0" width="100%">
		<tr><td bgcolor="#ffffcc">
				<span class="primary-header">@title@</span> &nbsp;&nbsp;
				<a  href="@party_detail_url@#research-info">Don't Save &amp; Return to Step @step@</a>
			</td>
		</tr>
	</table>
</if>

<formtemplate id="add_edit"></formtemplate>

<if @action@ eq "Edit">
	<if @can_delete_or_permit_p@>
		<ul>
		<if @certification_delete_url@ not nil>
			<li><a href="@certification_delete_url@">Delete This Certification</a></li>
		</if>
		<if @certification_permit_url@ not nil>
			<li><a href="@certification_permit_url@">Change the Permissions on This Certification</a></li>
		</if>
		</ul>
	</if>
</if>
