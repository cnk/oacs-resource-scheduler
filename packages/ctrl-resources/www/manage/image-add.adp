<master>
<property name="title">@page_title@</property>
<property name="context">@context@</property>

@cnsi_context_bar;noquote@

<formtemplate id="image_add">
<table cellspacing="3" cellpadding="3">
<tr>
 <td align="right">Image for "@resource_name@":</td>
 <td><formwidget id="resource_image"><br>
     <small><font color=red>Only GIF and JPEG files are accepted.</font></small>
 </td>
</tr>
<tr>
 <td align="right">Name: </td>
 <td><formwidget id="image_name"></td>
</tr>
<tr>
 <td>&nbsp;</td>
 <td><formwidget id="submit_button"></td>
</tr>
</table>
</formtemplate>

<hr width="100%">
<b>Current Images For @resource_name@</b><p>
<include src="/packages/ctrl-resources/www/images-display" resource_id="@resource_id@" action="edit" manage_p=1 subdir="">

