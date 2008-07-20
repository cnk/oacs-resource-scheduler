<?xml version="1.0"?>
<queryset>

  <fullquery name="email">
         <querytext>
                select email_upto, email_upto_type, email_period, email_day from ccal_profiles where profile_id = :profile_id and owner_id = :user_id
         </querytext>
  </fullquery>

</queryset>
