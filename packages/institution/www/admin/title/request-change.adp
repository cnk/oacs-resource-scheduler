<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>
<master>
<property name="title">Request Title Change</property>
<property context="context">@context@</property>

<if @step@ not nil>
	<table cellpadding="2" cellspacing="2" border="0" width="100%">
		<tr><td bgcolor="#ffffcc">
				<span class="primary-header">To make a change to this title, you will need to
contact an administrator.</span> &nbsp;&nbsp;
				<a  href="@party_detail_url@#research">Don't Send &amp; Return to Step @step@</a>
			</td>
		</tr>
	</table>
	<br>
</if>
<else>
<p><span class="primary-header">To make a change to this title, you will need to
contact an administrator.</span></p>
</else>

<formtemplate id="request_change">
<if @acs_rel_id@ nil>
	<table>
		<tr><th class="secondary-header" align="left" valign="top">
				Request that:</th>
			<td>@personnel_name@</td>
		</tr>
		<tr><th class="secondary-header" align="left" valign="top">
				be given the title:</th>
			<td><formwidget id="user_selected_title_id"></formwidget></td>
		</tr>
		<tr><th class="secondary-header" align="left" valign="top">
				at / in:</th>
			<td><formwidget id="user_selected_group_id"></formwidget></td>
		</tr>
	</table>
	<br>
</if>

<p>The following message will be sent.  You may append any comments you wish to
make at the bottom.  Please make sure that your email address (in the 'From'
field) is correct.  If it is not correct, include the correct address in the
comment area.</p>

<table>
	<tr><th class="secondary-header" align="left" valign="top">
			From:
		</th>
		<td><pre>@user_email@</pre>
		</td>
	</tr>
	<tr><th class="secondary-header" align="left" valign="top">
			To:
		</th>
		<td><pre>fdb-support@ctrl.ucla.edu</pre>
			<formwidget id="to"></formwidget>
		</td>
	</tr>
	<tr><th class="secondary-header" align="left" valign="top">
			Subject:
		</th>
		<td>@subject@</td>
	</tr>

	<if @observer_message@ not nil>
	<tr><th class="secondary-header" align="left" valign="top">
			Message:
		</th>
		<td><pre>@observer_message@</pre></td>
	</tr>
	</if>

	<tr><th valign="top">
			<span class="secondary-header">Comments:</span>
		</th>
		<td><table class="layout">
				<tr><td><formwidget id="comments"></formwidget></td></tr>
				<tr><td align="center"><formwidget id="action"></formwidget></td></tr>
			</table>
		</td>
	</tr>
</table>
</formtemplate>