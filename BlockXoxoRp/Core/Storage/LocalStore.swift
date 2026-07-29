import Foundation

final class LocalStore {
    static let shared = LocalStore()
    private let defaults = UserDefaults.standard
    private let fm = FileManager.default

    private var rootURL: URL {
        let url = fm.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("BrickVerseData", isDirectory: true)
        if !fm.fileExists(atPath: url.path) {
            try? fm.createDirectory(at: url, withIntermediateDirectories: true)
        }
        return url
    }

    private enum Keys {
        static let loggedInId = "bx.loggedInId"
        static let guideDone = "bx.guideDone"
        static let seeded = "bx.seeded.v1"
    }

    var isGuideFinished: Bool {
        get { defaults.bool(forKey: Keys.guideDone) }
        set { defaults.set(newValue, forKey: Keys.guideDone) }
    }

    var loggedInUserId: String? {
        get { defaults.string(forKey: Keys.loggedInId) }
        set { defaults.set(newValue, forKey: Keys.loggedInId) }
    }

    var hasSeeded: Bool {
        get { defaults.bool(forKey: Keys.seeded) }
        set { defaults.set(newValue, forKey: Keys.seeded) }
    }

    func save<T: Codable>(_ value: T, file: String) {
        let url = rootURL.appendingPathComponent(file)
        let data = try? JSONEncoder().encode(value)
        try? data?.write(to: url, options: .atomic)
    }

    func load<T: Codable>(_ type: T.Type, file: String) -> T? {
        let url = rootURL.appendingPathComponent(file)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }

    func clearSessionFlag() {
        loggedInUserId = nil
    }
}

enum StoreFile {
    static let users = "users.json"
    static let posts = "posts.json"
    static let comments = "comments.json"
    static let crews = "crews.json"
    static let threads = "threads.json"
    static let bubbles = "bubbles.json"
    static let hiddenPosts = "hidden_posts.json"
    static let hiddenComments = "hidden_comments.json"
}
