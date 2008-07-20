<!-- $Id: datetime-widgets.adp,v 1.4 2003-09-22 19:44:28 lars Exp $ -->

<master src="master">

<property name="title">@title;noquote@</property>

<p>There is one main procedure to generate date and time widgets:

<pre>
dt_widget_datetime [-show_date 0 -use_am_pm 0 -default none] name granularity
</pre>

<p>The parameter <code>granularity</code> can be set to seconds,
minutes, five minute intervals, quarter-hour intervals, half-hour intervals, hours, days, or months.  The other
parameters are self-explanatory.</p>

<p>The following table shows examples of the various date and time
widgets:</p>

<blockquote>
<form>
<table width="95%">

<tr bgcolor=#eeeeee> <th>Procedure</th> <th>Widget</th> </tr>

<multiple name="dt_examples">
    <tr align=left>
        <td><code>@dt_examples.procedure@</code></td>
        <td>@dt_examples.result@</td>
    </tr>
</multiple>

</table>
</form>
</blockquote>

<h4>Notes</h4>

<ol>

<li>The default time for <code>dt_widget_datetime</code> can be
specified using any format that can be parsed by <code>clock scan</code>.

<li>In the examples above, the variable <code>name</code> represents
the form variable that would be set by the widget.  The script on the
processing end should anticipate the parameters <code>name.year</code>,
<code>name.month</code>, etc.



</ol>

