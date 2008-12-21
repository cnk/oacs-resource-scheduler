<master>
<property name=title>@page_title@</property>
@context_bar@
<br></br>
<h3><li>@message@</li></h3>
<formtemplate id="event_object_unmap">
<table>
<tr><td>
<fieldset> 
<legend> <b><i>Events</i></b></legend>
<table>
   <formgroup id="mapped_events">
      <if @formgroup.rownum@ odd><tr><td>@formgroup.widget@ @formgroup.label@ </td></if>
      <else><td>@formgroup.widget@ @formgroup.label@ </td></tr></else>
   </formgroup>
</table>
</fieldset>
<td></tr>
<tr><td><br><formwidget id="submit"></td></tr>
</table>
</formtemplate>
<br>
