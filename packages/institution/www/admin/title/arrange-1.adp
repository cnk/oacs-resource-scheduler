<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>
<master>
<property name="title">@title@</property>
<property name="context">@context@</property>

<if @step@ not nil>
	<table cellpadding="2" cellspacing="2" border="0" width="100%">
		<tr><td bgcolor="#ffffcc">
				<span class="primary-header">
					<if @user_id@ eq @personnel_id@>
						Your
					</if><else>
						@personnel_name@'s
					</else>
					@object_type_pl@ for the <i>@subsite_name@</i> Website.
				</span> &nbsp;&nbsp;
				<a  href="@party_detail_url@#research">Don't Save &amp; Return to <nobr>Step @step@</nobr></a>
			</td>
		</tr>
	</table>
</if>

<script type="text/javascript" language="JavaScript1.4">
	function setEntityContent(entity, content) {
		if(document.getElementById) {
			entity.innerHTML = content;
		} else if (document.all) {
			entity.innerHTML = content;
		} else if (document.layers) {
			with(entity.document) {
				write(" ");
				close();
			}
			newEntity = new Layer("inherit", entity);

			with(newEntity.document) {
				write(content);
				close();
			}
			newEntity.visibility = "inherit";
			entity.visibility = "show";
		}
	}

	var titles			= [];

	function englishList(l) {
		var s = "";

		if(l.length > 0)
			s += l[0];

		for(var i = 1; i < l.length-1; i++) {
			s += ", " + l[i];
		}

		if(l.length > 1)
			s += " and " + l[l.length-1];

		return s;
	}

	function updateSecondaryDisplay() {
		var visible_titles = [];
		for(var i = 0; i < titles.length; i++) {
			if(document.titles_edit["show_p." + titles[i].gpm_id].checked) {
				visible_titles[visible_titles.length] = titles[i];
			}
		}

		var result = "";
		for(var i = 0, next = 1; i < visible_titles.length && (next-1) < visible_titles.length; i++, next++) {
			var t = [];
			i--;
			next--;
			do {
				i++;
				next++;
				t[t.length] = visible_titles[i].title;
			} while(next						< visible_titles.length	&&
					visible_titles[i].group_id	== visible_titles[next].group_id);

			var g = [];
			i--;
			next--;
			do {
				i++;
				next++;
				g[g.length] = visible_titles[i].group_name;
			} while(t.length				<= 1					&&
					next					< visible_titles.length	&&
					visible_titles[i].title	== visible_titles[next].title);

			result += englishList(t) + " of " + englishList(g);
			if(next < visible_titles.length) {
				result += "<br>";
			}
		}

		setEntityContent(document.getElementById("titles_display"), result);
		return result;
	}

	function swapTitles(i, j) {
		var ox		= document.titles_edit["order." + i],
			oy		= document.titles_edit["order." + j];

		var	x		= ox.value,
			y		= oy.value;

		var tI		= titles[x],
			tJ		= titles[y];
		titles[x]			= tJ;
		titles[y]			= tI;

		ox.value			= y;
		oy.value			= x;
	}

	var ELEMENT_NODE_TYPE = 1;

	function findAppropriateAncestor(n) {
		return n.parentNode;
	}

	function move_towards_beginning(n) {
		var curr = findAppropriateAncestor(n);
		var prev = curr;

		// search bacward for a sibling we can exchange this with
		do {
			prev = prev.previousSibling;
		} while(prev != null && prev.nodeType != ELEMENT_NODE_TYPE);
		if(prev == null || prev.nodeType != ELEMENT_NODE_TYPE) {
			return;
		}

		// exchange previous and this in the DOM
		var prnt = curr.parentNode;
		prnt.insertBefore(curr, prev);
		prnt.normalize();

		swapTitles(curr.id, prev.id);
		updateSecondaryDisplay();
	}

	function move_towards_end(n) {
		var curr = findAppropriateAncestor(n);
		var next = curr;

		// search forward for a sibling we can exchange this with
		do {
			next = next.nextSibling;
		} while(next != null && next.nodeType != ELEMENT_NODE_TYPE);
		if(next == null || next.nodeType != ELEMENT_NODE_TYPE) {
			return;
		}

		// exchange next and this in the DOM
		var prnt = curr.parentNode;
		prnt.insertBefore(next, curr);
		prnt.normalize();

		swapTitles(curr.id, next.id);
		updateSecondaryDisplay();
	}
</script>

<if 0><!--
	// Test Cases:
	//	1 title
	//	2 titles, no dup
	//	2 titles, dup title
	//	2 titles, dup group
	//	3 titles, no dup
	//	3 titles, dup first+second title
	//	3 titles, dup first+second group
	//	3 titles, dup second+third title
	//	3 titles, dup second+third group
	//	3 titles, dup first+second title AND second+third group
	//	3 titles, dup first+second group AND second+third title
	//	3 titles, dup first+second title AND second+third title
	//	3 titles, dup first+second group AND second+third group
--></if>

<form name="titles_edit" method="POST" action="arrange-2">
	<multiple name="arranged_titles">
		<div id="@arranged_titles.gpm_title_id@"><if 0><!-- the 'id' to the left is used to lookup this title in the title_position array which maps it to the titles array --></if>
			<input	type="checkbox"
					name="show_p.@arranged_titles.gpm_title_id@"
					value="1"
					<if @arranged_titles.show_p@ eq "true">checked="1"</if>
					onClick="updateSecondaryDisplay();"/>
			<input	type="hidden"
					name="order.@arranged_titles.gpm_title_id@"
					value="@arranged_titles.rnmo@"/>

			<script type="text/javascript" language="JavaScript1.4">
				titles[@arranged_titles.rnmo@] = {
					gpm_id:		@arranged_titles.gpm_title_id@,
					title_id:	@arranged_titles.title_id@,
					title:		"@arranged_titles.title@",
					group_id:	@arranged_titles.group_id@,
					group_name:	"@arranged_titles.group_name@",
					show_p:		@arranged_titles.show_p@
				};
			</script>

			<a onClick="move_towards_beginning(this)" href="#">
				<img src="images/arrow-up" class="image-button"
					alt="move-title-up"
					title="Move this title more towards the beginning of your list of titles."
				/></a>
			<a onClick="move_towards_end(this)" href="#">
				<img src="images/arrow-down" class="image-button"
					alt="move-title-down"
					title="Move this title more towards the end of your list of titles."
				/></a>
			@arranged_titles.title@, @arranged_titles.group_name@
		</div>
	</multiple>

	<blockquote><pre id="titles_display" style="display: inline;"></pre></blockquote>

	<input type="hidden" name="chosen_subsite_id"	value="@chosen_subsite_id@"/>
	<input type="hidden" name="personnel_id"		value="@personnel_id@"/>
	<input type="hidden" name="return_url"			value="@return_url@"/>
	<input type="hidden" name="step"				value="@step@"/>

	<br><input type="submit" name="submit" value="@user_execute_action@"/>
</form>

<script type="text/javascript" language="JavaScript1.4">
	updateSecondaryDisplay();
</script>
