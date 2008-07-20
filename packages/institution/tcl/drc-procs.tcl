# /packages/institution/tcl/drc-procs.tcl

ad_library {

    DRC Helper Procedures

    @author avni@ctrl.ucla.edu (AK)
    @creation-date 2006/09/13
    @cvs-id $Id: drc-procs.tcl,v 1.3 2006/09/20 08:44:03 avni Exp $

}

namespace eval inst::drc {}

ad_proc -private inst::drc::personnel_data_xml {
    {-employee_number:required}
} {
    Returns the personnel data (group_id, title) for the specified employee
    in XML format.

    <pre>
      <inst>
          <personnel_info>
              <personnel_id></personnel_id>
              <first_name></first_name>
              <last_name></last_name>
              <employee_number></employee_number>
              <membership_info>
                  <group>
                      <group_id></group_id>
                      <group_name></group_name>
                      <title_id></title_id>
                      <title></title>
                  </group>
                  ....
              </membership_info>
          </personnel_info>
      </inst>
    </pre>
} {
    set selection [db_0or1row get_employee_info {}]

    if {$selection} {
	set personnel_data_xml "
<inst>
    <personnel_info>
         <personnel_id>$personnel_id</personnel_id>
         <first_name>$first_names</first_name>
         <last_name>$last_name</last_name>
         <employee_number>$employee_number</employee_number>
         <membership_info>"

	db_foreach get_group_membership_info {} {
	    append personnel_data_xml "
		<group>
		    <group_id>$group_id</group_id>
		    <group_name>$group_name</group_name>
                    <title_id>$title_id</title_id>
		    <title>$title</title>
		</group>"
	}
	
	append personnel_data_xml "
          </membership_info>
    </personnel_info>
</inst>"

	return $personnel_data_xml

    } else {
	return "<error />"
    }

}

ad_proc -private inst::drc::personnel_login_data_xml {
    {-employee_number:required}
    {-email:required}
} {
    Returns the personnel login data for the specified employee
    in XML format.

    <pre>
      <inst>
          <personnel_login_info>
              <party_id></party_id>
              <person_id></person_id>
              <user_id></user_id>
              <personnel_id></personnel_id>
              <personnel_email></personnel_email>
              <en_party_id></en_party_id>
              <email_party_id></email_party_id>
              <first_name></first_name>
              <last_name></last_name>
          </personnel_login_info>
      </inst>
    </pre>
} {
    set selection [db_0or1row get_login_info {}]

    if {$selection} {
	set login_data_xml "
<inst>
    <personnel_login_info>
          <party_id>$party_id</party_id>
          <person_id>$person_id</person_id>
          <user_id>$user_id</user_id>
          <personnel_id>$personnel_id</personnel_id>
          <personnel_email>$personnel_email</personnel_email>
          <en_party_id>$en_party_id</en_party_id>
          <email_party_id>$email_party_id</email_party_id>
          <first_name>$first_name</first_name>
          <last_name>$last_name</last_name>
    </personnel_login_info>
</inst>"

	return $login_data_xml

    } else {
	return "<error />"
    }

}
