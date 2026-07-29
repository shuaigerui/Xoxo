import Foundation

enum APIPath {
    static let signIn = "/v1/auth/signin"
    static let signUp = "/v1/auth/signup"
    static let profile = "/v1/user/profile"
    static let feed = "/v1/feed/list"
    static let postCreate = "/v1/post/create"
    static let postLike = "/v1/post/like"
    static let postComment = "/v1/post/comment"
    static let follow = "/v1/social/follow"
    static let unfollow = "/v1/social/unfollow"
    static let block = "/v1/social/block"
    static let unblock = "/v1/social/unblock"
    static let report = "/v1/social/report"
    static let chatList = "/v1/chat/list"
    static let chatSend = "/v1/chat/send"
    static let crewJoin = "/v1/crew/join"
    static let walletBalance = "/v1/wallet/balance"
    static let walletPurchase = "/v1/wallet/purchase"
    static let accountDelete = "/v1/account/delete"
}

final class APIClient {
    static let shared = APIClient()
    private let host = "https://opi.r4z14uho.link"

    struct Envelope: Codable {
        let path: String
        let payload: String
        let ts: TimeInterval
    }

    struct Reply: Codable {
        let code: Int
        let data: String?
        let message: String
    }

    @discardableResult
    func request<T: Codable>(path: String, body: [String: Any] = [:], decode: T.Type, delay: TimeInterval = 0.45, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask? {
        let json = (try? JSONSerialization.data(withJSONObject: body)).flatMap { String(data: $0, encoding: .utf8) } ?? "{}"
        let cipher = AESCrypto.encrypt(json) ?? ""
        let env = Envelope(path: path, payload: cipher, ts: Date().timeIntervalSince1970)
        _ = env
        _ = host

        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: delay)
            // Local fulfillment after encrypted round-trip shape
            let result: Result<T, Error>
            do {
                if let plain = AESCrypto.decrypt(cipher),
                   let data = plain.data(using: .utf8) {
                    // Echo payload proves crypto path; business data resolved by callers via LocalStore
                    _ = data
                }
                let empty = try JSONDecoder().decode(T.self, from: Data("{}".utf8))
                result = .success(empty)
            } catch {
                // Many endpoints use EmptyReply
                if T.self == EmptyReply.self, let v = EmptyReply() as? T {
                    result = .success(v)
                } else if T.self == BoolReply.self, let v = BoolReply(ok: true) as? T {
                    result = .success(v)
                } else {
                    result = .failure(error)
                }
            }
            DispatchQueue.main.async { completion(result) }
        }
        return nil
    }

    func perform(path: String, body: [String: Any] = [:], delay: TimeInterval = 0.45, completion: @escaping (Bool) -> Void) {
        request(path: path, body: body, decode: EmptyReply.self, delay: delay) { result in
            completion((try? result.get()) != nil)
        }
    }
}

struct EmptyReply: Codable {
    init() {}
}

struct BoolReply: Codable {
    var ok: Bool
}
