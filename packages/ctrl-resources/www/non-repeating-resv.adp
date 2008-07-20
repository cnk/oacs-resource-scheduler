
<table width="100%" border="0" cellpadding="1" cellspacing="1">
   <td valign="top" width="55%">
      <formtemplate id="add_edit_event">         
         <table width="99%" cellpadding="0" cellspacing="1">
		<tr><th align="right">Subject<font color="red">*</font></th>
		    <td><formwidget id="title"/><font color="red"><formerror id="title"></formerror></font></td>
		</tr>
		<tr><th align="right">Description</th>
		    <td><formwidget id="description"/><font color="red"><formerror id="description"></formerror></font></td>
		</tr>
		<tr><th align="right">Start Date:
		     <a onclick="javascript:ctrl_cal(event,'start_date','end_date');"><img src="/resources/acs-templating/ctrl/cal.gif" alt="" /></a>
		    </th>
		    <td><formwidget id="start_date"/><font color="red"><formerror id="start_date"></formerror></font></td>
		</tr>
		<tr><th align="right">End Date:
		     <a onclick="javascript:ctrl_cal(event,'end_date','');"><img src="/resources/acs-templating/ctrl/cal.gif" alt="" /></a>
		     </th>	
		     <td><formwidget id="end_date"/><font color="red"><formerror id="end_date"></formerror></font></td>
		</tr>
		<tr><th align="right">All Day:</td>
		    <td><formgroup id="all_day_p">@formgroup.widget;noquote@ @formgroup.label;noquote@</formgroup></td>
		</tr>
		<if @room_has_eqpmt_p@>
		   <tr>
		      <th valign="top"><br />Equipment:</th>
		      <td><br />
			<formgroup id="room_eqpmt_check">
			@formgroup.widget;noquote@ @formgroup.label@ <br />
			</formgroup>
			<br />
			<br />
		      </td>
		   </tr>
		</if>		
		<tr><td>&nbsp;</td><td><formwidget id="submit"/><br /><br /></td></tr>
         </table>
      </formtemplate>
   </td></tr>
</table>

