<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="acs_mail_lite::send.create_queue_entry">
        <querytext>
            insert into acs_mail_lite_queue
                  (message_id,
                   creation_date,
                   locking_server,
                   to_addr,
                   cc_addr,
                   bcc_addr,
                   from_addr,
                   reply_to,
                   subject,
                   body,
                   package_id,
                   file_ids,
                   mime_type,
                   no_callback_p,
                   extraheaders,
                   use_sender_p     
                  )
            values
                  (acs_mail_lite_id_seq.nextval,
                   :creation_date,
                   :locking_server,
                   :to_addr,
                   :cc_addr,
                   :bcc_addr,
                   :from_addr,
                   :reply_to,
                   :subject,
                   :body,
                   :package_id,
                   :file_ids,
                   :mime_type,
                   decode(:no_callback_p,'1','t','f'),
                   :extraheaders,
                   decode(:use_sender_p,'1','t','f')
                  )
        </querytext>
    </fullquery>

   <fullquery name="acs_mail_lite::log_mail_sending.record_mail_sent">
     <querytext>

       update acs_mail_lite_mail_log
       set last_mail_date = sysdate
       where party_id = :user_id

     </querytext>
   </fullquery>

   <fullquery name="acs_mail_lite::log_mail_sending.insert_log_entry">
     <querytext>

       insert into acs_mail_lite_mail_log (party_id, last_mail_date)
       values (:user_id, sysdate)

     </querytext>
   </fullquery>

    <fullquery name="acs_mail_lite::sweeper.get_queued_messages">
        <querytext>
            select
                   message_id as id,
                   creation_date,
                   locking_server,
                   to_addr,
                   cc_addr,
                   bcc_addr,
                   from_addr,
                   reply_to,
                   subject,
                   body,
                   package_id,
                   file_ids,
                   mime_type,
                   decode(no_callback_p,'t',1,0) as no_callback_p,
                   extraheaders,
                   decode(use_sender_p,'t',1,0) as use_sender_p
            from acs_mail_lite_queue
            where locking_server = '' or locking_server is NULL
        </querytext>
    </fullquery>

</queryset>
