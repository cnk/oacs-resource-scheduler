
<master>
<property name="title">@page_title@</property>
<property name="context">@context@</property>

@cnsi_context_bar;noquote@

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

    <tr><th align=right>Equipment Type: </th>
        <td align=left>
                <formwidget id="resource_category_id">
                
       </td>
    </tr>

    <tr><th align=right>Enabled? </th>
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
<tr><td>&nbsp;</td><td><formwidget id="delete_button"></td></tr>
</table>
</formtemplate>
