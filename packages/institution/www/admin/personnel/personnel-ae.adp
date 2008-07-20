<master>
<property name="title">Step 1: Basic Information</property>
<property name="context">@context@</property>

<table width="100%" cellpadding="0" cellspacing="0" bgcolor="#ccffff">
	<tr><td><if @personnel_id@ not nil>
			<span class="primary-header">Step 1: Edit Basic Information</span>
			&nbsp;&nbsp; <font color="red">*</font> indicates required fields  
			&nbsp;&nbsp; <a href="detail?personnel_id=@personnel_id@">Don't Save & Proceed to Step 2</a>
			<br><br>
			</if>
			<else>
			<span class="primary-header">Add Personnel</span>
			&nbsp;&nbsp; <font color="red">*</font> indicates required fields  
			<br><br>
			</else>
			<formtemplate id="personnel_ae"></formtemplate>
			<p><font color="red">*</font> indicates required fields.</p>

			<p align="right">
				<form action="@subsite_url@register/logout">
					<input type="Submit" value="Don't Save and Log Out" align="right">
				</form>
			</p>
		</td>
	</tr>
</table>
