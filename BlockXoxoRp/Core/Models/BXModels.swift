import Foundation

struct UserProfile: Codable, Equatable {
    var id: String
    var email: String
    var password: String
    var nickname: String
    var handle: String
    var avatarName: String
    var bio: String
    var title: String
    var coins: Int
    var followingIds: [String]
    var followerIds: [String]
    var friendIds: [String]
    var likedPostIds: [String]
    var blockedIds: [String]
    var joinedCrewIds: [String]
    var isPrivileged: Bool
    var createdAt: TimeInterval

    var followingCount: Int { followingIds.count }
    var followerCount: Int { followerIds.count }
    var friendCount: Int { friendIds.count }
}

struct BrickPost: Codable, Equatable {
    var id: String
    var authorId: String
    var title: String
    var body: String
    var imageName: String
    var tag: String
    var likeCount: Int
    var commentCount: Int
    var likedBy: [String]
    var createdAt: TimeInterval
    var crewId: String?
}

struct PostComment: Codable, Equatable {
    var id: String
    var postId: String
    var authorId: String
    var body: String
    var createdAt: TimeInterval
}

struct BrickCrew: Codable, Equatable {
    var id: String
    var name: String
    var coverName: String
    var memberCount: Int
    var about: String
}

struct ChatThread: Codable, Equatable {
    var id: String
    var peerId: String
    var lastText: String
    var updatedAt: TimeInterval
    var unread: Int
    var subtitle: String
}

struct ChatBubble: Codable, Equatable {
    var id: String
    var threadId: String
    var senderId: String
    var text: String
    var createdAt: TimeInterval
}

struct CoinPack: Codable, Equatable {
    var productId: String
    var coins: Int
    var priceText: String
    var price: Decimal
}

enum ReportTarget {
    case user(String)
    case post(String)
    case comment(String)
}
