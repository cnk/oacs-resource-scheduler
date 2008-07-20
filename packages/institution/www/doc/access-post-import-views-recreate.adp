<master>
<property name="title" value="Recreating ACCESS Views Post Import"></property>
<hr>
<h3>Recreating ACCESS Views Post Import</h3>
<p>
<b>This script should be run after doing an import of the entire Healthsciences user from a dump file.</b>
<p>
<ul>
<li>sqlplus access_external/********
<li>@/web/ucla/packages/external-connections-access/sql/oracle/access-external-views-drop.sql
<li>exit;
</ul>

<ul>
<li>sqlplus healthsciences/********
<li>execute DBMS_REFRESH.destroy(name=>'axs_refresh_group');
<li>@/web/ucla/packages/external-connections-access/sql/oracle/revoke-views.sql
<li><pre>
drop table axs_personnel_language_map_vw;
drop table axs_language_codes_vw;
drop table axs_person_publication_map_vw;
drop table axs_publications_vw;
drop table axs_personnel_resumes_vw;
drop table axs_addresses_vw;
drop table axs_phones_vw;
drop table axs_emails_vw;
drop table axs_urls_vw;
drop table axs_certifications_vw;
drop table axs_research_interests_vw;
drop table axs_group_personnel_map_vw;
drop table axs_personnel_vw;
drop table axs_groups_vw;
</pre>
</li>
<li>@/web/ucla/packages/external-connections-access/sql/oracle/access-materialized-views-create.sql
<li>exit;
</ul>

<ul>
<li>sqlplus access_external/********
<li>@/web/ucla/packages/external-connections-access/sql/oracle/access-external-views-create.sql
<li>exit;
</ul>

<b>For the staging database, run the following: (ONLY FOR THE STAGING DB)</b>
<ul>
<li>sqlplus healthsciences/*********
<li>@/web/ucla/packages/external-connections-access/sql/oracle/grant-updates-spool.sql
<li>exit;
</ul>
