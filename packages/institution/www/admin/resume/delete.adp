<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>
<master>
<property name="title">@title@</property>
<property name="context">@context@</property>

<if @step@ not nil>
	<table cellpadding="2" cellspacing="2" border="0" width="100%">
		<tr><td bgcolor="#ffffcc">
				<span class="primary-header">@title@</span> &nbsp;&nbsp;
				<a  href="@party_detail_url@#research-info">Don't @action@ &amp; Return to Step @step@</a>
			</td>
		</tr>
	</table>
</if>

<formtemplate id="delete"></formtemplate>

<if @can_change_this_resume_p@>
	<ul>
	<if @resume_edit_url@ not nil>
		<li><a href="@resume_edit_url@">Edit This Resume</a></li>
	</if>
	<if @resume_permit_url@ not nil>
		<li><a href="@resume_permit_url@">Change the Permissions on This Resume</a></li>
	</if>
	</ul>
</if>