<master>
<property name=title> @title@ </property>
<property name=context> @context@ </property>

Edit a boiler plate so that all future uses of the workflow will have the changes.  Note that current workflow instances using
this boiler plate will not be affected. If you want to change a specific instance, see below.
<br><br>

<fieldset> <legend> Workflow Boiler Plates</legend>
	<a href=@new_wf_url@> New Workflow </a>
	<multiple name="get_bps">
		<if @get_bps.rownum@ eq 1>
			<table>
				<tr>	<td> <b> Id </b> </td>
					<td> <b> Short name </b> </td>
					<td> <b> Pretty name </b></td>
					<td> <b> Options </b></td>
				</tr>
		</if>

		<tr>	<td>@get_bps.workflow_id@</td>
		   	<td>@get_bps.short_name@</td>
			<td>@get_bps.pretty_name@</td>
			<td><a href=@get_bps.edit_url;noquote@> Edit </a> | 
				<a href=@get_bps.delete_url;noquote@> Delete </a> |
			        <a href=@get_bps.view_url;noquote@> View </a>
			</td>
		</tr>


		<if @get_bps.rownum@ eq @get_bps:rowcount@>
			</table>
		</if>
	</multiple>	
</fieldset>

<br>
<br>
<br>


Editing a specific instance when you want to change a workflow that is already in use.
<br><br>

<fieldset> <legend> Workflow Instances  </legend>
	<a href=@clone_url@> Clone an existing boiler plate workflow </a>
	<multiple name="get_instances">
		<if @get_instances.rownum@ eq 1>
			<table>
				<tr>	<td> <b> Id </b> </td>
					<td> <b> Short name </b> </td>
					<td> <b> Pretty name </b></td>
					<td> <b> Options </b></td>
				</tr>
		</if>

		<tr>	
			<td> @get_instances.workflow_id@</td>
		   	<td> @get_instances.short_name@</td>
			<td> @get_instances.pretty_name@</td>
			<td> 	<a href=@get_instances.edit_url@> Edit </a> |
				<a href=@get_instances.delete_url@> Delete </a> |
			        <a href=@get_instances.view_url;noquote@> View </a>
			 </td>
		</tr>


		<if @get_instances.rownum@ eq @get_instances:rowcount@>
			</table>
		</if>
	</multiple>
</fieldset>
