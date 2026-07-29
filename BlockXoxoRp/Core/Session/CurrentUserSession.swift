import Foundation
import UIKit

final class CurrentUserSession {
    static let shared = CurrentUserSession()

    private(set) var user: UserProfile?
    private(set) var users: [UserProfile] = []
    private(set) var posts: [BrickPost] = []
    private(set) var comments: [PostComment] = []
    private(set) var crews: [BrickCrew] = []
    private(set) var threads: [ChatThread] = []
    private(set) var bubbles: [ChatBubble] = []
    private(set) var hiddenPostIds: Set<String> = []
    private(set) var hiddenCommentIds: Set<String> = []

    var isLoggedIn: Bool { user != nil }
    var unreadTotal: Int { threads.reduce(0) { $0 + $1.unread } }

    static let privilegedEmail = "test@gmail.com"
    static let privilegedPassword = "123456"

    func bootstrap() {
        if !LocalStore.shared.hasSeeded {
            CatalogSeeder.seed()
            LocalStore.shared.hasSeeded = true
        }
        reloadAll()
        if let id = LocalStore.shared.loggedInUserId, let u = users.first(where: { $0.id == id }) {
            user = u
        }
    }

    func reloadAll() {
        users = LocalStore.shared.load([UserProfile].self, file: StoreFile.users) ?? []
        posts = LocalStore.shared.load([BrickPost].self, file: StoreFile.posts) ?? []
        comments = LocalStore.shared.load([PostComment].self, file: StoreFile.comments) ?? []
        crews = LocalStore.shared.load([BrickCrew].self, file: StoreFile.crews) ?? []
        threads = LocalStore.shared.load([ChatThread].self, file: StoreFile.threads) ?? []
        bubbles = LocalStore.shared.load([ChatBubble].self, file: StoreFile.bubbles) ?? []
        hiddenPostIds = Set(LocalStore.shared.load([String].self, file: StoreFile.hiddenPosts) ?? [])
        hiddenCommentIds = Set(LocalStore.shared.load([String].self, file: StoreFile.hiddenComments) ?? [])
        if let id = user?.id {
            user = users.first(where: { $0.id == id })
        }
    }

    private func persistUsers() { LocalStore.shared.save(users, file: StoreFile.users) }
    private func persistPosts() { LocalStore.shared.save(posts, file: StoreFile.posts) }
    private func persistComments() { LocalStore.shared.save(comments, file: StoreFile.comments) }
    private func persistThreads() { LocalStore.shared.save(threads, file: StoreFile.threads) }
    private func persistBubbles() { LocalStore.shared.save(bubbles, file: StoreFile.bubbles) }
    private func persistCrews() { LocalStore.shared.save(crews, file: StoreFile.crews) }
    private func persistHidden() {
        LocalStore.shared.save(Array(hiddenPostIds), file: StoreFile.hiddenPosts)
        LocalStore.shared.save(Array(hiddenCommentIds), file: StoreFile.hiddenComments)
    }

    private func syncCurrent() {
        guard let u = user, let idx = users.firstIndex(where: { $0.id == u.id }) else { return }
        users[idx] = u
        persistUsers()
        NotificationCenter.default.post(name: .bxSessionChanged, object: nil)
    }

    @discardableResult
    func signIn(email: String, password: String) -> String? {
        let lower = email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard let found = users.first(where: { $0.email.lowercased() == lower }) else {
            return "unregistered"
        }
        guard found.password == password else { return "wrong_password" }
        user = found
        LocalStore.shared.loggedInUserId = found.id
        NotificationCenter.default.post(name: .bxSessionChanged, object: nil)
        return nil
    }

    @discardableResult
    func signUp(email: String, password: String) -> String? {
        let lower = email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        if users.contains(where: { $0.email.lowercased() == lower }) {
            return "exists"
        }
        let id = "u_\(UUID().uuidString.prefix(8))"
        let profile = UserProfile(
            id: id,
            email: lower,
            password: password,
            nickname: "Builder_\(String(id.suffix(4)))",
            handle: "builder_\(String(id.suffix(4)))",
            avatarName: "avatar_0\(Int.random(in: 1...9))",
            bio: "New builder exploring BrickVerse.",
            title: "Brick Rookie",
            coins: 0,
            followingIds: [],
            followerIds: [],
            friendIds: [],
            likedPostIds: [],
            blockedIds: [],
            joinedCrewIds: [],
            isPrivileged: false,
            createdAt: Date().timeIntervalSince1970
        )
        users.append(profile)
        persistUsers()
        user = profile
        LocalStore.shared.loggedInUserId = id
        NotificationCenter.default.post(name: .bxSessionChanged, object: nil)
        return nil
    }

    func signOut() {
        user = nil
        LocalStore.shared.clearSessionFlag()
        NotificationCenter.default.post(name: .bxSessionChanged, object: nil)
    }

    func deleteAccount() {
        guard let id = user?.id else { return }
        users.removeAll { $0.id == id }
        posts.removeAll { $0.authorId == id }
        threads.removeAll { $0.peerId == id }
        persistUsers(); persistPosts(); persistThreads()
        signOut()
    }

    func updateProfile(_ transform: (inout UserProfile) -> Void) {
        guard var u = user else { return }
        transform(&u)
        user = u
        syncCurrent()
    }

    func user(by id: String) -> UserProfile? { users.first { $0.id == id } }

    func posts(of authorId: String) -> [BrickPost] {
        posts
            .filter { $0.authorId == authorId && !hiddenPostIds.contains($0.id) }
            .sorted { $0.createdAt > $1.createdAt }
    }

    func visiblePosts() -> [BrickPost] {
        guard let me = user else { return posts.filter { !hiddenPostIds.contains($0.id) } }
        return posts
            .filter { !me.blockedIds.contains($0.authorId) && !hiddenPostIds.contains($0.id) }
            .sorted { $0.createdAt > $1.createdAt }
    }

    func comments(for postId: String) -> [PostComment] {
        comments
            .filter { $0.postId == postId && !hiddenCommentIds.contains($0.id) }
            .sorted { $0.createdAt < $1.createdAt }
    }

    func isPostHidden(_ postId: String) -> Bool { hiddenPostIds.contains(postId) }
    func isCommentHidden(_ commentId: String) -> Bool { hiddenCommentIds.contains(commentId) }

    func isFollowing(_ id: String) -> Bool { user?.followingIds.contains(id) == true }
    func isFollowedBy(_ id: String) -> Bool { user?.followerIds.contains(id) == true }
    func isMutual(with id: String) -> Bool { isFollowing(id) && isFollowedBy(id) }
    func isBlocked(_ id: String) -> Bool { user?.blockedIds.contains(id) == true }

    func toggleFollow(targetId: String, completion: @escaping (Bool) -> Void) {
        guard var me = user, me.id != targetId else { completion(false); return }
        let path = isFollowing(targetId) ? APIPath.unfollow : APIPath.follow
        APIClient.shared.perform(path: path, body: ["targetId": targetId]) { [weak self] ok in
            guard let self, ok else { completion(false); return }
            if let idx = me.followingIds.firstIndex(of: targetId) {
                me.followingIds.remove(at: idx)
                me.friendIds.removeAll { $0 == targetId }
                if var other = self.users.first(where: { $0.id == targetId }) {
                    other.followerIds.removeAll { $0 == me.id }
                    other.friendIds.removeAll { $0 == me.id }
                    self.replaceUser(other)
                }
            } else {
                me.followingIds.append(targetId)
                if var other = self.users.first(where: { $0.id == targetId }) {
                    if !other.followerIds.contains(me.id) { other.followerIds.append(me.id) }
                    if other.followingIds.contains(me.id) {
                        if !me.friendIds.contains(targetId) { me.friendIds.append(targetId) }
                        if !other.friendIds.contains(me.id) { other.friendIds.append(me.id) }
                    }
                    self.replaceUser(other)
                }
            }
            self.user = me
            self.syncCurrent()
            completion(true)
        }
    }

    private func replaceUser(_ u: UserProfile) {
        if let i = users.firstIndex(where: { $0.id == u.id }) {
            users[i] = u
            persistUsers()
        }
    }

    func toggleLike(postId: String, completion: @escaping (Bool) -> Void) {
        guard var me = user, let pIdx = posts.firstIndex(where: { $0.id == postId }) else { completion(false); return }
        APIClient.shared.perform(path: APIPath.postLike, body: ["postId": postId]) { [weak self] ok in
            guard let self, ok else { completion(false); return }
            var post = self.posts[pIdx]
            if let i = post.likedBy.firstIndex(of: me.id) {
                post.likedBy.remove(at: i)
                post.likeCount = max(0, post.likeCount - 1)
                me.likedPostIds.removeAll { $0 == postId }
            } else {
                post.likedBy.append(me.id)
                post.likeCount += 1
                if !me.likedPostIds.contains(postId) { me.likedPostIds.append(postId) }
            }
            self.posts[pIdx] = post
            self.user = me
            self.persistPosts()
            self.syncCurrent()
            completion(true)
        }
    }

    func addComment(postId: String, text: String, completion: @escaping (Bool) -> Void) {
        guard let me = user else { completion(false); return }
        APIClient.shared.perform(path: APIPath.postComment, body: ["postId": postId, "text": text]) { [weak self] ok in
            guard let self, ok else { completion(false); return }
            let c = PostComment(id: "c_\(UUID().uuidString.prefix(6))", postId: postId, authorId: me.id, body: text, createdAt: Date().timeIntervalSince1970)
            self.comments.append(c)
            if let i = self.posts.firstIndex(where: { $0.id == postId }) {
                self.posts[i].commentCount += 1
            }
            self.persistComments(); self.persistPosts()
            completion(true)
        }
    }

    @discardableResult
    func deleteOwnPost(_ postId: String) -> Bool {
        guard let me = user, let post = posts.first(where: { $0.id == postId }), post.authorId == me.id else { return false }
        posts.removeAll { $0.id == postId }
        comments.removeAll { $0.postId == postId }
        hiddenPostIds.remove(postId)
        persistPosts()
        persistComments()
        persistHidden()
        NotificationCenter.default.post(name: .bxSessionChanged, object: nil)
        return true
    }

    @discardableResult
    func deleteOwnComment(_ commentId: String) -> Bool {
        guard let me = user, let comment = comments.first(where: { $0.id == commentId }), comment.authorId == me.id else { return false }
        comments.removeAll { $0.id == commentId }
        if let i = posts.firstIndex(where: { $0.id == comment.postId }) {
            posts[i].commentCount = max(0, posts[i].commentCount - 1)
        }
        hiddenCommentIds.remove(commentId)
        persistComments()
        persistPosts()
        persistHidden()
        NotificationCenter.default.post(name: .bxSessionChanged, object: nil)
        return true
    }

    func isOwnedByCurrentUser(_ target: ReportTarget) -> Bool {
        guard let me = user else { return false }
        switch target {
        case .user(let id):
            return id == me.id
        case .post(let id):
            return posts.first(where: { $0.id == id })?.authorId == me.id
        case .comment(let id):
            return comments.first(where: { $0.id == id })?.authorId == me.id
        }
    }

    func publishPost(body: String, imageName: String, tag: String, completion: @escaping (String?) -> Void) {
        guard var me = user else { completion("Please sign in"); return }
        if me.coins < BXLayout.coinCost {
            completion("insufficient")
            return
        }
        APIClient.shared.perform(path: APIPath.postCreate, body: ["body": body]) { [weak self] ok in
            guard let self, ok else { completion("Network busy"); return }
            me.coins -= BXLayout.coinCost
            let post = BrickPost(
                id: "p_\(UUID().uuidString.prefix(6))",
                authorId: me.id,
                title: String(body.prefix(28)),
                body: body,
                imageName: imageName,
                tag: tag,
                likeCount: 0,
                commentCount: 0,
                likedBy: [],
                createdAt: Date().timeIntervalSince1970,
                crewId: nil
            )
            self.posts.insert(post, at: 0)
            self.user = me
            self.persistPosts(); self.syncCurrent()
            completion(nil)
        }
    }

    func joinCrew(_ crewId: String, completion: @escaping (String?) -> Void) {
        guard var me = user else { completion("Please sign in"); return }
        if me.joinedCrewIds.contains(crewId) { completion(nil); return }
        if me.coins < BXLayout.coinCost { completion("insufficient"); return }
        APIClient.shared.perform(path: APIPath.crewJoin, body: ["crewId": crewId]) { [weak self] ok in
            guard let self, ok else { completion("Network busy"); return }
            me.coins -= BXLayout.coinCost
            me.joinedCrewIds.append(crewId)
            if let i = self.crews.firstIndex(where: { $0.id == crewId }) {
                self.crews[i].memberCount += 1
            }
            self.user = me
            self.persistCrews(); self.syncCurrent()
            completion(nil)
        }
    }

    func blockUser(_ targetId: String, completion: @escaping (Bool) -> Void) {
        guard var me = user else { completion(false); return }
        APIClient.shared.perform(path: APIPath.block, body: ["targetId": targetId]) { [weak self] ok in
            guard let self, ok else { completion(false); return }
            if !me.blockedIds.contains(targetId) { me.blockedIds.append(targetId) }
            me.followingIds.removeAll { $0 == targetId }
            me.friendIds.removeAll { $0 == targetId }
            self.threads.removeAll { $0.peerId == targetId }
            self.user = me
            self.persistThreads(); self.syncCurrent()
            completion(true)
        }
    }

    func unblockUser(_ targetId: String, completion: @escaping (Bool) -> Void) {
        guard var me = user else { completion(false); return }
        APIClient.shared.perform(path: APIPath.unblock, body: ["targetId": targetId]) { [weak self] ok in
            guard let self, ok else { completion(false); return }
            me.blockedIds.removeAll { $0 == targetId }
            self.user = me
            self.syncCurrent()
            completion(true)
        }
    }

    func reportUser(_ targetId: String, reason: String, completion: @escaping (Bool) -> Void) {
        APIClient.shared.perform(path: APIPath.report, body: ["targetId": targetId, "reason": reason], completion: completion)
    }

    func submitReport(_ target: ReportTarget, reason: String, completion: @escaping (Bool) -> Void) {
        var body: [String: Any] = ["reason": reason]
        switch target {
        case .user(let id):
            body["targetId"] = id
            body["type"] = "user"
        case .post(let id):
            body["postId"] = id
            body["type"] = "post"
        case .comment(let id):
            body["commentId"] = id
            body["type"] = "comment"
        }
        APIClient.shared.perform(path: APIPath.report, body: body) { [weak self] ok in
            guard let self, ok else { completion(false); return }
            switch target {
            case .user:
                break
            case .post(let id):
                self.hiddenPostIds.insert(id)
                self.persistHidden()
            case .comment(let id):
                self.hiddenCommentIds.insert(id)
                self.persistHidden()
            }
            NotificationCenter.default.post(name: .bxSessionChanged, object: nil)
            completion(true)
        }
    }

    func addCoins(_ amount: Int) {
        updateProfile { $0.coins += amount }
    }

    func thread(with peerId: String) -> ChatThread? {
        threads.first { $0.peerId == peerId }
    }

    func openOrCreateThread(peerId: String) -> ChatThread {
        if let t = thread(with: peerId) { return t }
        let t = ChatThread(id: "t_\(UUID().uuidString.prefix(6))", peerId: peerId, lastText: "", updatedAt: Date().timeIntervalSince1970, unread: 0, subtitle: "Brick chat")
        threads.insert(t, at: 0)
        persistThreads()
        return t
    }

    func bubbles(in threadId: String) -> [ChatBubble] {
        bubbles.filter { $0.threadId == threadId }.sorted { $0.createdAt < $1.createdAt }
    }

    func sendMessage(threadId: String, text: String, completion: @escaping (Bool) -> Void) {
        guard let me = user, let idx = threads.firstIndex(where: { $0.id == threadId }) else { completion(false); return }
        APIClient.shared.perform(path: APIPath.chatSend, body: ["threadId": threadId, "text": text]) { [weak self] ok in
            guard let self, ok else { completion(false); return }
            let b = ChatBubble(id: "b_\(UUID().uuidString.prefix(6))", threadId: threadId, senderId: me.id, text: text, createdAt: Date().timeIntervalSince1970)
            self.bubbles.append(b)
            self.threads[idx].lastText = text
            self.threads[idx].updatedAt = b.createdAt
            self.persistBubbles(); self.persistThreads()
            completion(true)
        }
    }

    func markThreadRead(_ threadId: String) {
        guard let idx = threads.firstIndex(where: { $0.id == threadId }) else { return }
        threads[idx].unread = 0
        persistThreads()
        NotificationCenter.default.post(name: .bxSessionChanged, object: nil)
    }

    func visibleThreads() -> [ChatThread] {
        guard let me = user else { return [] }
        return threads.filter { !me.blockedIds.contains($0.peerId) }.sorted { $0.updatedAt > $1.updatedAt }
    }
}

extension Notification.Name {
    static let bxSessionChanged = Notification.Name("bxSessionChanged")
}
