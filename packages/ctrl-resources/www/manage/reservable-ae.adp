
<master>
<property name="title">@page_title@</property>
<property name="context">@context@</property>

@cnsi_context_bar;noquote@

<formtemplate id="form_ae">
<table cellspacing="3" cellpadding="3">
    <tr><th align=right>Name: <font color=red>*<formerror id="name"></formerror></font></th>
        <td align=left>
                <formwidget id="name">
                
       </td>
    </tr>

    <tr><th align=right>Description: <font color=red><formerror id="description"></formerror></font></th>
        <td align=left>
                <formwidget id="description">
                
       </td>
    </tr>

    <tr><th align=right>Resource Category: <font color=red><formerror id="resource_category_id"></formerror></font></th>
        <td align=left>
                <formwidget id="resource_category_id">
                
       </td>
    </tr>

    <tr><th align=right>Enabled?: <font color=red>*<formerror id="enabled_p"></formerror></font></th>
        <td align=left>
                <formgroup id="enabled_p">
                    @formgroup.widget;noquote@ @formgroup.label@
                </formgroup>
                
       </td>
    </tr>

    <tr><th align=right>Services: <font color=red><formerror id="services"></formerror></font></th>
        <td align=left>
                <formwidget id="services">
                
       </td>
    </tr>

    <tr><th align=right>Property Tag: <font color=red><formerror id="property_tag"></formerror></font></th>
        <td align=left>
                <formwidget id="property_tag">
                
       </td>
    </tr>

    <tr><th align=right>How To Reserve: <font color=red><formerror id="how_to_reserve"></formerror></font></th>
        <td align=left>
                <formwidget id="how_to_reserve">
                
       </td>
    </tr>

    <tr><th align=right>Is Approval Required: <font color=red>*<formerror id="approval_required_p"></formerror></font></th>
        <td align=left>
                <formgroup id="approval_required_p">
                    @formgroup.widget;noquote@ @formgroup.label@
                </formgroup>
                
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

    <tr><th align=right>Floor: <font color=red>*<formerror id="floor"></formerror></font></th>
        <td align=left>
                <formwidget id="floor">
                
       </td>
    </tr>

    <tr><th align=right>Room: <font color=red>*<formerror id="room"></formerror></font></th>
        <td align=left>
                <formwidget id="room">
                
       </td>
    </tr>
    <tr><th align=right>Quantity: <font color=red>*<formerror id="quantity"></formerror></font></th>
        <td align=left>
                <formwidget id="quantity">
                
       </td>
    </tr>
<tr><td>&nbsp;</td><td><input type="submit" name="submit_button" value="    @submit_btn@     " /></td></tr>
</table>
</formtemplate>
