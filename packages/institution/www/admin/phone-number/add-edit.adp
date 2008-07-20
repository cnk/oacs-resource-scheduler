<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>
<master>
<property name="title">@title@</property>
<property name="context">@context@</property>

<if @step@ not nil>
	<table cellpadding="2" cellspacing="2" border="0" width="100%">
		<tr><td bgcolor="#ccffcc">
				<span class="primary-header">@title@</span> &nbsp;&nbsp;
				<a  href="@party_detail_url@">Don't Save &amp; Return to Step @step@</a>
			</td>
		</tr>
	</table>
</if>

<formtemplate id="add_edit"></formtemplate>

<blockquote>
<p>
An Explanation of the <b>Priority</b> value: <br>
Priority is a numerical value you can assign if you have multiple phone numbers and you want them listed in a particular order. 
A phone number with a <b>Priority:</b> 1 will be listed first, followed by a phone number with a <b>Priority:</b> 2, etc.
This is handy for people who wish to control the order in which their office, lab, and other phone numbers appear.
</p>
<p>The default value is 0, or no priority between phone numbers.</p>
</blockquote>


<if @action@ eq "Edit">
	<if @can_delete_or_permit_p@>
		<ul>
		<if @phone_delete_url@ not nil>
			<li><a href="@phone_delete_url@">Delete This Phone Number</a></li>
		</if>
		<if @phone_permit_url@ not nil>
			<li><a href="@phone_permit_url@">Change the Permissions on This Phone Number</a></li>
		</if>
		</ul>
	</if>
</if>
