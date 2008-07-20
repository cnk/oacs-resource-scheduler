<master>
<property name=title> @title@ </property>
<property name=context> @context;noquote@ </property>

Editing <b> @wf_info.short_name@ </b>

<br><br>
<a href=@wf_meta_edit@> Edit Workflow Metadata </a>
<br><br>
<fieldset><legend> States </legend>

	<a href=@add_state_url@> Create new State </a>
	<multiple name="get_states">
		<if @get_states.rownum@ eq 1>
			<table>
				<tr>	<td> <b> Id </b> </td>
					<td> <b> Short name </b> </td>
					<td> <b> Pretty name </b></td>
					<td> <b> Options </b></td>
				</tr>
		</if>

		<tr>	<td>@get_states.state_id@</td>
		   	<td>@get_states.short_name@</td>
			<td>@get_states.pretty_name@</td>
			<td> <a href=@get_states.edit_url;noquote@> Edit </a> |
			     <a href=@get_states.delete_url;noquote@> Delete </a>
			</td>
		</tr>


		<if @get_states.rownum@ eq @get_states:rowcount@>
			</table>
		</if>
	</multiple>
</fieldset>

<br><br>

<fieldset><legend> Actions </legend>
	<a href=@add_action_url@> Create new Action </a>
	<multiple name="get_actions">
		<if @get_actions.rownum@ eq 1>
			<table>
				<tr>	<td> <b> Id </b> </td>
					<td> <b> Short name </b> </td>
					<td> <b> Pretty name </b></td>
					<td> <b> Options </b></td>
				</tr>
		</if>

		<tr>	<td>@get_actions.action_id@</td>
		   	<td>@get_actions.short_name@</td>
			<td>@get_actions.pretty_name@</td>
			
			<td><a href=@get_actions.edit_url;noquote@> Edit </a> |
			     <a href=@get_actions.delete_url;noquote@> Delete </a>
			</td>
		</tr>


		<if @get_actions.rownum@ eq @get_actions:rowcount@>
			</table>
		</if>
	</multiple>
</fieldset>

<br><br>

<fieldset><legend> Roles </legend>

	<a href=@add_role_url@> Create new Role </a>
	<multiple name="get_roles">
		<if @get_roles.rownum@ eq 1>
			<table>
				<tr>	<td> <b> Id </b> </td>
					<td> <b> Pretty name </b></td>
					<td> <b> Options </b></td>
				</tr>
		</if>

		<tr>	<td>@get_roles.role_id@</td>
			<td>@get_roles.pretty_name@</td>
			<td>	<a href=@get_roles.edit_url;noquote@> Edit </a> |
				<a href=@get_roles.delete_url;noquote@> Delete </a>
			</td>
		</tr>


		<if @get_roles.rownum@ eq @get_roles:rowcount@>
			</table>
		</if>
	</multiple>
</fieldset>
