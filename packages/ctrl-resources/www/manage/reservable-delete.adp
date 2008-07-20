
<master>
<property name="title">@page_title@</property>
<property name="context">@context@</property>
<formtemplate id="form_ae">
<table cellspacing="3" cellpadding="3">
    <tr><th align=right>Name: </th>
        <td align=left>
                <formwidget id="name">
                
       </td>
    </tr>

    <tr><th align=right>Description: </th>
        <td align=left>
                <formwidget id="description">
                
       </td>
    </tr>

    <tr><th align=right>Resource: </th>
        <td align=left>
                <formwidget id="resource_category_id">
                
       </td>
    </tr>

    <tr><th align=right>Enabled?: </th>
        <td align=left>
	        <formwidget id="enabled_p">                
       </td>
    </tr>

    <tr><th align=right>Services: </th>
        <td align=left>
                <formwidget id="services">
                
       </td>
    </tr>

    <tr><th align=right>Property Tag: </th>
        <td align=left>
                <formwidget id="property_tag">
                
       </td>
    </tr>

    <tr><th align=right>How To Reserve: <font color=red><formerror id="how_to_reserve"></formerror></font></th>
        <td align=left>
                <formwidget id="how_to_reserve">
                
       </td>
    </tr>

    <tr><th align=right>Is Approval Required: </th>
        <td align=left>
                <formwidget id="approval_required_p">                
       </td>
    </tr>

    <tr><th align=right>Address: <font color=red><formerror id="address_id"></formerror></font></th>
        <td align=left>
                <formwidget id="address_id">
                
       </td>
    </tr>

    <tr><th align=right>Department: <font color=red><formerror id="department_id"></formerror></font></th>
        <td align=left>
                <formwidget id="department_id">
                
       </td>
    </tr>

    <tr><th align=right>Floor: </th>
        <td align=left>
                <formwidget id="floor">
                
       </td>
    </tr>

    <tr><th align=right>Room: </th>
        <td align=left>
                <formwidget id="room">
                
       </td>
    </tr>
    <tr><th align=right>Quantity: </th>
        <td align=left>
                <formwidget id="quantity">
                
       </td>
    </tr>
<tr><td>&nbsp;</td><td><if @event_counter@ eq 0><formwidget id="delete_button"></if>
                       <else><font color=red>Unable to delete the above resource because at least one event has already reserved it.</font><p/></else><formwidget id="cancel_button"></td></tr>
</table>
</formtemplate>
