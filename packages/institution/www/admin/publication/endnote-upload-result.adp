<master>
<property name="title">@title@</property>
<property name="context_bar">@context_bar@</property>
<span class="primary-header">Institution Admin: @title@</span>
<br><br>

<if @successes@ gt 0>
 The following publications were sucessfully uploaded for the following personnel:
<p>@personnel_map@
<ul>
@success_upload@
</ul>
</if>

<if @failures@ gt 0>
 The following publications were NOT sucessfully uploaded
<ul>
@failure_upload@
</ul>
</if>

<if @no_title_counter@ gt 0>
There were @no_title_counter@ publications not uploaded because they did not have a title.
</if>

<if @personnel_id@ ne 0><li> <a href="../personnel/detail?personnel_id=@personnel_id@#publications">Return to Step 4 </a></li></if>
<if @sitewide_admin_p@ eq 1><li> <a href="./index">Click here to go to the Publications Index Page. </a> </li></if>

</ul>
