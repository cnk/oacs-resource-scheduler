<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>
<master>
<property name="title">@title@</property>

<table width="100%">
<tr>
<td>

<div style="padding-left: 5px; padding-bottom: 5px; padding-right: 5px; padding-top: 5px">

<!-- ---------------------------Add Body Content Here------------------- -->
<script language="javascript1.2"><!--
	function doSearchOnLetter(ltr) {
		with(document.search) {
			// reset to defaults
			for(i = 0; i < elements.length; i++) {
				if(elements[i].name == 'display'			||	// dont reset the display order
					elements[i].name == 'search'			||	// (if there was separately configurable sorting, one would have to write code to skip resetting that as well)
					elements[i].name == '__confirmed_p'		||
					elements[i].name == '__refreshing_p'	||
					elements[i].name == 'form:id') {
					continue;
				}

				elements[i].value = null;			// reset the element value
				if(elements[i].options)				// if the element is a select list, select first in list
					elements[i].options[0].selected = true;
			}

			// setup lastname search based upon first letter
			last_name.value = ltr;
			first_name.value="";
			keyword.value="";
			ln_cond.options[2].selected = true;

			// start the results displaying at 1st result
			if(startrow)
				startrow.value = 1;

			// run the search
			submit();
		}

		return true;
    }
//--></script>
<formtemplate id="search">
<p>
<if 0><!-- BEGIN hide the search criteria if there are results to be shown
		NOTE the form variables will still be needed to store the criteria for
			displaying multiple pages of results --></if>
<if @n_results_on_page@ defined>
	<div style="position: absolute; visibility: hidden; top: 0px; bottom: 0px; right:0px; width:200px;">
</if>
	<table class="layout" width="100%">
		<tr><td colspan="100%" align="left">
		<span class="primary-header">
			<b>Find personnel by choosing from the following search options.</b>
		</span><br><br>
		</td></tr>
		<tr><td colspan="100%" align="left">
			<font class="secondary-header">
				Select personnel that match <formwidget id="combine_method"/>of the criteria below.</font><br><br></td>
		</tr>

		<tr><td colspan="100%"><img src="@subsite_url@images/h-teal-pixel.gif" width="95%" height="1"><br><br></td>
		</tr></table>
	<table align="left">
		<tr><td/><td/></tr> <!-- magic row to shrink left-most column -->

	    <tr><td align="right" class="main-text-bold">
			First Name:</td><td>
			<formwidget id="fn_cond"/><formwidget id="first_name"/><br>
			<img src="@subsite_url@images/spacer.gif" width="100%" height="5"></td>
		</tr>
		<tr><td align="right" class="main-text-bold">
			Last Name:</td><td>
			<formwidget id="ln_cond"/><formwidget id="last_name"/><br>
			<img src="@subsite_url@images/spacer.gif" width="100%" height="5"></td>
		</tr>
		<tr>
		    <td align="right" class="main-text-bold">
			Keyword:</td><td>
			<formwidget id="keyword"/></td>
		</tr>
		<tr><td align="right" valign="middle" class="main-text-bold">
			Department/Division:</td><td>
			<formwidget id="group_id"/>
			<img src="@subsite_url@images/spacer.gif" width="100%" height="5"></td>
		</tr>
		<tr><td align="right" class="main-text-bold">
			Display Order:</td><td>
			<formwidget id="display"/></td>
		</tr>
		<tr><td>&nbsp;</td><td align="left">
			<br><formwidget id="search"/></td>
		</tr>
		<tr><td colspan="100%" align="left"><br><br>@letter_index@<br><br></th></tr>
	</table>

<!-- END hide the search criteria if there are results to be shown -->
<if @n_results_on_page@ defined>
	</div>
</if>

<if @n_results_on_page@ defined>
<input type="hidden" name="startrow" value="@startrow@">

<br><a href="."><ul><li>Click here to perform a New Search</ul></a>

	<if @n_results_on_page@ le 0>
		<center><b>No Personnel matched your search criteria.</b></center><br></if>
	<else>
		<center><b>
		<if @n_results_on_page@ gt 1>
				Showing results @first_visible@ through @last_visible@ out of
				@n_results@
				matching personnel</if>
			<else>Found 1 personnel matching your criteria.</else>
				<br><br>
			</b>
		</center>

		<table align="center" border="0" cellpadding="2" cellspacing="2">
			<!-- BEGIN iteration buttons -->
			<tr><td colspan="100%">
				<include	src="iterators"
							rowcount="@n_results@"
							position="@startrow@"
							maxrows="@maxrows@"></td>
			</tr>
			<!-- END iteration buttons -->

			<!-- Data --><tr><td><table class="layout" width="100%" border="0">
			<multiple name="found">
				<if @found.rownum@ odd>
					<tr bgcolor="#CBDBEC"></if>
				<else><tr bgcolor="#FFFFFF"></else>

				<!-- Photo -->
				<td align="center">
					<if @found.photo_p@>
						<div style="padding-left: 5px; padding-right: 5px">
							<img height="35" src="@found.photo_url@">
						</div>
					</if>
					<else><div style="height: 35px;"> </div></else>
					<!-- <else>src="@subsite_url@images/photo-not-available.gif"</else> -->
					</img>
				</td>

				<!-- Name -->
				<td><a href="@found.detail_url@"><nobr>
						<if @display@ eq "first_names">@found.first_names@ @found.last_name@</if>
						<else>@found.last_name@, @found.first_names@</else>
						@found.degree_titles@
					</nobr>
					</a>
				</td>

				<td><if @found.departments_html@ not nil>
						<ul><li>@found.departments_html@</li></ul>
					</if>
					<else>&nbsp;</else>
				</td></tr>
			</multiple></table></td></tr>

			<!-- BEGIN iteration buttons -->
			<tr><td colspan="100%">
				<include	src="iterators"
							rowcount="@n_results@"
							position="@startrow@"
							maxrows="@maxrows@"></td>
			</tr>
			<!-- END iteration buttons -->

		</table><br>

	</else>

</if>
<else>
<input type="hidden" name="startrow" value="0">
</else>

</formtemplate>
</div>

<script language="JavaScript1.2"><!--
	// when the page is loaded, save the initial value of each formvar
	with(document.forms.search) {
		for(i = 0; i < elements.length; i++) {
			elements[i].initial_value = elements[i].value;
		}
	}

	// resubmit the original input (except the startpos)
	function reSubmitInitial(initial) {
		with(document.forms.search) {
			if(!initial) {
				elements.startrow.value = 1;
			} else {
				for(i = 0; i < elements.length; i++) {
					if(elements[i] != startrow && elements[i].value != elements[i].initial_value) {
						elements[i].value = elements[i].initial_value;
					}
				}
			}
			submit();
		}
	}
//--></script>

<!-- --------------------------End Body Content Here-------------------- -->
</div>

</td>
</tr>
</table>
