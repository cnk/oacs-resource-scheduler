<master>
<property name=title> @page_title;noquote@ </property>
<property name=context> @page_title;noquote@ </property>
                                                             
<include src="../view-option-panel" cal_id=@cal_id@ view_option="advanced">

<br>

<formtemplate id="filter_ae">
<table id="standard" width=90%>
<tr><td id="admin" width=25%><font color="red">*</font>Filter Name: </td><td id="admindata"><formwidget id="filter_name" /><font color="red"><formerror id="filter_name"></formerror></font></td></tr>
<tr><td id="admin" width=25%><font color="red"></font>Description: </td><td id="admindata"><formwidget id="description" /><font color="red"><formerror id="description"></formerror></font></td></tr>
<tr><td id="admin" width=25%><font color="red">*</font>Filter Type: </td><td id="admindata"><formwidget id="filter_type" onChange="displaySetting()" /><font color="red"><formerror id="filter_type"></formerror></font></td></tr>

<tr>
    <td id="admin"><span id="room1" style=dsiplay:none;>Resources: <br>(Check to include)</span></td>
    <td id="admindata"><span id="room2" style=dsiplay:none;>
    <table>
       <formgroup id="room_id">
          <tr><td>@formgroup.widget;noquote@ @formgroup.label;noquote@ <font color="red"><formerror id="room_id"></formerror></font></td>
              <td>Color:<formwidget id="color_@formgroup.option@" onChange="checkColorDuplicate()" />
	                <font color="red"><formerror id="color_@formgroup.option@"></formerror></font>
	      </td>
	  </tr>
       </formgroup>
   </table>
   </span>
   </td>
</tr>

<tr>
    <td id="admin"><span id="category1" style=display:none;>Categories: <br>(Check to include)</span></td>
    <td id="admindata"><span id="category2" style=display:none;>
    <table>
       <formgroup id="category_id">
          <tr><td>@formgroup.widget;noquote@ @formgroup.label;noquote@ <font color="red"><formerror id="category_id"></formerror></font></td>
	      <td>Color:<formwidget id="color_@formgroup.option@" onChange="checkColorDuplicate()" />
                        <font color="red"><formerror id="color_@formgroup.option@"></formerror></font>
	      </td>
	  </tr>
       </formgroup>
    </table>
    </span>
    </td>
</tr>

<tr><td colspan=2 align=center><br></br><formwidget id="submit"/></td></tr>
<tr><td colspan=2><font color="red">* required</font>
</table>
</formtemplate>

<script type="text/javascript" src="../js/layer-procs.js"></script>
<script type="text/javascript">

displaySetting();

function displaySetting () {

  if (document.forms.filter_ae.filter_type.value=='resource') {

//  var tableRow = document.getElementById('room');
//  tableRow.style.display = 'block';
//  var tableRow = document.getElementById('category');
//  tableRow.style.display = 'hide';

     showHideWidget('room1','show');
     showHideWidget('room2','show');
     showHideWidget('category1','hide');
     showHideWidget('category2','hide');
  } 
  else if (document.forms.filter_ae.filter_type.value=='category') {
  //var tableRow = document.getElementById('room');
  //tableRow.style.display = 'hide';
  //var tableRow = document.getElementById('category');
  //tableRow.style.display = 'block';
     showHideWidget('category1','show');
     showHideWidget('category2','show');
     showHideWidget('room1','hide');
     showHideWidget('room2','hide');
  } 
  else {
  //var tableRow = document.getElementById('room');
  //tableRow.style.display = 'hide';
  //var tableRow = document.getElementById('category');
  //tableRow.style.display = 'hide';
     showHideWidget('category1','hide');
     showHideWidget('category2','hide');
     showHideWidget('room1','hide');
     showHideWidget('room2','hide');
  }
}

function checkColorDuplicate () {

}

</script>

