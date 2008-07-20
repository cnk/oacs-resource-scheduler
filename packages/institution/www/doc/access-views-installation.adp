<master>
<property name="title" value="Installing/Uninstalling the ACCESS External Package"></property>
<table border=0 cellpadding=0 cellspacing=0 width=100%>
<tr><td>
<h2>Installing/Uninstalling the Access External Package</h2>
<hr>
<h3>Installing</h3>
<ul>
<li> %bash sqlplus /nolog
<li> SQL> connect / as sysdba;
<li> SQL> grant create any materialized view to healthsciences;
<li> SQL> exit
<li> %bash sqlplus healthsciences@devdb/******
<li> SQL> @access-materialized-views-create.sql
<li> SQL> exit
<li> %bash sqlplus access_external@devdb/******
<li> SQL> @access-external-views-create.sql
<li> SQL> exit
</ul>
<h3>Uninstalling</h3>
<ul>
<li> %bash sqlplus access_external@devdb/******
<li> SQL> @access-external-views-drop.sql
<li> SQL> exit
<li> %bash sqlplus healthsciences@devdb/******
<li> SQL> @access-materialized-views-drop.sql
<li> SQL> exit
</ul>
</td></tr></table>
</body>
</html>
