<master>
<property name=title> @title@</property>
<property name=context> @context@</property>
                <script type="text/javascript">
                        var djConfig = {isDebug: true};
                </script>

                <script type="text/javascript" src="/dojo-0.3.0-ajax/dojo.js"></script>
                <script type="text/javascript">
                       dojo.require("dojo.widget.html.DatePicker");
                       dojo.require("dojo.widget.DropdownDatePicker");
                </script>

@cnsi_context_bar;noquote@
To view your past and pending reservations, click <a href=@previous_reservations_link@> here</a>.
<br>
<br>

Please select all search criteria that apply to your needs (leave everything as is to get complete listing):
<br><br>
<formtemplate id="search"> 

<table>
   <tr>  <td>All day event?:</td> <td>
       <formgroup id="all_day_p" onChange=dateShow();> 
         @formgroup.widget;noquote@ @formgroup.label;noquote@
       </formgroup>
   </td></tr>



   <tr> 
         <td>    
	      <span id="label_1" style=display:none;> 
                 Date of reservation: 
	      </span>
	</td> 

	<td>
	    <span id="widget_1" style=display:none;> 
	    	  <formwidget id="all_day_date">
            </span>		  
	</td>
   </tr>

   <!-- I put start date and end date in the same row because that is the easiest way to get it to work with the show/hide js (jcwang@cs.ucsd.edu)-->
      <tr> 
	      <td>
	         <span id="label_0">
	      	        Start Date: <br><br><br>
			End Date:
		 </span>
	      </td>  

	      <td>
	       <span id="widget_0">
	        <formwidget id="from_date" onChange=propogate();> <!-- <div  dojoType="datepicker" widgetId="date_widget" dojostyle="display:none;"></div><br>  -->
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
	     <td> @formgroup.widget;noquote@ @formgroup.label;noquote@ </td></tr>
	 </else>
       </formgroup>
      </table>
   </td></tr>



   <tr><td>&nbsp;</td><td><formwidget id="sub"> </td></tr>
</table>

<!-- <input type=button value="test" onClick="displayDate()"> -->
</formtemplate>



<script language="javascript" src="/javascript/scripts/layer-procs.js"> </script>
<script language="javascript" src="/javascript/scripts/radio-button-operations.js"> </script>

<script type="text/javascript">
    document.onload = dateInit();

    function handler(rfcDate) {
        alert(rfcDate);
    }
    function dateInit() {
/*        var style = document.getElementById("from_widget").style;
        style.display  = "none";
        alert('I am here');
        showHideWidget("from_widget","hide"); 
        dojo.event.connect(dojo.widget.byId("date_widget"), "setDate", handler);
*/
//        displayDate();
    }

    function displayDate () {
       alert('here');
       alert(dojo.widget.byId("date_widget").storedDate);
        dojo.event.connect(dojo.widget.byId("date_widget"), "setDate", handler);
        dojo.widget.byId("date_widget").toggleShowing();
    }

                </script>

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


