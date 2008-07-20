<?xml version="1.0"?>
<queryset>
	<fullquery name="jccc_info_select">
		<querytext>
    		select 	group_id,
			nci_code
    		from   	jccc_groups
    		where  	group_id = :jccc_group_id
		</querytext>
	</fullquery>

	<fullquery name="jccc_group_add">
		<querytext>
			insert into jccc_groups (
				group_id,
				nci_code
			) values (
				:group_id,
				:nci_code
			)
		</querytext>
	</fullquery>

	<fullquery name="jccc_group_edit">
		<querytext>
			update 	jccc_groups
			set	nci_code 		= :nci_code
			where   group_id 		= :group_id
		</querytext>
	</fullquery>
</queryset>
