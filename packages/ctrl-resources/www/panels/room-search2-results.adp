<master>
<property name="title">@title@ </property>
<property name=context> @context@</property>

<br/>
Here are the rooms that matched your criteria exactly:
<p/>
   <fieldset>  <legend> <b> Matched Rooms </b> </legend>
<table cellpadding="3" cellspacing="3">
    <tr>
      <td class="list-list-pane" valign="top">
           <listtemplate name="room"></listtemplate>
      </td>
    </tr>
</table>

<if @room2_ctr@ gt 0>
<br/>
Below are our recommended rooms that matches most of your criteria with less equipment:
<p/>
   <fieldset>  <legend> <b> Recommended Rooms </b> </legend>
@room2_pagination;noquote@
<table cellpadding="3" cellspacing="3">
    <tr>
      <td class="list-list-pane" valign="top">
           <listtemplate name="room2"></listtemplate>
      </td>
    </tr>
</table>
</if>
