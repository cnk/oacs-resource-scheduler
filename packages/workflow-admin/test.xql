<?xml version="1.0"?>
<queryset>
	
      <fullquery name="graph_filename_update_true">
                <querytext>
update pt_subjects
set    graph_update_p = 't'
where  subject_id = :subject_id and graph_update_p = 'f'
                </querytext>
      </fullquery>

</queryset>
