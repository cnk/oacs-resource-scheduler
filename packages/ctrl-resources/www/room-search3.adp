<master>
<property name=title> @title@</property>
<property name=context> @context@</property>

@cnsi_context_bar;noquote@

To view your past and pending reservations, click <a href=@previous_reservations_link@> here</a>.
<br>
<br>

Please select all search criteria that apply to your needs (leave everything as is to get complete listing):
<br><br>
<formtemplate id="search"> 

<table>
   <tr><td>Room Name (ie: Ackerman)</td> <td><formwidget id="name_arg"> </td></tr>
   <tr> <td>Minimum capacity:</td> <td><formwidget id="capacity_arg"> </td></tr>
   <tr>  <td>Location:</td> <td colspan=2><formwidget id="location"> </td></tr>
   <tr>  <td>All day event?:</td> <td>
       <formgroup id="all_day_p" > 
         @formgroup.widget;noquote@ @formgroup.label;noquote@
       </formgroup>
   </td><td><formwidget id="all_day_date"><formerror id="all_day_date"></formerror></td></tr>



   <!-- I put start date and end date in the same row because that is the easiest way to get it to work with the show/hide js (jcwang@cs.ucsd.edu)-->
      <tr> 
	      <td>
	         <span id="label_0">
	      	        Start Date: <br><br><br>
			End Date:
		 </span>
	      </td>  

	      <td colspan=2>
	       <span id="widget_0">
	        <formwidget id="from_date" onChange=propogate();> <br>
                <formwidget id="to_date"> 
		</span>
	      </td>
      </tr>


   <tr>  <td>Equipment categories:</td> <td colspan=2>
     <table>
       <formgroup id="eq"> 
         <if @formgroup.rownum@ odd>
           <tr><td> @formgroup.widget;noquote@ @formgroup.label;noquote@ </td>
	 </if>
	 <else>
	     <td colspan=2> @formgroup.widget;noquote@ @formgroup.label;noquote@ </td></tr>
	 </else>
       </formgroup>
      </table>
   </td></tr>

   <tr>  <td>Additional Services:</td> <td colspan=2><formwidget id="add_services"> </td></tr>


   <tr><td>&nbsp;</td><td><formwidget id="sub"> </td></tr>
</table>

</formtemplate>



<script language="javascript" src="/javascript/scripts/layer-procs.js"> </script>
<script language="javascript" src="/javascript/scripts/radio-button-operations.js"> </script>

<script language="javascript">
  function dateShow() {

   var radioButton=document.forms.search.all_day_p;
   var radioValue=getSelectedRadioValue(radioButton);

   if (radioValue == 0) {
      showHideWidget("label_0");
      showHideWidget("widget_0");
      var edit_section = document.getElementById("label_1").style.display='none';
      var edit_section = document.getElementById("widget_1").style.display='none';      
   } else {
      showHideWidget("label_1");
      showHideWidget("widget_1");
      var edit_section = document.getElementById("label_0").style.display='none';
      var edit_section = document.getElementById("widget_0").style.display='none';  
   }
  }

  function propogate() {
       var from_year=document.search["from_date.year"].value;
       var from_day=document.search["from_date.day"].value;
       var from_month=document.search["from_date.month"].value;

       var to_year=document.search["to_date.year"].value;
       var to_day=document.search["to_date.day"].value;
       var to_month=document.search["to_date.month"].value;

       if (to_year < from_year) { 
	      document.search["to_date.year"].value=from_year;
	} 

	if ( to_month <  from_month && to_year == from_year ) {
           document.search["to_date.month"].value=from_month;
	}

	if (to_month==from_month && to_day < from_day) {
      	      document.search["to_date.day"].value=from_day;
	}
  }

</script>


