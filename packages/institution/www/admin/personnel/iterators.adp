<if 0><!-- -*- mode: html; tab-width: 4; -*- --></if>
			<!-- BEGIN iteration buttons -->
			<if @rowcount@ gt @maxrows@>
				<table class="layout" width="100%"><tr>

				<!-- first -->
				<if @first_visible@ gt 1>
					<td align="center">
						<a	rev="Start"
							class="main-text"
							href="#"
							onClick="with(document.forms.search) {startrow.value='1'; reSubmitInitial(true);}">
							1-@maxrows@</a>
					</td>
				</if>

				<!-- previous -->
				<if @prev_lo@ gt @maxrows@>
					<td align="center">
						<a	rev="Prev"
							class="main-text"
							href="#"
							onClick="with(document.forms.search) {startrow.value='@prev_lo@'; reSubmitInitial(true);}">
							@prev_lo@-@prev_hi@</a>
					</td>
				</if>

				<td align="center">
					<b>@first_visible@-@last_visible@</b>
				</td>

				<!-- next -->
				<if @next_lo@ lt @last_position@>
					<td align="center">
						<a	rev="Next"
							class="main-text"
							href="#"
							onClick="with(document.forms.search) {startrow.value='@next_lo@'; reSubmitInitial(true);}">
							@next_lo@-@next_hi@</a>
					</td>
				</if>

				<!-- last -->
				<if @last_visible@ lt @rowcount@>
					<td align="center">
						<a	rev="Next"
							class="main-text"
							href="#"
							onClick="with(document.forms.search) {startrow.value='@last_position@'; reSubmitInitial(true);}">
							@last_position@-@rowcount@</a>
					</td>
				</if>

				</tr></table>
				<br>
			</if>
			<!-- END iteration buttons -->
