<master>
  <property name="title">@page_title;noquote@</property>
  <property name="context">@context;noquote@</property>

<p>
  There are a total of @connections:rowcount@ requests being served
  right now (to @distinct@ distinct IP addresses).  Note that this number
  seems to include only the larger requests.  Smaller requests, e.g.,
  for .html files and in-line images, seem to come and go too fast for
  this program to catch.
</p>

<p>
  Here's what uptime has to say about the box:
</p>
<pre>@uptime_output@</pre>

<h3>Connections</h3>

<p><listtemplate name="connections"></listtemplate></p>

