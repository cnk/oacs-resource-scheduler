<master>
<property name="title">@title@</property>
<property name="context_bar">@context_bar@</property>
<link rel="stylesheet" href="../cnsi-forms.css">
<h2>@title@ To convert a User to a Personnel, click on the name of the user you wish to convert</h2>

<formtemplate id="user_search">
  <table width="645" border="0" cellspacing="4" cellpadding="2">
  <tr><td>Search for User (by partial or full first/last name): <formwidget id="user_name"> <formwidget id="search"></td></tr>
  </table>
</formtemplate>

<include src="user-results"
	sql_query=@sql_query@
	personnel_search_p=0
	first_number=@first_number@
	last_number=@last_number@
	nav_bar=@navigation_display@
	link=@link@
	title="Users">
<br><br>
[ <a href="user-ae"> Create a New User </a> ]
[ <a href="../">Institution Administration Index</a> ]
<br><br>
