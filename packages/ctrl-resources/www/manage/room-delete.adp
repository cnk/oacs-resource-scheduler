<master>
<property name="title">@page_title@</property>
<property name="context">@context@</property>

@cnsi_context_bar;noquote@

<formtemplate id="form_ae">

<table cellspacing="3" cellpadding="3">

    <tr><th align=right>Name </th>
        <td align=left>
                <formwidget id="name">
       </td>
    </tr>

    <tr><th align=right>Description </th>
        <td align=left>
                <formwidget id="description">
       </td>
    </tr>

    <tr><th align=right>Equipment Type </th>
        <td align=left>
                <formwidget id="resource_category_id">
       </td>
    </tr>

    <tr><th align=right>Enabled </th>
        <td align=left>
	        <formwidget id="enabled_p">
       </td>
    </tr>

    <tr><th align=right>Services </th>
        <td align=left>
                <formwidget id="services">
       </td>
    </tr>

    <tr><th align=right>Property Tag </th>
        <td align=left>
                <formwidget id="property_tag">
       </td>
    </tr>
    <tr><th align=right>No. of Resources</th>
        <td align=left>
                <formwidget id="no_resources">
       </td>
    </tr>
    <tr><th align=right>No. of Requests</th>
        <td align=left>
                <formwidget id="no_requests">
       </td>
    </tr>
    <tr><th align=right>No. of Images</th>
        <td align=left>
                <formwidget id="no_images">
       </td>
    </tr>
    <if @warning@ ne ""><tr><td></td><td><font color=red>@warning@</td></tr></if>
<tr><td></td><td><if @flag@ ne 1><formwidget id="delete_button">&nbsp;&nbsp;</if><formwidget id="cancel_button">&nbsp;&nbsp;</td></tr>
</table>
</formtemplate>
