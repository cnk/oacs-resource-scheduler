<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>
<master>
<property name="title">@title@</property>
<property name="context">@context@</property>

<table class="layout">
	<tr><td><if @n_items@ gt 0>
				<include src="list" &="items" &="party_id">
			</if><else>
				<i>None</i><br>
			</else>
		</td>
	</tr>
</table>

<if @create_p@>
	<ul><li><a href="@email_create_url@">
				Add an Email Address
			</a>
		</li>
	</ul>
</if>