<?xml version="1.0"?>
<queryset>
        <fullquery name="select_policies">
             <querytext>
	      select policy_name, policy_id
	      from   crs_resv_resource_policies
	      where  resource_id = :resource_id and policy_id = :policy_id
	     </querytext>
        </fullquery>

        <fullquery name="select_associated_groups">
             <querytext>
	      select group_id
	      from   crs_resv_resource_pol_assns 
	      where   policy_id = :policy_id
	     </querytext>
        </fullquery>

	<fullquery name="select_groupes">
    	     <querytext>
	     select group_name, group_id
	     from   groups
	     </querytext>
        </fullquery>
</queryset>
