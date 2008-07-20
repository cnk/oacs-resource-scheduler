<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>
<master>
<property name="title">@title@</property>
<property name="context">@context@</property>

@JAVASCRIPT_BEGIN@
	/* Utility ************************************************************** */
	function cloneObject(dst, src) {
		for(prp in src) {
			dst[prp] = src[prp];
		}
	}
	function dumpObject(src) {
		var result = '';
		for(prp in src) {
			result += prp + ' = "' + src[prp] + '"\n';
		}
		return result;
	}

	/* Hiding/Showing ******************************************************* */
	function moveSelectedOptionsToEnd(from, to) {
		if(from.disabled || to.disabled) {
			setAllPTo(false);
		}

		var j = 0;
		for(var i = 0, j = 0; i < from.options.length;) {
			if(from.options[i].selected) {
				from.options[i].selected	= false;
				var n						= to.options.length;
				//to.options[n]				= new Option();
				//to.options[n]				= from.options[i];
				//delete from.options[i];
				to.options[n]				= new Option(from.options[i].text, from.options[i].value);
				from.options[i]				= null;
			} else {
				i++;
			}
		}
	}
	function include() {
		with(document.@form_name@) {
			moveSelectedOptionsToEnd(excluded, included);
		}
	}
	function exclude() {
		with(document.@form_name@) {
			moveSelectedOptionsToEnd(included, excluded);
		}
	}

	/* Shifting ************************************************************* */
	function shiftSelectedOptions(list, n) {
		if(list.disabled) {
			return;
		}

		var	N		= (n < 0) ?					   -n :  n;
		var start	= (n < 0) ?						0 :  list.options.length-1;
		var end		= (n < 0) ?	list.options.length   : -1;
		var incr	= (n < 0) ?	1					  : -1;

		for(var i = start; i != end; i += incr) {
			if(list.options[i].selected) {
				var A	= list.options[i];
				var j	= i;
				var k	= N;

				sorted_p = false;

				// Shift elements over element i (incr==-1 => down, incr==+1 => up)
				for(; k > 0 &&
					  j >= 0 && j < list.options.length &&
					  (j-incr) >= 0 && (j-incr) < list.options.length; k--) {
					var B = list.options[j - incr];
					list.options[j] = new Option(B.text, B.value);
					j -= incr;
				}
				list.options[j] = A;
				N -= k;
			}
		}
	}

	/* Sorting ************************************************************** */
	var ascending	= 1;
	var sorted_p	= false;
	function compareSelectOptions(a, b) {
		var a_year = a.text.substring(0,6);
		var a_title = a.text.substring(6);
		var b_year = b.text.substring(0,6);
		var b_title = b.text.substring(6);

		if(a_year == b_year) {
			// when sorting otherwise-equal rows by title, always sort ascending
			if(a_title == b_title) {
				return 0;
			} else if(a_title < b_title) {
				return -1;
			}
			return 1;
		} else if(a_year < b_year) {
			return -ascending;	// this makes second click reverse sort order
		}
		return ascending;		// this makes second click reverse sort order
	}
	function sortOptions(select_widget_options) {
		if(sorted_p) {
			ascending = -ascending;	// reverse the sort order on a second click
		}

		// Copy (since we can't call select_widget_options.sort()!)
		var titles = new Array();
		for(i = 0; i < select_widget_options.length; i++) {
			//titles[i]		= select_widget_options[i];			// works everywhere except IE (this approach causes an error below)!
			titles[i]		= new Object();						// this instead of previous line...
			titles[i].text	= select_widget_options[i].text;	// this instead of the single line above...
			titles[i].value	= select_widget_options[i].value;	// this instead of the single line above...
			titles[i].year	= titles[i].text.substring(0, 6);
			titles[i].title	= titles[i].text.substring(6);
		}

		// Sort
		titles.sort(compareSelectOptions);

		// Copy back
		for(i = 0; i < titles.length; i++) {
			//select_widget_options[i] = titles[i];				// works everywhere (and would replace the next 3 lines) except for IE!
			select_widget_options[i]		= new Option();
			select_widget_options[i].text	= titles[i].text;
			select_widget_options[i].value	= titles[i].value;
		}

		sorted_p = true;			// so second click will know to reverse sort
	}

	/* Show All ************************************************************* */
	function setAllPTo(value) {
		with(document.@form_name@) {
			included.disabled	= value;
			sort_by.disabled	= value;
			sort_dir.disabled	= value;
			limit.disabled		= value;
			up.disabled			= value;
			dn.disabled			= value;

			if(all_p.checked	!= value) {
				all_p.checked	= value;
			}
		}
	}

	/* Submit *************************************************************** */
	function prepareForSubmit() {
		with(document.@form_name@.included) {
			for(var i = 0; i < options.length; i++) {
				options[i].selected = !document.@form_name@.all_p.checked;
			}
		}
		return true;
	}
@JAVASCRIPT_END@

<if @step@ not nil>
	<table cellpadding="2" cellspacing="2" border="0" width="100%">
		<tr><td bgcolor="#ffcc99">
				<span class="primary-header">
					<if @user_id@ eq @personnel_id@>
						Your
					</if><else>
						@personnel_name@'s
					</else>
					Publications for the <i>@subsite_name@</i> Website.
				</span> &nbsp;&nbsp;
				<a  href="@party_detail_url@#publications">Don't Save &amp; Return to <nobr>Step @step@</nobr></a>
			</td>
		</tr>
	</table>
</if>

<formtemplate id="@form_name@"></formtemplate>

@JAVASCRIPT_BEGIN@
	setAllPTo(document.@form_name@.all_p.checked);
@JAVASCRIPT_END@
