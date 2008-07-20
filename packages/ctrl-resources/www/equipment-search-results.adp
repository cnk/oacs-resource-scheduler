<master>
<property name="title"> @title@ </property>
<property name="context"> @context@ </property>

@cnsi_context_bar;noquote@

<if @get_equipments:rowcount@ gt 0>
<multiple name="get_equipments">
   <if @get_equipments.rownum@ eq 1>
   Here are the equipment that matched your criteria exactly:
   <fieldset>  <legend> <b> Matched Equipments </b> </legend>
     <table>
       <tr> 
          <td> <b> Equipment Name </b> </td>
          <td> <b> Description </b> </td>
          <td> <b> Options </b> </td>
       </tr>
   </if>
   <if @get_equipments.rownum@ odd>
      <tr bgcolor=#eeeeee>
   </if>
   <else>
      <tr bgcolor=#ffffff>
   </else>
   <td> @get_equipments.name@  </td>
   <td> @get_equipments.description@ </td>
   <td> <a href=@get_equipments.details_url@> See Details and Reserve </a> </td>
   </tr>
   <if @get_equipments:rowcount@ eq @get_equipments.rownum@>
      </table>
      </fieldset>
   </if>
</multiple>
</if>
<else>
No equipment found matching your search
</else>
