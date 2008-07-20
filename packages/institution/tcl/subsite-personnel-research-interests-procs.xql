<?xml version="1.0"?>
<queryset>
	<fullquery name="inst::subsite_personnel_research_interests::research_interest_exists_p.subsite_personnel_ri_exists_p">
		<querytext>
			select count(*)
			from   inst_subsite_pers_res_intrsts
			where  personnel_id = :personnel_id
			and    subsite_id   = :subsite_id
		</querytext>
	</fullquery>

	<fullquery name="inst::subsite_personnel_research_interests::get_personnel_research_interest_for_subsite_or_default.subsite_ri_get_ri">
		<querytext>
			select 	$ri_title_column,
				$ri_column
			from  	inst_subsite_pers_res_intrsts
			where 	personnel_id = :personnel_id
			and   	subsite_id   = :subsite_id
		</querytext>
	</fullquery>
	
	<fullquery name="inst::subsite_personnel_research_interests::personnel_research_interest_insert.ri_insert">
		<querytext>
			insert into inst_subsite_pers_res_intrsts (
			subsite_id,
			personnel_id,
			lay_title,
			lay_interest,
			technical_title,
			technical_interest)
			values (:subsite_id,
				:personnel_id,
				:lay_title,
				:lay_interest,
				:technical_title,
				:technical_interest)
		</querytext>
	</fullquery>

	<fullquery name="inst::subsite_personnel_research_interests::personnel_research_interest_update.ri_update">
		<querytext>
			update inst_subsite_pers_res_intrsts 
			set 	lay_title 	   = :lay_title,
				lay_interest 	   = :lay_interest,
				technical_title    = :technical_title,
				technical_interest = :technical_interest
			where   personnel_id       = :personnel_id
			and	subsite_id 	   = :subsite_id
		</querytext>
	</fullquery>

	<fullquery name="inst::subsite_personnel_research_interests::personnel_research_interest_delete.ri_delete">
		<querytext>	
			delete from inst_subsite_pers_res_intrsts where personnel_id = :personnel_id
		</querytext>
	</fullquery>
</queryset>
