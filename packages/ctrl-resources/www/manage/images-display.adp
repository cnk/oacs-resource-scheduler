<table>

<if @list_images:rowcount@ eq 0>
 <tr><td>There are no images</td></tr>
</if>
<else>
  <multiple name="list_images">
   <tr><td>@list_images.image;noquote@</td>
    <td><if @manage_p@ eq 1>@list_images.delete_link;noquote@</if></td>
  </tr>

 </multiple>
</else>

</table>
