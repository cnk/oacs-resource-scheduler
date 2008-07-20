<master>
<property name="title" value="Installing/Uninstalling the JCCC External Package"></property>
<h2>Installing/Uninstalling the JCCC External Package</h2>
<hr>
<h3>Installing</h3>
<ul>
<li> %bash sqlplus /nolog
<li> SQL> connect / as sysdba;
<li> SQL> grant create any materialized view to healthsciences;
<li> SQL> exit
<li> %bash sqlplus healthsciences@devdb/******
<li> SQL> @jccc-materialized-views-create.sql
<li> SQL> exit
<li> %bash sqlplus jccc_external@devdb/******
<li> SQL> @jccc-external-views-create.sql
<li> SQL> exit
</ul>
<h3>Uninstalling</h3>
<ul>
<li> %bash sqlplus jccc_external@devdb/******
<li> SQL> @jccc-external-views-drop.sql
<li> SQL> exit
<li> %bash sqlplus healthsciences@devdb/******
<li> SQL> @jccc-materialized-views-drop.sql
<li> SQL> exit
</ul>

