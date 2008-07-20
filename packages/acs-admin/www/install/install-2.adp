<master>
  <property name="title">@page_title;noquote@</property>
  <property name="context">@context;noquote@</property>

<if @problems_p@ true>

  <p> We're sorry. Some packages which are required in order to
  install the packages you want could not be found. </p>

</if>
<else>
  <if @extras_p@ true >
    <p> The packages you want to install require some other
    packages. These have been added to the list, and are marked
    below. </p>
 </if>

  <p> This is the <if @install:rowcount@ eq 1>package</if><else>list of packages</else> we are going to install. </p>

  <p> Please click the link below to begin installation. </p>
</else>

<p><listtemplate name="install"></listtemplate></p>

<if @continue_url@ not nil>
  <p>
    <b>&raquo;</b> <a href="@continue_url@">Install above <if @install:rowcount@ eq 1>package</if><else>packages</else></a>
  </p>
</if>
<if @problems_p@ true>

  <p> Please hit the Back button in your browser and go back and remove the packages we cannot install.</p>

</if>
