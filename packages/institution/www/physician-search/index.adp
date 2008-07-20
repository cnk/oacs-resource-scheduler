<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>
<master src="/packages/shared/www/templates/physician-finder-master">
<property name="title">@title@</property>

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
		<span class="main-text">
			<p>
			From medical specialties including primary care to orthopaedics to organ
			transplantation, UCLA Healthcare physicians are a select group of
			experts who have distinguished themselves as innovative leaders in their
			chosen disciplines. As part of an academic medical center, our doctors
			have access to advanced diagnostics, treatments and research that may
			not yet be widely available elsewhere.
			</p>
			<p>
			Find a medical specialist to meet your needs by choosing from the
			following search options.
			</p>
		</span>
		</td></tr>
		<tr><td colspan="100%" align="center">
			<font class="secondary-header">
				Select physicians that match <formwidget id="combine_method"/>of the criteria below.</font><br><br></td>
		</tr>

		<tr><td colspan="100%"><img src="@subsite_url@images/h-teal-pixel.gif" width="95%" height="1"><br><br></td>
		</tr></table>
	<table align="center">
		<tr><td/><td/></tr> <!-- <- magic row to shrink left-most column -->

		<tr><td align="right" class="main-text-bold">
			Specialty:</td><td>
			<formwidget id="specialty"/><br>
			<img src="@subsite_url@images/spacer.gif" width="100%" height="5"></td>
		</tr>

		<tr><td align="right" class="main-text-bold">
			Clinical Interest:</td><td>
			<formwidget id="clinical_interest"/><br>
			<img src="@subsite_url@images/spacer.gif" width="100%" height="5"></td>
		</tr>

		<tr><td align="right" class="main-text-bold">
			Disease Body System:</td><td>
			<formwidget id="disease"/></td>
		</tr>

		<tr><td align="right" class="main-text-bold">
			Language:</td><td>
			<formwidget id="language_spoken"/><br>
			<img src="@subsite_url@images/spacer.gif" width="100%" height="5"></td>
		</tr>
		<tr><td align="right" class="main-text-bold">
			Gender:</td><td>
			<formwidget id="gender"/><br>
			<img src="@subsite_url@images/spacer.gif" width="100%" height="5"></td>
		</tr>
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
		<tr><td align="right" class="main-text-bold">
			Display Order:</td><td>
			<formwidget id="display"/></td>
		</tr>
		<tr><td/><td align="left">
			<br><formwidget id="search"/></td>
		</tr>
		<tr><td colspan="100%" align="center">@letter_index@<br><br></th></tr>
	</table>
	<span class="main-text"><br>
		For personal help finding a doctor, please call us at (800) UCLA-MD1
		(825-2631) Monday to Friday, 8 a.m. to 5 p.m. (PST) or email us at <a href="mailto:access@mednet.ucla.edu">access@mednet.ucla.edu</a>.
		A list of health insurance companies that provide coverage for our
		services is available on our <a href="/healthsciences/healthcare/healthplans">Health Plans</a> page.</span>

<!-- END hide the search criteria if there are results to be shown -->
<if @n_results_on_page@ defined>
	</div>
</if>

<if @n_results_on_page@ defined>
<input type="hidden" name="startrow" value="@startrow@">

<br><a href="."><ul><li>Click here to perform a New Search</ul></a>

	<if @n_results_on_page@ le 0>
		<center><b>No Physicians matched your search criteria.</b></center><br></if>
	<else>
		<center><b>
		<if @n_results_on_page@ gt 1>
				Showing results @first_visible@ through @last_visible@ out of
				@n_results@
				matching physicians</if>
			<else>Found 1 physician matching your criteria.</else>
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

				<td><!-- <a href="department_url"> -->
					<if @found.departments_html@ not nil><ul><li>@found.departments_html@</li></ul></if><else>&nbsp;</else>
					<!-- </a> -->
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
