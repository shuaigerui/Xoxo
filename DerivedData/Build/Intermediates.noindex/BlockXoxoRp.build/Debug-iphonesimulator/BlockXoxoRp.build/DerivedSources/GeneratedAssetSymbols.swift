import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
extension ColorResource {

}

// MARK: - Image Symbols -

@available(iOS 11.0, macOS 10.7, tvOS 11.0, *)
extension ImageResource {

    /// The "RB_block" asset catalog image resource.
    static let rbBlock = ImageResource(name: "RB_block", bundle: resourceBundle)

    /// The "RB_report" asset catalog image resource.
    static let rbReport = ImageResource(name: "RB_report", bundle: resourceBundle)

    /// The "avatar_01" asset catalog image resource.
    static let avatar01 = ImageResource(name: "avatar_01", bundle: resourceBundle)

    /// The "avatar_02" asset catalog image resource.
    static let avatar02 = ImageResource(name: "avatar_02", bundle: resourceBundle)

    /// The "avatar_03" asset catalog image resource.
    static let avatar03 = ImageResource(name: "avatar_03", bundle: resourceBundle)

    /// The "avatar_04" asset catalog image resource.
    static let avatar04 = ImageResource(name: "avatar_04", bundle: resourceBundle)

    /// The "avatar_05" asset catalog image resource.
    static let avatar05 = ImageResource(name: "avatar_05", bundle: resourceBundle)

    /// The "avatar_06" asset catalog image resource.
    static let avatar06 = ImageResource(name: "avatar_06", bundle: resourceBundle)

    /// The "avatar_07" asset catalog image resource.
    static let avatar07 = ImageResource(name: "avatar_07", bundle: resourceBundle)

    /// The "avatar_08" asset catalog image resource.
    static let avatar08 = ImageResource(name: "avatar_08", bundle: resourceBundle)

    /// The "avatar_09" asset catalog image resource.
    static let avatar09 = ImageResource(name: "avatar_09", bundle: resourceBundle)

    /// The "avatar_10" asset catalog image resource.
    static let avatar10 = ImageResource(name: "avatar_10", bundle: resourceBundle)

    /// The "black_del" asset catalog image resource.
    static let blackDel = ImageResource(name: "black_del", bundle: resourceBundle)

    /// The "chat_alert" asset catalog image resource.
    static let chatAlert = ImageResource(name: "chat_alert", bundle: resourceBundle)

    /// The "chat_send" asset catalog image resource.
    static let chatSend = ImageResource(name: "chat_send", bundle: resourceBundle)

    /// The "chat_video" asset catalog image resource.
    static let chatVideo = ImageResource(name: "chat_video", bundle: resourceBundle)

    /// The "common_back" asset catalog image resource.
    static let commonBack = ImageResource(name: "common_back", bundle: resourceBundle)

    /// The "common_bg" asset catalog image resource.
    static let commonBg = ImageResource(name: "common_bg", bundle: resourceBundle)

    /// The "common_empty" asset catalog image resource.
    static let commonEmpty = ImageResource(name: "common_empty", bundle: resourceBundle)

    /// The "community_alert" asset catalog image resource.
    static let communityAlert = ImageResource(name: "community_alert", bundle: resourceBundle)

    /// The "community_commit" asset catalog image resource.
    static let communityCommit = ImageResource(name: "community_commit", bundle: resourceBundle)

    /// The "community_like" asset catalog image resource.
    static let communityLike = ImageResource(name: "community_like", bundle: resourceBundle)

    /// The "community_video" asset catalog image resource.
    static let communityVideo = ImageResource(name: "community_video", bundle: resourceBundle)

    /// The "discover_like" asset catalog image resource.
    static let discoverLike = ImageResource(name: "discover_like", bundle: resourceBundle)

    /// The "discover_liked" asset catalog image resource.
    static let discoverLiked = ImageResource(name: "discover_liked", bundle: resourceBundle)

    /// The "edit_save" asset catalog image resource.
    static let editSave = ImageResource(name: "edit_save", bundle: resourceBundle)

    /// The "guide01_bg" asset catalog image resource.
    static let guide01Bg = ImageResource(name: "guide01_bg", bundle: resourceBundle)

    /// The "guide01_next" asset catalog image resource.
    static let guide01Next = ImageResource(name: "guide01_next", bundle: resourceBundle)

    /// The "guide01_page" asset catalog image resource.
    static let guide01Page = ImageResource(name: "guide01_page", bundle: resourceBundle)

    /// The "guide02_bg" asset catalog image resource.
    static let guide02Bg = ImageResource(name: "guide02_bg", bundle: resourceBundle)

    /// The "guide02_page" asset catalog image resource.
    static let guide02Page = ImageResource(name: "guide02_page", bundle: resourceBundle)

    /// The "guide03_bg" asset catalog image resource.
    static let guide03Bg = ImageResource(name: "guide03_bg", bundle: resourceBundle)

    /// The "guide03_page" asset catalog image resource.
    static let guide03Page = ImageResource(name: "guide03_page", bundle: resourceBundle)

    /// The "home_add" asset catalog image resource.
    static let homeAdd = ImageResource(name: "home_add", bundle: resourceBundle)

    /// The "home_commit" asset catalog image resource.
    static let homeCommit = ImageResource(name: "home_commit", bundle: resourceBundle)

    /// The "home_like" asset catalog image resource.
    static let homeLike = ImageResource(name: "home_like", bundle: resourceBundle)

    /// The "home_liked" asset catalog image resource.
    static let homeLiked = ImageResource(name: "home_liked", bundle: resourceBundle)

    /// The "home_msg" asset catalog image resource.
    static let homeMsg = ImageResource(name: "home_msg", bundle: resourceBundle)

    /// The "info_camera" asset catalog image resource.
    static let infoCamera = ImageResource(name: "info_camera", bundle: resourceBundle)

    /// The "info_continue" asset catalog image resource.
    static let infoContinue = ImageResource(name: "info_continue", bundle: resourceBundle)

    /// The "login_button" asset catalog image resource.
    static let loginButton = ImageResource(name: "login_button", bundle: resourceBundle)

    /// The "login_show" asset catalog image resource.
    static let loginShow = ImageResource(name: "login_show", bundle: resourceBundle)

    /// The "login_signup" asset catalog image resource.
    static let loginSignup = ImageResource(name: "login_signup", bundle: resourceBundle)

    /// The "post_1" asset catalog image resource.
    static let post1 = ImageResource(name: "post_1", bundle: resourceBundle)

    /// The "post_10" asset catalog image resource.
    static let post10 = ImageResource(name: "post_10", bundle: resourceBundle)

    /// The "post_11" asset catalog image resource.
    static let post11 = ImageResource(name: "post_11", bundle: resourceBundle)

    /// The "post_12" asset catalog image resource.
    static let post12 = ImageResource(name: "post_12", bundle: resourceBundle)

    /// The "post_13" asset catalog image resource.
    static let post13 = ImageResource(name: "post_13", bundle: resourceBundle)

    /// The "post_14" asset catalog image resource.
    static let post14 = ImageResource(name: "post_14", bundle: resourceBundle)

    /// The "post_15" asset catalog image resource.
    static let post15 = ImageResource(name: "post_15", bundle: resourceBundle)

    /// The "post_16" asset catalog image resource.
    static let post16 = ImageResource(name: "post_16", bundle: resourceBundle)

    /// The "post_2" asset catalog image resource.
    static let post2 = ImageResource(name: "post_2", bundle: resourceBundle)

    /// The "post_3" asset catalog image resource.
    static let post3 = ImageResource(name: "post_3", bundle: resourceBundle)

    /// The "post_4" asset catalog image resource.
    static let post4 = ImageResource(name: "post_4", bundle: resourceBundle)

    /// The "post_5" asset catalog image resource.
    static let post5 = ImageResource(name: "post_5", bundle: resourceBundle)

    /// The "post_6" asset catalog image resource.
    static let post6 = ImageResource(name: "post_6", bundle: resourceBundle)

    /// The "post_7" asset catalog image resource.
    static let post7 = ImageResource(name: "post_7", bundle: resourceBundle)

    /// The "post_8" asset catalog image resource.
    static let post8 = ImageResource(name: "post_8", bundle: resourceBundle)

    /// The "post_9" asset catalog image resource.
    static let post9 = ImageResource(name: "post_9", bundle: resourceBundle)

    /// The "post_button" asset catalog image resource.
    static let postButton = ImageResource(name: "post_button", bundle: resourceBundle)

    /// The "post_camera" asset catalog image resource.
    static let postCamera = ImageResource(name: "post_camera", bundle: resourceBundle)

    /// The "post_coin" asset catalog image resource.
    static let postCoin = ImageResource(name: "post_coin", bundle: resourceBundle)

    /// The "profile_coin" asset catalog image resource.
    static let profileCoin = ImageResource(name: "profile_coin", bundle: resourceBundle)

    /// The "profile_coinBg" asset catalog image resource.
    static let profileCoinBg = ImageResource(name: "profile_coinBg", bundle: resourceBundle)

    /// The "profile_edit" asset catalog image resource.
    static let profileEdit = ImageResource(name: "profile_edit", bundle: resourceBundle)

    /// The "profile_next" asset catalog image resource.
    static let profileNext = ImageResource(name: "profile_next", bundle: resourceBundle)

    /// The "profile_setting" asset catalog image resource.
    static let profileSetting = ImageResource(name: "profile_setting", bundle: resourceBundle)

    /// The "setting_back" asset catalog image resource.
    static let settingBack = ImageResource(name: "setting_back", bundle: resourceBundle)

    /// The "signup_button" asset catalog image resource.
    static let signupButton = ImageResource(name: "signup_button", bundle: resourceBundle)

    /// The "signup_login" asset catalog image resource.
    static let signupLogin = ImageResource(name: "signup_login", bundle: resourceBundle)

    /// The "signup_show" asset catalog image resource.
    static let signupShow = ImageResource(name: "signup_show", bundle: resourceBundle)

    /// The "tab_discover" asset catalog image resource.
    static let tabDiscover = ImageResource(name: "tab_discover", bundle: resourceBundle)

    /// The "tab_discover_sel" asset catalog image resource.
    static let tabDiscoverSel = ImageResource(name: "tab_discover_sel", bundle: resourceBundle)

    /// The "tab_home" asset catalog image resource.
    static let tabHome = ImageResource(name: "tab_home", bundle: resourceBundle)

    /// The "tab_home_sel" asset catalog image resource.
    static let tabHomeSel = ImageResource(name: "tab_home_sel", bundle: resourceBundle)

    /// The "tab_message" asset catalog image resource.
    static let tabMessage = ImageResource(name: "tab_message", bundle: resourceBundle)

    /// The "tab_message_sel" asset catalog image resource.
    static let tabMessageSel = ImageResource(name: "tab_message_sel", bundle: resourceBundle)

    /// The "tab_profile" asset catalog image resource.
    static let tabProfile = ImageResource(name: "tab_profile", bundle: resourceBundle)

    /// The "tab_profile_sel" asset catalog image resource.
    static let tabProfileSel = ImageResource(name: "tab_profile_sel", bundle: resourceBundle)

    /// The "user_chat" asset catalog image resource.
    static let userChat = ImageResource(name: "user_chat", bundle: resourceBundle)

    /// The "user_follow" asset catalog image resource.
    static let userFollow = ImageResource(name: "user_follow", bundle: resourceBundle)

    /// The "user_followed" asset catalog image resource.
    static let userFollowed = ImageResource(name: "user_followed", bundle: resourceBundle)

    /// The "user_video" asset catalog image resource.
    static let userVideo = ImageResource(name: "user_video", bundle: resourceBundle)

    /// The "video_mic" asset catalog image resource.
    static let videoMic = ImageResource(name: "video_mic", bundle: resourceBundle)

    /// The "video_mic_off" asset catalog image resource.
    static let videoMicOff = ImageResource(name: "video_mic_off", bundle: resourceBundle)

    /// The "video_off" asset catalog image resource.
    static let videoOff = ImageResource(name: "video_off", bundle: resourceBundle)

    /// The "video_voice" asset catalog image resource.
    static let videoVoice = ImageResource(name: "video_voice", bundle: resourceBundle)

    /// The "video_voice_off" asset catalog image resource.
    static let videoVoiceOff = ImageResource(name: "video_voice_off", bundle: resourceBundle)

    /// The "wallet_coin" asset catalog image resource.
    static let walletCoin = ImageResource(name: "wallet_coin", bundle: resourceBundle)

    /// The "welcome_bg" asset catalog image resource.
    static let welcomeBg = ImageResource(name: "welcome_bg", bundle: resourceBundle)

    /// The "welcome_start" asset catalog image resource.
    static let welcomeStart = ImageResource(name: "welcome_start", bundle: resourceBundle)

}

// MARK: - Color Symbol Extensions -

#if canImport(AppKit)
@available(macOS 10.13, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

}
#endif

// MARK: - Image Symbol Extensions -

#if canImport(AppKit)
@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    /// The "RB_block" asset catalog image.
    static var rbBlock: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .rbBlock)
#else
        .init()
#endif
    }

    /// The "RB_report" asset catalog image.
    static var rbReport: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .rbReport)
#else
        .init()
#endif
    }

    /// The "avatar_01" asset catalog image.
    static var avatar01: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .avatar01)
#else
        .init()
#endif
    }

    /// The "avatar_02" asset catalog image.
    static var avatar02: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .avatar02)
#else
        .init()
#endif
    }

    /// The "avatar_03" asset catalog image.
    static var avatar03: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .avatar03)
#else
        .init()
#endif
    }

    /// The "avatar_04" asset catalog image.
    static var avatar04: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .avatar04)
#else
        .init()
#endif
    }

    /// The "avatar_05" asset catalog image.
    static var avatar05: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .avatar05)
#else
        .init()
#endif
    }

    /// The "avatar_06" asset catalog image.
    static var avatar06: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .avatar06)
#else
        .init()
#endif
    }

    /// The "avatar_07" asset catalog image.
    static var avatar07: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .avatar07)
#else
        .init()
#endif
    }

    /// The "avatar_08" asset catalog image.
    static var avatar08: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .avatar08)
#else
        .init()
#endif
    }

    /// The "avatar_09" asset catalog image.
    static var avatar09: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .avatar09)
#else
        .init()
#endif
    }

    /// The "avatar_10" asset catalog image.
    static var avatar10: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .avatar10)
#else
        .init()
#endif
    }

    /// The "black_del" asset catalog image.
    static var blackDel: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .blackDel)
#else
        .init()
#endif
    }

    /// The "chat_alert" asset catalog image.
    static var chatAlert: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .chatAlert)
#else
        .init()
#endif
    }

    /// The "chat_send" asset catalog image.
    static var chatSend: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .chatSend)
#else
        .init()
#endif
    }

    /// The "chat_video" asset catalog image.
    static var chatVideo: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .chatVideo)
#else
        .init()
#endif
    }

    /// The "common_back" asset catalog image.
    static var commonBack: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .commonBack)
#else
        .init()
#endif
    }

    /// The "common_bg" asset catalog image.
    static var commonBg: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .commonBg)
#else
        .init()
#endif
    }

    /// The "common_empty" asset catalog image.
    static var commonEmpty: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .commonEmpty)
#else
        .init()
#endif
    }

    /// The "community_alert" asset catalog image.
    static var communityAlert: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .communityAlert)
#else
        .init()
#endif
    }

    /// The "community_commit" asset catalog image.
    static var communityCommit: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .communityCommit)
#else
        .init()
#endif
    }

    /// The "community_like" asset catalog image.
    static var communityLike: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .communityLike)
#else
        .init()
#endif
    }

    /// The "community_video" asset catalog image.
    static var communityVideo: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .communityVideo)
#else
        .init()
#endif
    }

    /// The "discover_like" asset catalog image.
    static var discoverLike: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .discoverLike)
#else
        .init()
#endif
    }

    /// The "discover_liked" asset catalog image.
    static var discoverLiked: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .discoverLiked)
#else
        .init()
#endif
    }

    /// The "edit_save" asset catalog image.
    static var editSave: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .editSave)
#else
        .init()
#endif
    }

    /// The "guide01_bg" asset catalog image.
    static var guide01Bg: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .guide01Bg)
#else
        .init()
#endif
    }

    /// The "guide01_next" asset catalog image.
    static var guide01Next: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .guide01Next)
#else
        .init()
#endif
    }

    /// The "guide01_page" asset catalog image.
    static var guide01Page: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .guide01Page)
#else
        .init()
#endif
    }

    /// The "guide02_bg" asset catalog image.
    static var guide02Bg: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .guide02Bg)
#else
        .init()
#endif
    }

    /// The "guide02_page" asset catalog image.
    static var guide02Page: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .guide02Page)
#else
        .init()
#endif
    }

    /// The "guide03_bg" asset catalog image.
    static var guide03Bg: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .guide03Bg)
#else
        .init()
#endif
    }

    /// The "guide03_page" asset catalog image.
    static var guide03Page: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .guide03Page)
#else
        .init()
#endif
    }

    /// The "home_add" asset catalog image.
    static var homeAdd: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .homeAdd)
#else
        .init()
#endif
    }

    /// The "home_commit" asset catalog image.
    static var homeCommit: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .homeCommit)
#else
        .init()
#endif
    }

    /// The "home_like" asset catalog image.
    static var homeLike: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .homeLike)
#else
        .init()
#endif
    }

    /// The "home_liked" asset catalog image.
    static var homeLiked: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .homeLiked)
#else
        .init()
#endif
    }

    /// The "home_msg" asset catalog image.
    static var homeMsg: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .homeMsg)
#else
        .init()
#endif
    }

    /// The "info_camera" asset catalog image.
    static var infoCamera: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .infoCamera)
#else
        .init()
#endif
    }

    /// The "info_continue" asset catalog image.
    static var infoContinue: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .infoContinue)
#else
        .init()
#endif
    }

    /// The "login_button" asset catalog image.
    static var loginButton: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .loginButton)
#else
        .init()
#endif
    }

    /// The "login_show" asset catalog image.
    static var loginShow: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .loginShow)
#else
        .init()
#endif
    }

    /// The "login_signup" asset catalog image.
    static var loginSignup: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .loginSignup)
#else
        .init()
#endif
    }

    /// The "post_1" asset catalog image.
    static var post1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .post1)
#else
        .init()
#endif
    }

    /// The "post_10" asset catalog image.
    static var post10: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .post10)
#else
        .init()
#endif
    }

    /// The "post_11" asset catalog image.
    static var post11: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .post11)
#else
        .init()
#endif
    }

    /// The "post_12" asset catalog image.
    static var post12: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .post12)
#else
        .init()
#endif
    }

    /// The "post_13" asset catalog image.
    static var post13: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .post13)
#else
        .init()
#endif
    }

    /// The "post_14" asset catalog image.
    static var post14: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .post14)
#else
        .init()
#endif
    }

    /// The "post_15" asset catalog image.
    static var post15: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .post15)
#else
        .init()
#endif
    }

    /// The "post_16" asset catalog image.
    static var post16: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .post16)
#else
        .init()
#endif
    }

    /// The "post_2" asset catalog image.
    static var post2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .post2)
#else
        .init()
#endif
    }

    /// The "post_3" asset catalog image.
    static var post3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .post3)
#else
        .init()
#endif
    }

    /// The "post_4" asset catalog image.
    static var post4: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .post4)
#else
        .init()
#endif
    }

    /// The "post_5" asset catalog image.
    static var post5: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .post5)
#else
        .init()
#endif
    }

    /// The "post_6" asset catalog image.
    static var post6: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .post6)
#else
        .init()
#endif
    }

    /// The "post_7" asset catalog image.
    static var post7: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .post7)
#else
        .init()
#endif
    }

    /// The "post_8" asset catalog image.
    static var post8: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .post8)
#else
        .init()
#endif
    }

    /// The "post_9" asset catalog image.
    static var post9: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .post9)
#else
        .init()
#endif
    }

    /// The "post_button" asset catalog image.
    static var postButton: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .postButton)
#else
        .init()
#endif
    }

    /// The "post_camera" asset catalog image.
    static var postCamera: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .postCamera)
#else
        .init()
#endif
    }

    /// The "post_coin" asset catalog image.
    static var postCoin: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .postCoin)
#else
        .init()
#endif
    }

    /// The "profile_coin" asset catalog image.
    static var profileCoin: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .profileCoin)
#else
        .init()
#endif
    }

    /// The "profile_coinBg" asset catalog image.
    static var profileCoinBg: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .profileCoinBg)
#else
        .init()
#endif
    }

    /// The "profile_edit" asset catalog image.
    static var profileEdit: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .profileEdit)
#else
        .init()
#endif
    }

    /// The "profile_next" asset catalog image.
    static var profileNext: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .profileNext)
#else
        .init()
#endif
    }

    /// The "profile_setting" asset catalog image.
    static var profileSetting: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .profileSetting)
#else
        .init()
#endif
    }

    /// The "setting_back" asset catalog image.
    static var settingBack: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .settingBack)
#else
        .init()
#endif
    }

    /// The "signup_button" asset catalog image.
    static var signupButton: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .signupButton)
#else
        .init()
#endif
    }

    /// The "signup_login" asset catalog image.
    static var signupLogin: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .signupLogin)
#else
        .init()
#endif
    }

    /// The "signup_show" asset catalog image.
    static var signupShow: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .signupShow)
#else
        .init()
#endif
    }

    /// The "tab_discover" asset catalog image.
    static var tabDiscover: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .tabDiscover)
#else
        .init()
#endif
    }

    /// The "tab_discover_sel" asset catalog image.
    static var tabDiscoverSel: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .tabDiscoverSel)
#else
        .init()
#endif
    }

    /// The "tab_home" asset catalog image.
    static var tabHome: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .tabHome)
#else
        .init()
#endif
    }

    /// The "tab_home_sel" asset catalog image.
    static var tabHomeSel: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .tabHomeSel)
#else
        .init()
#endif
    }

    /// The "tab_message" asset catalog image.
    static var tabMessage: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .tabMessage)
#else
        .init()
#endif
    }

    /// The "tab_message_sel" asset catalog image.
    static var tabMessageSel: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .tabMessageSel)
#else
        .init()
#endif
    }

    /// The "tab_profile" asset catalog image.
    static var tabProfile: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .tabProfile)
#else
        .init()
#endif
    }

    /// The "tab_profile_sel" asset catalog image.
    static var tabProfileSel: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .tabProfileSel)
#else
        .init()
#endif
    }

    /// The "user_chat" asset catalog image.
    static var userChat: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .userChat)
#else
        .init()
#endif
    }

    /// The "user_follow" asset catalog image.
    static var userFollow: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .userFollow)
#else
        .init()
#endif
    }

    /// The "user_followed" asset catalog image.
    static var userFollowed: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .userFollowed)
#else
        .init()
#endif
    }

    /// The "user_video" asset catalog image.
    static var userVideo: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .userVideo)
#else
        .init()
#endif
    }

    /// The "video_mic" asset catalog image.
    static var videoMic: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .videoMic)
#else
        .init()
#endif
    }

    /// The "video_mic_off" asset catalog image.
    static var videoMicOff: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .videoMicOff)
#else
        .init()
#endif
    }

    /// The "video_off" asset catalog image.
    static var videoOff: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .videoOff)
#else
        .init()
#endif
    }

    /// The "video_voice" asset catalog image.
    static var videoVoice: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .videoVoice)
#else
        .init()
#endif
    }

    /// The "video_voice_off" asset catalog image.
    static var videoVoiceOff: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .videoVoiceOff)
#else
        .init()
#endif
    }

    /// The "wallet_coin" asset catalog image.
    static var walletCoin: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .walletCoin)
#else
        .init()
#endif
    }

    /// The "welcome_bg" asset catalog image.
    static var welcomeBg: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .welcomeBg)
#else
        .init()
#endif
    }

    /// The "welcome_start" asset catalog image.
    static var welcomeStart: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .welcomeStart)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// The "RB_block" asset catalog image.
    static var rbBlock: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .rbBlock)
#else
        .init()
#endif
    }

    /// The "RB_report" asset catalog image.
    static var rbReport: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .rbReport)
#else
        .init()
#endif
    }

    /// The "avatar_01" asset catalog image.
    static var avatar01: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .avatar01)
#else
        .init()
#endif
    }

    /// The "avatar_02" asset catalog image.
    static var avatar02: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .avatar02)
#else
        .init()
#endif
    }

    /// The "avatar_03" asset catalog image.
    static var avatar03: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .avatar03)
#else
        .init()
#endif
    }

    /// The "avatar_04" asset catalog image.
    static var avatar04: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .avatar04)
#else
        .init()
#endif
    }

    /// The "avatar_05" asset catalog image.
    static var avatar05: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .avatar05)
#else
        .init()
#endif
    }

    /// The "avatar_06" asset catalog image.
    static var avatar06: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .avatar06)
#else
        .init()
#endif
    }

    /// The "avatar_07" asset catalog image.
    static var avatar07: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .avatar07)
#else
        .init()
#endif
    }

    /// The "avatar_08" asset catalog image.
    static var avatar08: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .avatar08)
#else
        .init()
#endif
    }

    /// The "avatar_09" asset catalog image.
    static var avatar09: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .avatar09)
#else
        .init()
#endif
    }

    /// The "avatar_10" asset catalog image.
    static var avatar10: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .avatar10)
#else
        .init()
#endif
    }

    /// The "black_del" asset catalog image.
    static var blackDel: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .blackDel)
#else
        .init()
#endif
    }

    /// The "chat_alert" asset catalog image.
    static var chatAlert: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .chatAlert)
#else
        .init()
#endif
    }

    /// The "chat_send" asset catalog image.
    static var chatSend: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .chatSend)
#else
        .init()
#endif
    }

    /// The "chat_video" asset catalog image.
    static var chatVideo: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .chatVideo)
#else
        .init()
#endif
    }

    /// The "common_back" asset catalog image.
    static var commonBack: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .commonBack)
#else
        .init()
#endif
    }

    /// The "common_bg" asset catalog image.
    static var commonBg: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .commonBg)
#else
        .init()
#endif
    }

    /// The "common_empty" asset catalog image.
    static var commonEmpty: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .commonEmpty)
#else
        .init()
#endif
    }

    /// The "community_alert" asset catalog image.
    static var communityAlert: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .communityAlert)
#else
        .init()
#endif
    }

    /// The "community_commit" asset catalog image.
    static var communityCommit: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .communityCommit)
#else
        .init()
#endif
    }

    /// The "community_like" asset catalog image.
    static var communityLike: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .communityLike)
#else
        .init()
#endif
    }

    /// The "community_video" asset catalog image.
    static var communityVideo: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .communityVideo)
#else
        .init()
#endif
    }

    /// The "discover_like" asset catalog image.
    static var discoverLike: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .discoverLike)
#else
        .init()
#endif
    }

    /// The "discover_liked" asset catalog image.
    static var discoverLiked: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .discoverLiked)
#else
        .init()
#endif
    }

    /// The "edit_save" asset catalog image.
    static var editSave: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .editSave)
#else
        .init()
#endif
    }

    /// The "guide01_bg" asset catalog image.
    static var guide01Bg: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .guide01Bg)
#else
        .init()
#endif
    }

    /// The "guide01_next" asset catalog image.
    static var guide01Next: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .guide01Next)
#else
        .init()
#endif
    }

    /// The "guide01_page" asset catalog image.
    static var guide01Page: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .guide01Page)
#else
        .init()
#endif
    }

    /// The "guide02_bg" asset catalog image.
    static var guide02Bg: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .guide02Bg)
#else
        .init()
#endif
    }

    /// The "guide02_page" asset catalog image.
    static var guide02Page: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .guide02Page)
#else
        .init()
#endif
    }

    /// The "guide03_bg" asset catalog image.
    static var guide03Bg: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .guide03Bg)
#else
        .init()
#endif
    }

    /// The "guide03_page" asset catalog image.
    static var guide03Page: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .guide03Page)
#else
        .init()
#endif
    }

    /// The "home_add" asset catalog image.
    static var homeAdd: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .homeAdd)
#else
        .init()
#endif
    }

    /// The "home_commit" asset catalog image.
    static var homeCommit: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .homeCommit)
#else
        .init()
#endif
    }

    /// The "home_like" asset catalog image.
    static var homeLike: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .homeLike)
#else
        .init()
#endif
    }

    /// The "home_liked" asset catalog image.
    static var homeLiked: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .homeLiked)
#else
        .init()
#endif
    }

    /// The "home_msg" asset catalog image.
    static var homeMsg: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .homeMsg)
#else
        .init()
#endif
    }

    /// The "info_camera" asset catalog image.
    static var infoCamera: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .infoCamera)
#else
        .init()
#endif
    }

    /// The "info_continue" asset catalog image.
    static var infoContinue: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .infoContinue)
#else
        .init()
#endif
    }

    /// The "login_button" asset catalog image.
    static var loginButton: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .loginButton)
#else
        .init()
#endif
    }

    /// The "login_show" asset catalog image.
    static var loginShow: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .loginShow)
#else
        .init()
#endif
    }

    /// The "login_signup" asset catalog image.
    static var loginSignup: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .loginSignup)
#else
        .init()
#endif
    }

    /// The "post_1" asset catalog image.
    static var post1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .post1)
#else
        .init()
#endif
    }

    /// The "post_10" asset catalog image.
    static var post10: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .post10)
#else
        .init()
#endif
    }

    /// The "post_11" asset catalog image.
    static var post11: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .post11)
#else
        .init()
#endif
    }

    /// The "post_12" asset catalog image.
    static var post12: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .post12)
#else
        .init()
#endif
    }

    /// The "post_13" asset catalog image.
    static var post13: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .post13)
#else
        .init()
#endif
    }

    /// The "post_14" asset catalog image.
    static var post14: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .post14)
#else
        .init()
#endif
    }

    /// The "post_15" asset catalog image.
    static var post15: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .post15)
#else
        .init()
#endif
    }

    /// The "post_16" asset catalog image.
    static var post16: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .post16)
#else
        .init()
#endif
    }

    /// The "post_2" asset catalog image.
    static var post2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .post2)
#else
        .init()
#endif
    }

    /// The "post_3" asset catalog image.
    static var post3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .post3)
#else
        .init()
#endif
    }

    /// The "post_4" asset catalog image.
    static var post4: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .post4)
#else
        .init()
#endif
    }

    /// The "post_5" asset catalog image.
    static var post5: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .post5)
#else
        .init()
#endif
    }

    /// The "post_6" asset catalog image.
    static var post6: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .post6)
#else
        .init()
#endif
    }

    /// The "post_7" asset catalog image.
    static var post7: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .post7)
#else
        .init()
#endif
    }

    /// The "post_8" asset catalog image.
    static var post8: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .post8)
#else
        .init()
#endif
    }

    /// The "post_9" asset catalog image.
    static var post9: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .post9)
#else
        .init()
#endif
    }

    /// The "post_button" asset catalog image.
    static var postButton: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .postButton)
#else
        .init()
#endif
    }

    /// The "post_camera" asset catalog image.
    static var postCamera: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .postCamera)
#else
        .init()
#endif
    }

    /// The "post_coin" asset catalog image.
    static var postCoin: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .postCoin)
#else
        .init()
#endif
    }

    /// The "profile_coin" asset catalog image.
    static var profileCoin: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .profileCoin)
#else
        .init()
#endif
    }

    /// The "profile_coinBg" asset catalog image.
    static var profileCoinBg: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .profileCoinBg)
#else
        .init()
#endif
    }

    /// The "profile_edit" asset catalog image.
    static var profileEdit: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .profileEdit)
#else
        .init()
#endif
    }

    /// The "profile_next" asset catalog image.
    static var profileNext: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .profileNext)
#else
        .init()
#endif
    }

    /// The "profile_setting" asset catalog image.
    static var profileSetting: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .profileSetting)
#else
        .init()
#endif
    }

    /// The "setting_back" asset catalog image.
    static var settingBack: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .settingBack)
#else
        .init()
#endif
    }

    /// The "signup_button" asset catalog image.
    static var signupButton: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .signupButton)
#else
        .init()
#endif
    }

    /// The "signup_login" asset catalog image.
    static var signupLogin: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .signupLogin)
#else
        .init()
#endif
    }

    /// The "signup_show" asset catalog image.
    static var signupShow: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .signupShow)
#else
        .init()
#endif
    }

    /// The "tab_discover" asset catalog image.
    static var tabDiscover: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .tabDiscover)
#else
        .init()
#endif
    }

    /// The "tab_discover_sel" asset catalog image.
    static var tabDiscoverSel: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .tabDiscoverSel)
#else
        .init()
#endif
    }

    /// The "tab_home" asset catalog image.
    static var tabHome: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .tabHome)
#else
        .init()
#endif
    }

    /// The "tab_home_sel" asset catalog image.
    static var tabHomeSel: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .tabHomeSel)
#else
        .init()
#endif
    }

    /// The "tab_message" asset catalog image.
    static var tabMessage: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .tabMessage)
#else
        .init()
#endif
    }

    /// The "tab_message_sel" asset catalog image.
    static var tabMessageSel: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .tabMessageSel)
#else
        .init()
#endif
    }

    /// The "tab_profile" asset catalog image.
    static var tabProfile: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .tabProfile)
#else
        .init()
#endif
    }

    /// The "tab_profile_sel" asset catalog image.
    static var tabProfileSel: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .tabProfileSel)
#else
        .init()
#endif
    }

    /// The "user_chat" asset catalog image.
    static var userChat: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .userChat)
#else
        .init()
#endif
    }

    /// The "user_follow" asset catalog image.
    static var userFollow: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .userFollow)
#else
        .init()
#endif
    }

    /// The "user_followed" asset catalog image.
    static var userFollowed: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .userFollowed)
#else
        .init()
#endif
    }

    /// The "user_video" asset catalog image.
    static var userVideo: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .userVideo)
#else
        .init()
#endif
    }

    /// The "video_mic" asset catalog image.
    static var videoMic: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .videoMic)
#else
        .init()
#endif
    }

    /// The "video_mic_off" asset catalog image.
    static var videoMicOff: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .videoMicOff)
#else
        .init()
#endif
    }

    /// The "video_off" asset catalog image.
    static var videoOff: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .videoOff)
#else
        .init()
#endif
    }

    /// The "video_voice" asset catalog image.
    static var videoVoice: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .videoVoice)
#else
        .init()
#endif
    }

    /// The "video_voice_off" asset catalog image.
    static var videoVoiceOff: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .videoVoiceOff)
#else
        .init()
#endif
    }

    /// The "wallet_coin" asset catalog image.
    static var walletCoin: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .walletCoin)
#else
        .init()
#endif
    }

    /// The "welcome_bg" asset catalog image.
    static var welcomeBg: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .welcomeBg)
#else
        .init()
#endif
    }

    /// The "welcome_start" asset catalog image.
    static var welcomeStart: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .welcomeStart)
#else
        .init()
#endif
    }

}
#endif

// MARK: - Thinnable Asset Support -

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
@available(watchOS, unavailable)
extension ColorResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if AppKit.NSColor(named: NSColor.Name(thinnableName), bundle: bundle) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIColor(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    private convenience init?(thinnableResource: ColorResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

    private init?(thinnableResource: ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    private init?(thinnableResource: ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}
#endif

@available(iOS 11.0, macOS 10.7, tvOS 11.0, *)
@available(watchOS, unavailable)
extension ImageResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if bundle.image(forResource: NSImage.Name(thinnableName)) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIImage(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    private convenience init?(thinnableResource: ImageResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    private convenience init?(thinnableResource: ImageResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

// MARK: - Backwards Deployment Support -

/// A color resource.
struct ColorResource: Swift.Hashable, Swift.Sendable {

    /// An asset catalog color resource name.
    fileprivate let name: Swift.String

    /// An asset catalog color resource bundle.
    fileprivate let bundle: Foundation.Bundle

    /// Initialize a `ColorResource` with `name` and `bundle`.
    init(name: Swift.String, bundle: Foundation.Bundle) {
        self.name = name
        self.bundle = bundle
    }

}

/// An image resource.
struct ImageResource: Swift.Hashable, Swift.Sendable {

    /// An asset catalog image resource name.
    fileprivate let name: Swift.String

    /// An asset catalog image resource bundle.
    fileprivate let bundle: Foundation.Bundle

    /// Initialize an `ImageResource` with `name` and `bundle`.
    init(name: Swift.String, bundle: Foundation.Bundle) {
        self.name = name
        self.bundle = bundle
    }

}

#if canImport(AppKit)
@available(macOS 10.13, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    /// Initialize a `NSColor` with a color resource.
    convenience init(resource: ColorResource) {
        self.init(named: NSColor.Name(resource.name), bundle: resource.bundle)!
    }

}

protocol _ACResourceInitProtocol {}
extension AppKit.NSImage: _ACResourceInitProtocol {}

@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension _ACResourceInitProtocol {

    /// Initialize a `NSImage` with an image resource.
    init(resource: ImageResource) {
        self = resource.bundle.image(forResource: NSImage.Name(resource.name))! as! Self
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    /// Initialize a `UIColor` with a color resource.
    convenience init(resource: ColorResource) {
#if !os(watchOS)
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
#else
        self.init()
#endif
    }

}

@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// Initialize a `UIImage` with an image resource.
    convenience init(resource: ImageResource) {
#if !os(watchOS)
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
#else
        self.init()
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

    /// Initialize a `Color` with a color resource.
    init(_ resource: ColorResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Image {

    /// Initialize an `Image` with an image resource.
    init(_ resource: ImageResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

}
#endif