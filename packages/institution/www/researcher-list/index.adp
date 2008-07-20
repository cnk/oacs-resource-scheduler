<master>
<property name="title">Researchers</property>

<if @personnel:rowcount@ eq 0>
	 <span class="secondary-header"><i>No Faculty Have Declared Research Interests Currently</i></span>
</if>

<table width="100%">
<multiple name="personnel">
	<group column="last_name_initial">
		<tr><td valign="top"><if @personnel.groupnum@ eq 1>
					<a name="@personnel.last_name_initial@"></a>
					<span class="secondary-header">
						@personnel.last_name_initial@
					</span>
					<!-- Next Row -->
					</td></tr><tr><td>
				</if>
				<a href="@personnel.detail_url@">
					@personnel.last_name@,
					@personnel.first_names@</a>
				<if @personnel.research_interest_title@ not nil>
					<!-- Next Column -->
					</td><td valign="top">
					<i>@personnel.research_interest_title@</i>
				</if>
			</td>
		</tr>
	</group>
</multiple>
</table>

<!-- --------------------------------- End Body ---------------------------- -->


