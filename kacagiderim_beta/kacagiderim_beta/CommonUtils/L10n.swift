//
//  L10n.swift
//  kacagiderim_beta
//
//  Created by Comodo on 17.07.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
enum L10n {
    /// You haven't register device yet. \nClick link in email first!
    static let apiEmptyDeviceId = L10n.tr("Localizable", "api_empty_device_id")
    /// Empty Username.
    static let apiEmptyUsername = L10n.tr("Localizable", "api_empty_username")
    /// Empty Password.
    static let apiEmptyPassword = L10n.tr("Localizable", "api_empty_password")
    /// Empty Result.
    static let apiEmptyResult = L10n.tr("Localizable", "api_empty_result")
    /// Empty UUID
    static let apiEmptyUuid = L10n.tr("Localizable", "api_empty_uuid")
    /// About
    static let avcTitleAbout = L10n.tr("Localizable", "avc_title_about")
    /// Can't login to Captive Portal
    static let avcTitleCantLoginCaptive = L10n.tr("Localizable", "avc_title_cant_login_captive")
    /// How to Enable/Disable
    static let avcTitleEnableDisable = L10n.tr("Localizable", "avc_title_enable_disable")
    /// FAQ
    static let avcTitleFaq = L10n.tr("Localizable", "avc_title_faq")
    /// Rate Us
    static let avcTitleRate = L10n.tr("Localizable", "avc_title_rate")
    /// How to Remove VPN
    static let avcTitleRemoveVpn = L10n.tr("Localizable", "avc_title_remove_vpn")
    /// Share
    static let avcTitleShare = L10n.tr("Localizable", "avc_title_share")
    /// What is Dome Shield
    static let avcTitleWhatIs = L10n.tr("Localizable", "avc_title_what_is")
    /// Other
    static let charOther = L10n.tr("Localizable", "char_other")
    /// Alerts
    static let ddvcAlertsOnline = L10n.tr("Localizable", "ddvc_alerts_online")
    /// Blocked Attacks
    static let ddvcBlockedAttacks = L10n.tr("Localizable", "ddvc_blocked_attacks")
    /// Blocked Sites
    static let ddvcBlockedSites = L10n.tr("Localizable", "ddvc_blocked_sites")
    /// Device Online
    static let ddvcDeviceOnline = L10n.tr("Localizable", "ddvc_device_online")
    /// Last Seen
    static let ddvcLastSeen = L10n.tr("Localizable", "ddvc_last_seen")
    /// Invalide email!
    static let lvcInvalideEmail = L10n.tr("Localizable", "lvc_invalide_email")
    /// Password lenght is wrong!
    static let lvcWrongPasswordLenght = L10n.tr("Localizable", "lvc_wrong_password_lenght")
    /// How To Disable The VPN
    static let mtvcTitleDisable = L10n.tr("Localizable", "mtvc_title_disable")
    /// How To Enable The VPN
    static let mtvcTitleEnable = L10n.tr("Localizable", "mtvc_title_enable")
    /// VPN Installation Guide
    static let mtvcTitleInstallation = L10n.tr("Localizable", "mtvc_title_installation")
    /// Removing the VPN
    static let mtvcTitleRemoving = L10n.tr("Localizable", "mtvc_title_removing")
    /// Share Feedback
    static let mtvcTitleShare = L10n.tr("Localizable", "mtvc_title_share")
    /// Sign Out
    static let mtvcTitleSignout = L10n.tr("Localizable", "mtvc_title_signout")
    /// Stuck at a WIFI Hotspot?
    static let mtvcTitleStuck = L10n.tr("Localizable", "mtvc_title_stuck")
    /// Loading...
    static let mvcButtonLoading = L10n.tr("Localizable", "mvc_button_loading")
    /// Tap to See Traffic Blocked
    static let mvcButtonSeeThreads = L10n.tr("Localizable", "mvc_button_see_threads")
    /// Start
    static let mvcButtonStart = L10n.tr("Localizable", "mvc_button_start")
    /// Stop
    static let mvcButtonStop = L10n.tr("Localizable", "mvc_button_stop")
    /// Connecting...
    static let mvcConnecting = L10n.tr("Localizable", "mvc_connecting")
    /// Tap to See \n Threats Blocked
    static let mvcInternetSecurityStateBlocked = L10n.tr("Localizable", "mvc_internet_security_state_blocked")
    /// Internet Security Disabled
    static let mvcInternetSecurityStateDisabled = L10n.tr("Localizable", "mvc_internet_security_state_disabled")
    /// Internet Security Enabled
    static let mvcInternetSecurityStateEnabled = L10n.tr("Localizable", "mvc_internet_security_state_enabled")
    /// No Internet connection
    static let mvcNoInternetConnection = L10n.tr("Localizable", "mvc_no_internet_connection")
    /// Open link from your email to setup connection!
    static let mvcSetupFromEmail = L10n.tr("Localizable", "mvc_setup_from_email")
    /// Connecting...
    static let mvcTapTitleConnection = L10n.tr("Localizable", "mvc_tap_title_connection")
    /// Please activate your Shield \n App by tapping Activate Button \n sent to your e-mail.
    static let mvcTapToActivate = L10n.tr("Localizable", "mvc_tap_to_activate")
    /// Please Activate Your cWatch\nOffice App by clicking Activate\nbutton sent to your email.
    static let mvcTapToActivateCwatch = L10n.tr("Localizable", "mvc_tap_to_activate_cwatch")
    /// Tap to enable Internet Security
    static let mvcTapToSecure = L10n.tr("Localizable", "mvc_tap_to_secure")
    /// Something went wrong!\nTry again later.
    static let mvcTimeOut = L10n.tr("Localizable", "mvc_time_out")
    /// VPN Profile Updated
    static let mvcUpdatedVpnProfile = L10n.tr("Localizable", "mvc_updated_vpn_profile")
    /// OK
    static let ok = L10n.tr("Localizable", "Ok")
    /// All devices
    static let rvcAllDevices = L10n.tr("Localizable", "rvc_all_devices")
    /// untitled
    static let rvcNoDeviceName = L10n.tr("Localizable", "rvc_no_device_name")
    /// App Data Protected
    static let rvcTitleAppDataProtected = L10n.tr("Localizable", "rvc_title_app_data_protected")
    /// Data Protected
    static let rvcTitleDataProtected = L10n.tr("Localizable", "rvc_title_data_protected")
    /// Last 24 Hours of Activity
    static let rvcTitleLastHours = L10n.tr("Localizable", "rvc_title_last_hours")
    /// Streaming Media Protection
    static let rvcTitleStreaming = L10n.tr("Localizable", "rvc_title_streaming")
    /// %@ MB Protected
    static func ryvcCountOfProtected(_ p1: String) -> String {
        return L10n.tr("Localizable", "ryvc_count_of_protected", p1)
    }
}
// swiftlint:enable explicit_type_interface identifier_name line_length nesting type_body_length type_name

extension L10n {
    fileprivate static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
        let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
        return String(format: format, locale: Locale.current, arguments: args)
    }
}

private final class BundleToken {}
