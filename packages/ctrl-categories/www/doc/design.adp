<master>
<property name="title"> Categories - design doc </property>


<h1>Categories - design doc</h1>
<a href="/">Main Site</a> : Categories
<hr>

<h2> Categories 1.0 Design </h2>

<h3> I. Introduction </h3>

This is the design specifications for Categories 1.0. 


<h3> III.  Historical Considerations </h3>
N/A

<h3> IV.  Competetive Analysis </h3>
N/A

<h3> V.  Design Tradeoffs </h3>
N/A

<h3> VI. API </h3>
<table border=1>

<tr>
<td><b>Name</td>
<td><b> Switches </td>
<td><b>Description</td>
</tr>

<tr>
<td>
<b> category::new </b>
</td>

<td>
-parent_category_id (required)
-name (required)
-description (required)
-enabled_p (required)
-profiling_weight (required)
</td>
<td>
Adds a new category to the database 
</td>
</tr>


<tr>
<td>
<b>category::edit</b> 
</td>

<td>
-category_id (required)
-parent_category_id (required)
-name (required)
-description (required)
-enabled_p (required)
-profiling_weight (required)
</td>

<td>
Edit a category in the database 
</td>
</tr>

<tr>
<td>
<b>category::remove
</td>

<td> 
-category_id (required)
</td>

<td>
Removes a category along with all it's children 
</td>
</tr>
</table>


<h3> VII. Data Model Discussion </h3>

The data model consists of a single acs-objects.  The table associated with this object is called categories.  
Here's a table description:

<pre>
Name					   Null?    Type
 ----------------------------------------- -------- ----------------------------
 CATEGORY_ID				   NOT NULL NUMBER(38)
 PARENT_CATEGORY_ID				    NUMBER(38)
 NAME					   NOT NULL VARCHAR2(300)
 DESCRIPTION					    VARCHAR2(4000)
 ENABLED_P					    CHAR(1)
 PROFILING_WEIGHT				    NUMBER
</pre>

The data model is straightforward: All catogies are inserted into this table with a unique category_id represented by a sequence.  The parent_category_id column references the categories table itself; this provided the abilty to have subcategories.


<h3> VIII. User Interface </h3>
The user interface consists of a simple form that allows you to add/edit/delete categories.  

<h3> IX.  Config/Params </h3>
N/A

<h3> X. Future Improvements </h3>
Additions to the user interface that allow easy browsing of categories and it's subcategories.

<h3> XI. Authors </h3>
Jeff Wang

<h3> XII. Revision History </h3>
<table border =1>
<tr>
<td>
<b> Author
</td>
<td>
<b> Version Number
</td>
</tr>

<tr>
<td>
Jeff Wang
</td>
<td>
1.0
</td>
</tr>
</table>


<hr> 
<a href="mailto:admin@ctrl.ucla.edu">admin@ctrl.ucla.edu</a>

</body>
</html>
 
