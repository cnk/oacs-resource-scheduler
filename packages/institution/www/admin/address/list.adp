<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>

<if @addresses:rowcount@ gt 0>
<table class="layout"  width="100%">
	<tr><td align="left" valign="top"><span class="secondary-header">Address<if @addresses:rowcount@ gt 1>es</if></span> (click name below to view)</td>
		<if @address_action_url_exists_p@><th class="secondary-header">Action</th></if>
	</tr>

	<multiple name="addresses">
		<!-- output leading space and expand/collapse widget -->
		<if @addresses.rownum@ odd>
			<tr bgcolor="#CBDBEC"></if>
		<else><tr bgcolor="#FFFFFF"></else>

		<!-- output address title/name row(@addresses.rownum@) -->
		<td><if @addresses.detail_url@ not nil>
				<a href="@addresses.detail_url@">
			</if>
			@addresses.descriptive_display@
			<if @addresses.detail_url@ not nil>
				</a>
			</if>
		</td>

		<!-- output available actions -->
		<if @addresses.action_url_exists_p@>
			<td><small>
				[
				<if @addresses.edit_url@ not nil>
					<a href="@addresses.edit_url@">Edit</a>
				</if><else><b style="text-color: grey"><i>Edit</i></b></else>
				|
				<if @addresses.delete_url@ not nil>
					<a href="@addresses.delete_url@">Delete</a>
				</if><else><b style="text-color: grey"><i>Delete</i></b></else>
				<if @addresses.permit_url@ not nil>
				|
					<a href="@addresses.permit_url@">Permit</a>
				</if>
				]
				</small>
			</td>
		</if>
		</tr>
	</multiple>
</table>
</if><else><if @if_none_put@ not nil><i>@if_none_put@</i><br></if></else>
