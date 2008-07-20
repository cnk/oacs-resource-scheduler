<!-- $Id: datetime-procs.adp,v 1.4 2003-09-22 19:44:28 lars Exp $ -->

<master src="master">

<property name="title">@title;noquote@</property>

<p>The following table offers examples of the various date and time
functions:</p>

<blockquote>
<table width="95%">

<tr bgcolor=#eeeeee align=left> <th>Procedure</th> <th>Result</th> </tr>

<multiple name="dt_examples">
    <tr align=left>
        <td><code>@dt_examples.procedure@</code></td>
        <td>@dt_examples.result@</td>
    </tr>
</multiple>

</table>
</blockquote>

<h4>Notes</h4>

<ol>

<li>Any timezone-specific information will be based on the
host configuration where the server is running.

<li>Without a supplied date or time argument, all procedures return
results based on the current server time.

<li>The format argument used by <code>dt_sysdate</code> and
<code>dt_systime</code> accepts any of the formatting codes supported
by the Tcl <code>clock format</code> procedure, which is used for the
underlying processing.  See current documentation at <a
href=http://www.scriptics.com/man/>http://www.scriptics.com/man/</a>. 

<li>All procedures that take date or time as an input argument are capable of 
accepting these inputs in any format capable of being parsed by <code>clock
scan</code>.  This includes virtually all ordinary date and time
formats, including am/pm and timezone qualifiers.

</ol>

