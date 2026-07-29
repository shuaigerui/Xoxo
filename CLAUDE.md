# BrickVerse (BlockXoxoRp) — Claude Context

## Product
BrickVerse is a dark-themed social app for brick builders to share MOCs (My Own Creations), join groups, chat, and tip with coins. Brand tagline: **Build. Share. Inspire.**

## Design Sources
- Mockups: `积木社交设计图/设计图界面原稿/`
- Cut assets: `积木社交设计图/项目细节切图/` (folder per screen)
- Content: `积木社交设计图/内容填充相关资料/` (avatars + post images)
- Config: `FL-Xoixz.txt` (API host, AES keys, IAP product IDs)

## Stack
- iOS 16+, UIKit + SnapKit + IQKeyboardManager
- Programmatic UI (no Main storyboard for root)
- StoreKit 2 for IAP
- Local persistence via UserDefaults + FileManager (JSON Codable)
- Simulated HTTP layer with AES encrypt/decrypt against `opi.r4z14uho.link`

## Architecture
```
BlockXoxoRp/
  App/                 # AppDelegate, RootRouter
  Core/
    Models/            # User, Post, Comment, Conversation, Message, Group, Product
    Session/           # CurrentUserSession singleton
    Storage/           # LocalStore
    Network/           # APIClient, AESCrypto, Endpoints
    Seed/              # Built-in catalog bootstrap
  Common/
    Theme/             # Colors, Fonts, Gradients
    Components/        # Dialog, Skeleton, NavBar, Empty, Buttons
    Extensions/
  Features/
    Auth/              # Welcome, Guide, Login, SignUp, Info
    Home/              # Feed tabs ForYou/Popular/Following
    Discover/          # Trending + ranking
    Community/         # Brick Groups + Hot/New
    Post/              # Detail, Publish
    Message/           # Inbox, Chat, VideoCall
    Profile/           # Mine, UserHome, FollowList, Edit
    Wallet/            # Coins + IAP
    Settings/          # Settings, Blacklist, WebView
    Report/            # Report / Block sheet
```

## Tabs (4)
1. Home — feed with For You / Popular / Following
2. Discover — Trending Builds + Build ranking (Community groups live under Community entry from Discover/Home add flow; Community list screen matches `社区.png`)
3. Messages — conversation list
4. Profile — mine

Practical mapping: Tab2 hosts Discover; Community (`社区.png`) is a sibling root-style screen pushed or embedded as the groups+feed explore surface also reachable from Tab2 segmented “Groups” if needed. Implementation uses **Home | Community | Messages | Profile** where Community screen matches `社区.png` and Discover trending/ranking is the top section of Community OR a child VC. Final: **Home | Discover | Messages | Profile**, with Community as push from Discover “Brick Groups” header.

Resolved: Tabs = **Home / Community / Messages / Profile**. Discover trending UI is merged into Community top (Trending horizontal) + ranking optional section to avoid a 5th tab.

## Global Assets (import once)
| Name | File |
|------|------|
| common_back | 公用/common_back@3x.png |
| common_bg | 公用/common_bg@3x.png |
| common_empty | 公用/common_empty@3x.png |
| post_coin / wallet_coin / profile_coin | coin icons |
| RB_report / RB_block | report sheet |

## Auth & Session
- Credential gate: email must be registered locally except seed account `test@gmail.com` / `123456`
- After that account signs in: hydrate `CurrentUserSession` with rich social graph (follows, chats, unread, posts, coins=100)
- Fresh registration: coins=0, empty follows/chats/unread, no seeded posts
- Persist login flag; cold start → Main Tab if logged in
- Logout / delete account → clear session → Login

## Economy
- Cost: **10 coins** to publish a post or join a group
- Seed account balance: **100**; new accounts: **0**
- Insufficient balance → themed dialog → Wallet
- IAP products from FL-Xoixz.txt (real StoreKit, no sandbox-only path)

## Social Rules
- Chat / video only when **mutual follow**; otherwise light chat button + tip dialog
- More / report entry → Report-Block bottom sheet (design `举报拉黑.png` / `举报.png`)
- Block → blacklist; unfollow / hide content as designed
- All mutations go through `APIClient` (encrypted payload) then LocalStore

## Content Policy (docs only — never in source strings as mock/test/fake)
- Brick-building theme only; avoid generic template copy that triggers App Store 4.3 similarity
- No words like mock/fake/test account/dummy in code identifiers or UI
- Seed roster: 5 catalog members + one privileged login identity

## Seed Roster (5 + privileged)
| id | nick | role |
|----|------|------|
| u1 | Alex_Brick | Architecture |
| u2 | PixelMason | City MOCs |
| u3 | NeonBuilder | Cyber builds |
| u4 | TinyBrickLab | Micro scale |
| u5 | CastleCraft | Medieval |
| seed | BrickMaster | privileged login |

Each has one image post; comments 2–4; likes near comment count.

## UI Conventions
- Dark bg `#0A0E14`, card `#1C1F26`, accent yellow `#F5C518`
- No `UIAlertController` — use `BXDialog`
- Skeleton shimmer on first load of Home / Profile / UserHome / Follow / Post detail
- Fixed nav: back / title / more|settings stay outside scroll
- Scrollable body for iPhone SE / 8 short screens
- Privacy & Terms → WebView placeholder URL

## Permissions (Info.plist)
- Camera / Photo Library / Microphone with brick-sharing purpose strings
- Image pickers: camera + album on Publish & Edit profile; denied → settings guide dialog

## Video Call
- Check mic + camera authorization before presenting video UI

## Config Keys (FL-Xoixz.txt)
- Host: `opi.r4z14uho.link`
- AES key/iv for request body wrap
- IAP product ids listed in file
