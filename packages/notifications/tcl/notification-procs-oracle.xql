<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="notification::delete.delete_notification">
        <querytext>
            declare begin
                notification.del(:notification_id);
            end;
        </querytext>
    </fullquery>

    <fullquery name="notification::mark_sent.insert_notification_user_map">
        <querytext>
            insert
            into notification_user_map
            (notification_id, user_id, sent_date)
            select :notification_id, :user_id, sysdate
            from dual where exists (select 1 from notifications
                                    where notification_id = :notification_id)
        </querytext>
    </fullquery>

    <fullquery name="notification::new.update_message">
        <querytext>
                update notifications
                set notif_html = empty_clob(),
                notif_text = empty_clob()
                where notification_id = :notification_id
                returning notif_html, notif_text into :1, :2
        </querytext>
    </fullquery>

</queryset>
