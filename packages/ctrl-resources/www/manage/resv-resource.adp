<master>
<property name="title">General Resource: @resv_resource_info.name@</property>
<property name="context"> @context@</property>

<fieldset><legend> Resource Info</legend>
<include src="/packages/ctrl-resources/resources/panes/resv-resource-display" &resv_resource_info=resv_resource_info>
</fieldset>
<br /><br />

<fieldset><legend> Images (<a href='@add_image_url@'>Add</a>)</legend>

<include src="/packages/ctrl-resources/www/images-display" resource_id="@resource_id@" action="display" subdir="" manage_p="1">
</fieldset>

<br />
<fieldset><legend> Policy [<a href='@policy_edit_url@'>Edit</a>] </legend>
<include src="/packages/ctrl-resources/resources/panes/resv-policy-display" &policy_info=policy_info>
</fieldset>

