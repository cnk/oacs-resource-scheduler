<master>
<property name="title">@page_title@</property>
<property name="context">@context@</property>
<property name="header_stuff">
  <script type="text/javascript" src="../js/prototype.js"></script>  
</property>
<script type="text/javascript">

   /* Function that chooses the display option according
      to if it's allowed to make reservations or not*/

   function displayResvNote() {
      var opt = false;
      for (i = 0; i < document.form_ae.reservable_p.length; i++) {
         if (document.form_ae.reservable_p[i].checked) {             
            if (document.form_ae.reservable_p[i].value == 'f') {               
              opt = false;
            } else {
              opt = true;                             
            }
         }
      }   
      if (opt) {
        Element.hide('note_label');
        Element.hide('note_txt');
        document.form_ae.note_display.value = "none";
      } else {
        Element.show('note_label');
        Element.show('note_txt');
        document.form_ae.note_display.value = "inline";
      }   
   }
</script>

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

    <tr><th align=right>Resource Type: <font color=red><formerror id="resource_category_id"></formerror></font></th>
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

    <tr><th align=right>Room: <font color=red>*<formerror id="room"></formerror></font></th>
        <td align=left>
                <formwidget id="room">
                
       </td>
    </tr>

    <tr><th align=right>Floor: <font color=red>*<formerror id="floor"></formerror></font></th>
        <td align=left>
                <formwidget id="floor">
                
       </td>
    </tr>


    <tr><th align=right>Capacity: <font color=red><formerror id="capacity"></formerror></font></th>
        <td align=left>
                <formwidget id="capacity">
                
       </td>
    </tr>

    <tr><th align=right>Width: <font color=red><formerror id="dimensions_width"></formerror></font></th>
        <td align=left>
                <formwidget id="dimensions_width">
                
       </td>
    </tr>

    <tr><th align=right>Length: <font color=red><formerror id="dimensions_length"></formerror></font></th>
        <td align=left>
                <formwidget id="dimensions_length">
                
       </td>
    </tr>

    <tr><th align=right>Height: <font color=red><formerror id="dimensions_height"></formerror></font></th>
        <td align=left>
                <formwidget id="dimensions_height">
                
       </td>
    </tr>
    <tr><th align=right>Unit: <font color=red><formerror id="dimensions_unit"></formerror></font></th>
        <td align=left>
                <formwidget id="dimensions_unit">
                
       </td>
    </tr>

    <tr><th align=right>Color: <font color=red><formerror id="color"></formerror></font></th>
        <td align=left>
                <formwidget id="color">
                
       </td>
    </tr>
    <tr><th align=right>Allow Reservation? <font color=red>*<formerror id="reservable_p"></formerror></font></th>
        <td align=left>
                <formgroup id="reservable_p">@formgroup.widget;noquote@ @formgroup.label@ <br></formgroup>
                
       </td>
    </tr>
    <tr><th align=right>
         <div id="note_label" style="display:@note_display_val@;">
         Message to display when <br>not allowing reservations: <font color=red>*<br><formerror id="reservable_p_note"></formerror></font>
         </div>
         </th>
         <td align=left>
         <div id="note_txt" style="display:@note_display_val@;">
                <formwidget id="reservable_p_note">
         </div>                
         </td>
    </tr>
    </div>
    <tr><th align=right>Special Request Only? <font color=red>*<formerror id="special_request_p"></formerror></font></th>
        <td align=left>
                <formgroup id="special_request_p">@formgroup.widget;noquote@ @formgroup.label@ <br></formgroup>
                
       </td>
    </tr>
    <tr><th align=right>New Notify Email: <font color=red><formerror id="new_email_notify_list"></formerror></font></th>
        <td align=left>
                <formwidget id="new_email_notify_list">
                
       </td>
    </tr>
    <tr><th align=right>Update Notify Email: <font color=red><formerror id="update_email_notify_list"></formerror></font></th>
        <td align=left>
                <formwidget id="update_email_notify_list">
                
       </td>
    </tr>
<tr><td>&nbsp;</td><td><input type="submit" name="submit_button" value="    @submit_btn@     " /></td></tr>
</table>
</formtemplate>
