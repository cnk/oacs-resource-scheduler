<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>
<master>
<property name="title">Reset Arrangement of Titles</property>
<property name="context">@context@</property>

<if @step@ not nil>
	<table cellpadding="2" cellspacing="2" border="0" width="100%">
		<tr><td bgcolor="#ffcc99">
				<span class="primary-header">Reset Arrangement of Titles</span> &nbsp;&nbsp;
				<a  href="@party_detail_url@#research">Don't Save &amp; Return to Step @step@</a>
			</td>
		</tr>
	</table>
</if>

You are about to reset the arrangment of the titles:
<blockquote>
	<include src="pretty-list" &="personnel_id" subsite_id="@chosen_subsite_id@">
</blockquote>
of @personnel_name@ on the site @subsite_name@ to:
<blockquote>
	<include src="pretty-list" &="personnel_id" subsite_id="@main_subsite_id@">
</blockquote>

<formtemplate id="reset-arrangement"></formtemplate>