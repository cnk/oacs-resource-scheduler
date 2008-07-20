update acs_objects
set title = (select name
             from cr_items
             where item_id = object_id),
package_id = acs_object__package_id(content_item.get_root_folder(object_id))
where object_type = 'acs_message';

@@ ../acs-messaging-packages.sql
