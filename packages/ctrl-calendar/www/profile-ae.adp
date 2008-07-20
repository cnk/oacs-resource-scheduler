<master>
<property name=title> @title@ </property>
<property name=context> Profile </property>

<h2>@title@</h2>

<formtemplate id="add_edit_profile">
<table class="standard" width="100%">
<tr>
<td rowspan="100%" width="30%" valign=top>
If you wish to receive informative <b>Email notifications of Events</b> entered into the <i>Online Calendars</i>,
Please fill out the form to the right. 
</td>
<td align=center width="70%" class="greencell">
<b>My Profile:</b>
</td></tr>
<tr><td class="whitecell">
	<table width="100%">
	<tr><td>Notify me of new events that match my interests by email:<br/>
    	<formgroup id="email_period"> <br>
       	<input type="radio" name="email_period" value="@formgroup.option@" id="add_edit_profile:elements:email:@formgroup.option@" @formgroup.checked@
       	/> @formgroup.label@ 
       	<if @formgroup.rownum@ eq 1>
            <formwidget id="email_day"/>
       	</if>
    	</formgroup>
	</td></tr>
	</table>

</td>
</tr>
<tr>
<td class="whitecell">

<table width="100%">
<tr><td>Email me about events up to &nbsp;<formwidget id="email_upto" /> &nbsp; <formwidget id="email_upto_type" /> in the future.  </td></tr>
<tr><td><font color=red><formerror id=email_upto ></formerror></font></td></tr>
</table>

</td>
</tr>
<tr>
<td class="whitecell">

<table width="100%">
<tr><td>I wish to be notified of Events from the following calendars:<br/>
    <formgroup id="calendar"> <br>    
       <input type="checkbox" name="calendar" value="@formgroup.option@" id="add_edit_profile:elements:calendar:@formgroup.option@" @formgroup.checked@ 
          <if @formgroup.option@ eq 0>
             onclick="calendar_uncheck_rest(this.form,@formgroup.option@,@formgroup.rownum@)"
          </if>
          <else>
             onclick="calendar_uncheck_all(this.form,@formgroup.option@,@formgroup.rownum@)"
          </else>
       /> @formgroup.label@
    </formgroup></td></tr>
</table>

</td>
</tr>
<tr>
<td class="whitecell">

<table width="100%">
<tr><td>Subjects that interest me:<br/>
    <formgroup id="category"> <br> 
<%=[ctrl::cal::profile::display -label @formgroup.label@]%> <input type="checkbox" name="category" value="@formgroup.option@" id="add_edit_profile:elements:category:@formgroup.option@" @formgroup.checked@ 
          <if @formgroup.option@ eq 0>
             onclick="category_uncheck_rest(this.form,@formgroup.option@,@formgroup.rownum@)"
          </if>
          <else>
             onclick="category_uncheck_all(this.form,@formgroup.option@,@formgroup.rownum@)"
          </else>
       /> @formgroup.label@
    </formgroup></td></tr>
</table>

</td>
</tr>
<tr>
<td class="darkgreycell" align=center>

<formwidget id="submit"/>

</formtemplate>

<script language="javascript">
function category_uncheck_rest(form,option,i) {
   if (form.category[i-1].checked == true) {
      for (j=1;j<form.category.length;j++) {
         form.category[j].checked = false;
      }
   }
}
function category_uncheck_all(form,option,i) {
   if (form.category[i-1].checked == true) {
      form.category[0].checked = false;
   }
}
function calendar_uncheck_rest(form,option,i) {
   if (form.calendar[i-1].checked == true) {
      for (j=1;j<form.calendar.length;j++) {
         form.calendar[j].checked = false;
      }
   }
}
function calendar_uncheck_all(form,option,i) {
   if (form.calendar[i-1].checked == true) {
      form.calendar[0].checked = false;
   }
}
</script>

</td>
</tr>
</table>
