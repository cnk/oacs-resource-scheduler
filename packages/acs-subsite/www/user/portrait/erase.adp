<master>
<property name="title">#acs-subsite.Erase_Portrait#</property>
<property name="context">@context;noquote@</property>

<if @admin_p@ eq 0>
  <p>#acs-subsite.lt_Sure_erase_your_por#</p>
</if>
<else>
  <p>#acs-subsite.lt_Sure_erase_user_por#</p>
</else>

<formtemplate id="portrait_erase"></formtemplate>
