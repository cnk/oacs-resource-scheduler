
ad_library {
    Tcl procs for managing privacy

    @author ben@openforce.net
    @creation-date 2000-12-02
    @cvs-id $Id: acs-private-data-procs.tcl,v 1.5 2004-02-26 15:28:54 jeffd Exp $
}

namespace eval acs_privacy {

    ad_proc -public privacy_control_enabled_p {} {
        Returns whether privacy control is turned on or not.
        This is provided in order to have complete backwards
        compatibility with past behaviors, where private information
        was in no way regulated.
    } {
        # If no parameter set, then we assume privacy control is DISABLED
        return [ad_parameter -package_id [ad_acs_kernel_id] PrivacyControlEnabledP 0]
    }

    ad_proc -public privacy_control_set {val} {
        set the privacy control
    } {
        ad_parameter -set $val -package_id [ad_acs_kernel_id] PrivacyControlEnabledP
    }

    ad_proc -public user_can_read_private_data_p {
        {-user_id ""}
        {-object_id:required}
    } {
        check if a user can access an object's private data
    } {
        if {[privacy_control_enabled_p]} {
            return [ad_permission_p -user_id $user_id $object_id read_private_data]
        } else {
            # backwards compatibility
            return 1
        }
    }

    ad_proc -public set_user_read_private_data {
        {-user_id:required}
        {-object_id:required}
        {-value:required}
    } {
        grant permission to access private data
    } {
        if { [template::util::is_true $value] } {
            ad_permission_grant $user_id $object_id read_private_data
        } else {
            ad_permission_revoke $user_id $object_id read_private_data
        }
    }
}
