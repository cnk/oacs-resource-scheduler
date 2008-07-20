<master>
<property name=title> @title@ </property>
<property name=context> @context@ </property>
<property name=focus>event_signin.swiped_input</property>

<formtemplate id="event_signin">
<table>
<tr>
 <td bgcolor=#cccccc>
   <b><formwidget id ="event_title"/></b><br>
   <b><formwidget id ="category_name"/></b><br>
   <b><formwidget id ="start_date"/></b><br>
   <b><formwidget id ="end_date"/></b><br>
   <b><formwidget id ="event_description"/></b><br>
 </td>
</tr>
</table>
<table>
<tr>
 <td><b>UCLA Employee ID:</b></td>
 <td><formwidget id="swiped_input"/></td>
 <td><formwidget id="submit"/></td>
</tr>
</table>
</formtemplate
