<!-- $Id: calendar-navigation.adp,v 1.3 2003-09-22 19:44:28 lars Exp $ -->

<master src="master">

<property name="title">@title;noquote@</property>

<pre>dt_widget_calendar_navigation <i>base_url</i> <i>view</i> <i>date</i> <i>pass_in_vars</i> </pre>

<p>
<dl>
<p><dt><b>Parameters:</b></dt><dd>
<b>base_url</b> (optional)<br>
<b>view</b> (defaults to <code>week</code>)<br>
<b>date</b> (optional)<br>
<b>pass_in_vars</b> (optional)<br>
</dd>
</dl>

<p>This procedure creates a mini calendar useful for navigating
various calendar views.  It takes a base url, which is the url to
which this mini calendar will navigate.  When defined,
<code>pass_in_vars</code> can be url variables to be set in
<code>base_url</code>.  They should be in the format returned by
<code>export_url_vars</code>.  This procedure will set two variables
in that url's environment: <code>view</code> and <code>date</code>.

<p>Valid views are list, day, week, month, and year.</p>

<h3>Example</h3>

<p>The following shows a sample navigation form for this page, which
simply reads <code>view</code> and <code>date</code> as URL variables
and uses them to initialize the display.

<center>
<form>

@calendar_widget@

</form>
</center>

<p>Click on any view, date, or other navigational element to change
the display of this page.</p>

