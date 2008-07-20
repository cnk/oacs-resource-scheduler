<?xml version="1.0"?>
<queryset>
	<fullquery name="jccc_info_select">
		<querytext>
    		select 	personnel_id,
	   	       	nci_funding_p,
	   		expired_p,
	   		expired_comment,
	   		split_member_p,
           		core_p,
           		regular_p,
           		membership_status,
	   		notes
    		from   jccc_personnel
    		where  personnel_id = :jccc_personnel_id
		</querytext>
	</fullquery>

	<fullquery name="jccc_personnel_add">
		<querytext>
			insert into jccc_personnel (
				personnel_id,
				nci_funding_p,
				expired_p,
				expired_comment,
				split_member_p,
				core_p,
				regular_p,
				membership_status,
				notes
			) values (
				:personnel_id,
				:nci_funding_p,
				:expired_p,
				:expired_comment,
				:split_member_p,
				:core_p,
				:regular_p,
				:membership_status,
				:notes
			)
		</querytext>
	</fullquery>

	<fullquery name="jccc_personnel_edit">
		<querytext>
			update 	jccc_personnel 
			set	nci_funding_p 		= :nci_funding_p,
				expired_p 		= :expired_p,
				expired_comment 	= :expired_comment,
				split_member_p 		= :split_member_p,
				core_p 			= :core_p,
				regular_p 		= :regular_p,
				membership_status 	= :membership_status,
				notes			= :notes
			where   personnel_id 		= :personnel_id
		</querytext>
	</fullquery>
</queryset>
