<master>
<property name="title">@page_title@</property>
<property name="context">@context@</property>

@cnsi_context_bar;noquote@

<formtemplate id="form_ae">
<table>

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

    <tr><th align=right>Equipment Type: <font color=red>*<formerror id="resource_category_id"></formerror></font></th>
        <td align=left>
                <formwidget id="resource_category_id">
                
       </td>
    </tr>

    <tr><th align=right>Enabled?: <font color=red>* <formerror id="enabled_p"></formerror></font></th>
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
    <tr><th align=right>Quantity: <font color=red><formerror id="quantity"></formerror></font></th>
        <td align=left>
                <formwidget id="quantity">
                
       </td>
    </tr>
<tr><td>&nbsp;</td><td><input type="submit" name="submit_button" value="    @submit_btn@     " /></td></tr>
</table>
</formtemplate>
