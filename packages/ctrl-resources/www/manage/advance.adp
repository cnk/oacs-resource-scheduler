<master>
<property name="context">@context@</property>

@cnsi_context_bar;noquote@

<form method="post" action="advance2">
<input type=hidden name=room_id value=@room_id@ />
<table cellpadding="3" cellspacing="3" bgcolor=white>
   <tr>
      <td valign=top class="list-list-pane" valign="top">
         <table class="list" cellpadding="3" cellspacing="1">
            <tr class="list-header">
               <th class="list"> &nbsp; </th>
               <th class="list"> Subsite </th>
            </tr>
            <multiple name="subsite">
               <if @subsite.rownum@ lt @subsite:rowcount@>
                  <if @subsite.rownum@ odd> <tr class="list-odd"> </if>
                  <else>                         <tr class="list-even"> </else>
               </if>           
               <else>
                  <if @subsite.rownum@ odd> <tr class="list-odd last"> </if>
                  <else>                         <tr class="list-even last"> </else>
               </else>
               <td class="list">
                  <if @subsite.write_p@ eq 1>
                     <if @subsite.checked@ gt 0>
                        <input type="checkbox" name="subsite_ids.@subsite.subsite_id@" checked />
                     </if>
                     <else>
                        <input type="checkbox" name="subsite_ids.@subsite.subsite_id@" />
                     </else>
                  </if>
                  <else>
                     &nbsp;
                  </else>
               </td>
               <td class="list">@subsite.subsite_name;noquote@</td>
               </tr>
            </multiple>
         </table>
      </td>
   </tr>
   <tr><td colspan=2 align=center><input type=submit value="   Update   "></td></tr>
</table>
</form>
