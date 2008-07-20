<master>
<property name="title" value="Recreating JCCC Views Post Import"></property>
<hr>
<h3>Recreating JCCC Views Post Import</h3>
<p>
<b>This script should be run after doing an import of the entire Healthsciences user from a dump file.</b>
<p>
<ul>
<li>sqlplus jccc_external/********
<li>@/web/ucla/packages/external-connections-jccc/sql/oracle/jccc-external-views-drop.sql
<li>exit;
</ul>

<ul>
<li>sqlplus healthsciences/********
<li>execute DBMS_REFRESH.destroy(name=>'jccc_refresh_group');
<li>@/web/ucla/packages/external-connections-jccc/sql/oracle/revoke-views.sql
<li><pre>
drop table jccc_ct_group_map_vw;
drop table jccc_clinical_trials_vw;
drop table jccc_events_group_map_vw;
drop table jccc_events_vw;
drop table jccc_personnel_language_map_vw;
drop table jccc_language_codes_vw;
drop table jccc_pub_person_ordering_vw;
drop table jccc_person_publication_map_vw;
drop table jccc_publications_vw;
drop table jccc_personnel_resumes_vw;
drop table jccc_addresses_vw;
drop table jccc_phones_vw;
drop table jccc_emails_vw;
drop table jccc_urls_vw;
drop table jccc_certifications_vw;
drop table jccc_research_interests_vw;
drop table jccc_group_personnel_map_vw;
drop table jccc_personnel_vw;
drop table jccc_groups_subset_vw;
drop table jccc_groups_nci_code_vw;
drop table jccc_groups_vw;
</pre>
</li>
<li>@/web/ucla/packages/external-connections-jccc/sql/oracle/jccc-materialized-views-create.sql
<li>exit;
</ul>

<ul>
<li>sqlplus jccc_external/********
<li>@/web/ucla/packages/external-connections-jccc/sql/oracle/jccc-external-views-create.sql
<li>exit;
</ul>

