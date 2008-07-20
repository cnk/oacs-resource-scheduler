--
-- Upgrade script
-- 
-- Adds a dynamic_p column to notification_requests
--
-- @author Lars Pind (lars@pinds.com)
-- @creation-date 2003-02-06
--


-- add the column
alter table notification_requests add (
  dynamic_p                         char(1)
                                    default 'f'
                                    constraint notif_request_dynamic_ch
                                    check (dynamic_p in ('t', 'f'))
);


-- Recreate the package

create or replace package notification_request
as
   function new (
      request_id                        in notification_requests.request_id%TYPE default null,
      object_type                       in acs_objects.object_type%TYPE default 'notification_request',
      type_id                           in notification_requests.type_id%TYPE,
      user_id                           in notification_requests.user_id%TYPE,
      object_id                         in notification_requests.object_id%TYPE,
      interval_id                       in notification_requests.interval_id%TYPE,
      delivery_method_id                in notification_requests.delivery_method_id%TYPE,
      format                            in notification_requests.format%TYPE,
      dynamic_p                         in notification_requests.dynamic_p%TYPE,
      creation_date                     in acs_objects.creation_date%TYPE default sysdate,
      creation_user                     in acs_objects.creation_user%TYPE,
      creation_ip                       in acs_objects.creation_ip%TYPE,
      context_id                        in acs_objects.context_id%TYPE default null
   ) return notification_requests.request_id%TYPE;

   procedure delete (
      request_id                        in notification_requests.request_id%TYPE default null
   );

   procedure delete_all (
      object_id                        in notification_requests.object_id%TYPE default null
   );
end notification_request;
/
show errors

create or replace package body notification_request
as
   function new (
      request_id                        in notification_requests.request_id%TYPE default null,
      object_type                       in acs_objects.object_type%TYPE default 'notification_request',
      type_id                           in notification_requests.type_id%TYPE,
      user_id                           in notification_requests.user_id%TYPE,
      object_id                         in notification_requests.object_id%TYPE,
      interval_id                       in notification_requests.interval_id%TYPE,
      delivery_method_id                in notification_requests.delivery_method_id%TYPE,
      format                            in notification_requests.format%TYPE,
      dynamic_p                         in notification_requests.dynamic_p%TYPE,
      creation_date                     in acs_objects.creation_date%TYPE default sysdate,
      creation_user                     in acs_objects.creation_user%TYPE,
      creation_ip                       in acs_objects.creation_ip%TYPE,
      context_id                        in acs_objects.context_id%TYPE default null
   ) return notification_requests.request_id%TYPE
   is
      v_request_id                      acs_objects.object_id%TYPE;
   begin
      v_request_id := acs_object.new (
                          object_id => request_id,
                          object_type => object_type,
                          creation_date => creation_date,
                          creation_user => creation_user,
                          creation_ip => creation_ip,
                          context_id => context_id
                      );

      insert into notification_requests
      (request_id, type_id, user_id, object_id, interval_id, delivery_method_id, format, dynamic_p) values
      (v_request_id, type_id, user_id, object_id, interval_id, delivery_method_id, format, dynamic_p);

      return v_request_id;                          
   end new;

   procedure delete (
      request_id                        in notification_requests.request_id%TYPE default null
   )
   is
   begin
      acs_object.delete(request_id);
   end delete;

   procedure delete_all (
      object_id                        in notification_requests.object_id%TYPE default null
   )
   is
      v_request                        notification_requests%ROWTYPE;
   begin
      for v_request in
      (select request_id from notification_requests where object_id= delete_all.object_id)
      LOOP    
              notification_request.delete(v_request.request_id);
      END LOOP;
   end delete_all;

end notification_request;
/
show errors


