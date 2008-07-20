<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>
<master>
<property name="title">Request A New Title</property>
<property context="context">@context@</property>

<if @step@ not nil>
	<table cellpadding="2" cellspacing="2" border="0" width="100%">
		<tr><td bgcolor="#ffffcc">
				<span class="primary-header">To create this title, you will need to
contact an administrator.</span> &nbsp;&nbsp;
				<a  href="@party_detail_url@#research">Don't Send &amp; Return to Step @step@</a>
			</td>
		</tr>
	</table>
	<br>
</if>
<else>
<p><span class="primary-header">To create this title, you will need to contact
an administrator.</span></p>
</else>

<formtemplate id="request_add">
	<table>
		<tr><th class="secondary-header" align="left" valign="top">
				Request that:</th>
			<td>@personnel_name@</td>
		</tr>
		<tr><th class="secondary-header" align="left" valign="top">
				be given the title:</th>
			<td><formwidget id="user_selected_title_id">
					<formerror id="user_selected_title_id"></formerror>
				</formwidget><br>
				<formwidget id="user_typed_title"></formwidget>
			</td>
		</tr>
		<tr><th class="secondary-header" align="left" valign="top">
				at/in:</th>
			<td><formwidget id="user_selected_group_id">
					<formerror id="user_selected_group_id"></formerror>
				</formwidget><br>
				<formwidget id="user_typed_group"></formwidget>
			</td>
		</tr>


		<tr><td>Your Questions/Comments:</td><tr>
		<tr><td colspan="2">
				<formwidget id="comments"></formwidget>
			</td>
		</tr>
		<tr><td colspan="2" align="center">
				<formwidget id="action"></formwidget>
			</td>
		</tr>
	</table>
</formtemplate>