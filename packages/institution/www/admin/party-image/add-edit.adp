<if 0><!-- -*- mode: html; tab-width: 4 -*- --></if>
<master>
<property name="title">@title@</property>
<property name="context">@context@</property>

<if @step@ not nil>
	<table cellpadding="2" cellspacing="2" border="0" width="100%">
		<tr><td bgcolor="#ffffcc">
				<span class="primary-header">@title@</span> &nbsp;&nbsp;
				<a  href="@party_detail_url@#research-info">Don't Save &amp; Return to Step @step@</a>
			</td>
		</tr>
	</table>
</if>

<formtemplate id="add_edit"></formtemplate>

<if @action@ eq "Edit">
	<if @can_delete_or_permit_p@>
		<ul>
		<if @party_image_delete_url@ not nil>
			<li><a href="@party_image_delete_url@">Delete This Image</a></li>
		</if>
		<if @party_image_permit_url@ not nil>
			<li><a href="@party_image_permit_url@">Change the Permissions on This Image</a></li>
		</if>
		</ul>
	</if>
</if>

<h3>Usage:</h3>
<p>To reference this image in the <b>description</b>/<b>biography</b> of a
<b>group</b>/<b>person</b> use the <code>&lt;image ... /&gt;</code> tag.
<b>Note</b> the <code>/</code> before the <code>&gt;</code>.  Here is a
description of the attributes that can be used with this tag:</p>
<p><pre>
    &lt;image name="NAME"
           max_height="MAX_HEIGHT"
           max_width="MAX_WIDTH"
           (Any others from &lt;<a href="http://www.w3.org/TR/REC-html40/struct/objects.html#edef-IMG">img</a>&gt;)
    /&gt;
</pre></p>
<p>The quotes around values are encouraged.  The <code>name</code> attribute
is used to find an image with a matching <code>description</code>.  The
<code>max_height</code> and <code>max_width</code> attributes are unique to
the <code>&lt;image ... /&gt;</code> tag and allow limits to be placed on the
size of an image that is embedded in a page.  Any other
<code><a href="http://www.w3.org/TR/REC-html40/struct/objects.html#edef-IMG">&lt;img&gt;</a></code>
attributes may also be used with the <code>&lt;image ... /&gt;</code> tag.</p>
