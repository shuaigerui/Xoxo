# BrickVerse Implementation Plan

## Phase 0 — Docs & Memory
- [x] CLAUDE.md
- [x] PLAN.md
- [x] Key technical notes in agent memory

## Phase 1 — Project Foundation
- [x] Import cut assets + content images into Assets.xcassets
- [x] Window root via AppDelegate (no Main storyboard)
- [x] Info.plist permissions
- [x] Theme, extensions, RootRouter

## Phase 2 — Core Layer
- [x] Models, Session, LocalStore, AES + APIClient, CatalogSeeder

## Phase 3 — Common UI
- [x] BXDialog, Skeleton, NavBar, Empty, TabBar, WebView

## Phase 4 — Auth
- [x] Welcome → Guide → Login / SignUp → Profile Info → Main

## Phase 5 — Main Features
- [x] Home / Post detail / Publish
- [x] Community + Discover + Group detail
- [x] Messages / Chat / Video call
- [x] Profile / Edit / Follow lists / User home
- [x] Wallet IAP / Settings / Blacklist / Report sheet

## Phase 6 — Polish
- [x] Skeleton loads, coin gates, mutual-follow chat gate
- [x] Scrollable bodies, fixed nav, permissions
- [x] Swift compile verified — open `BlockXoxoRp.xcworkspace` in Xcode to Run
