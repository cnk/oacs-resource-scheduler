<master>
<table width=100% cellspacing=1 cellpadding=1>
<if @sttp_selection:rowcount@ ne 0>
<multiple name="sttp_selection">
  <tr>
   <td>Mentor:</td>
   <td>@sttp_selection.first_names@&nbsp;@sttp_selection.last_name@</td>
  </tr>
  <tr>
  <tr>
   <td>Department/Division/...</td>
   <td>@sttp_selection.short_name@</td>
  </tr>
  <tr>
   <td>Project Description:</td>
   <td>@sttp_selection.description@</td>
  </tr>
  <tr>
   <td>Web Page:</td>
   <td>@sttp_selection.url@</td>
  </tr>
  <tr>
   <td>Number of current graduate students:</td>
   <td>@sttp_selection.n_grads_currently_employed@</td>
  </tr>
  <tr>
   <td>Previous medical student mentored:</td>
   <td>@sttp_selection.last_md_candidate@&nbsp;@sttp_selection.last_md_year@</td>
  </tr>
  <tr>
   <td>Skills preferred:</td>
   <td>@sttp_selection.skill@</td>
  </tr>
</multiple>
</if>
<else>
  <tr>
   <td>Department/Division/...</td>
   <td>N/A</td>
  </tr>
  <tr>
   <td>Project Description:</td>
   <td>N/A</td>
  </tr>
  <tr>
   <td>Web Page:</td>
   <td>N/A</td>
  </tr>
  <tr>
   <td>Number of current graduate students:</td>
   <td>N/A</td>
  </tr>
  <tr>
   <td>Previous medical student mentored:</td>
   <td>N/A</td>
  </tr>
  <tr>
   <td>Skills preferred:</td>
   <td>@sttp_selection.skills@</td>
  </tr>
</else>
<if @sttp_email:rowcount@ ne 0>
<multiple name="sttp_email">
  <tr>
   <td>Email @sttp_email.description@:</td>
   <td><a href="mailto:@sttp_email.email@">@sttp_email.email@</a></td>
  </tr>
</multiple>
</if>
<else>
  <tr>
   <td>Email:</td>
   <td>N/A</td>
  </tr>
</else>
<if @sttp_phone:rowcount@ ne 0>
<multiple name="sttp_phone">
  <tr>
   <td>Phone @sttp_phone.description@:</td>
   <td>@sttp_phone.phone_number@</td>
</tr>
</multiple>
</if>
<else>
  <tr>
   <td>Phone:</td>
   <td>N/A</td>
  </tr>
</else>
<if @sttp_address:rowcount@ ne 0>
<multiple name="sttp_address">
  <tr>
   <td>Address @sttp_address.description@:</td>
   <td>@sttp_address.building_name@&nbsp;@sttp_address.room_number@</td>
  </tr>
</multiple>
</if>
<else>
  <tr>
   <td>Address:</td>
   <td>N/A</td>
  </tr>
</else>
<tr>
  <td><br><b>Actions</b><ul>
       	<li><a href="@sttp_edit@?personnel_id=@sttp_selection.personnel_id@&request_id=@sttp_selection.request_id@&title_p=2">Edit</a></li>
	<li><a href="@sttp_delete@?personnel_id=@sttp_selection.personnel_id@&request_id=@sttp_selection.request_id@&title_p=3">Delete</a></li>
      </ul>
  </td>
</tr>
<tr align=center>
  <td colspan=2><a href="index"><h2>[ Back to Mentor List ]</h2></a><br><br><br><br></td>
</tr>
</table>


