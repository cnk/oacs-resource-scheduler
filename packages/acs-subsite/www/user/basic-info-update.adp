<master>
  <property name="title">@page_title@</property>
  <property name="context">@context;noquote@</property>

<h2>#acs-subsite.Basic_Information#</h2>

<if @message@ not nil>
  <div class="general-message">@message@</div>
</if>

<include src="@user_info_template@" user_id="@user_id@" return_url="@return_url;noquote@" &="__adp_properties" edit_p="@edit_p@" message="@message;noquote@">
