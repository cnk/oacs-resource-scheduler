<master>
<property name="title">@page_title@</property>
<property name="context">@context@</property>
<formtemplate id="form_ae">
<table cellspacing="3" cellpadding="3">

    

    <tr><th align=right>Request Name: <font color=red>*<formerror id="name"></formerror></font></th>
        <td align=left>
                <formwidget id="name">
                
       </td>
    </tr>

    <tr><th align=right>Description: <font color=red><formerror id="description"></formerror></font></th>
        <td align=left>
                <formwidget id="description">
       </td>
    </tr>

    <tr><th align=right>Status: <font color=red>*<formerror id="status"></formerror></font></th>
        <td align=left>
                <formwidget id="status">
       </td>
    </tr>

    <tr><th align=right>Requested by: <font color=red>*<formerror id="requested_by"></formerror></font></th>
        <td align=left>
                <formwidget id="requested_by">
                
       </td>
    </tr>


<tr><td>&nbsp;</td><td><formwidget id="submit_button"></td></tr>
</table>
</formtemplate>
