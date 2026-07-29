import UIKit
import SnapKit

final class DiscoverViewController: UIViewController {
    private let table = UITableView(frame: .zero, style: .grouped)
    private var trending: [BrickPost] = []
    private var ranking: [(UserProfile, Int)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = BXColor.background
        setupBackground()
        setupHeader()
        setupTable()
        let sk = BXSkeletonOverlay.attach(to: view, style: .list)
        BX_NetworkManager.shared.request { _ in
            self.reloadData()
        }
        sk.finish()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: .bxSessionChanged, object: nil)
    }

    private func setupBackground() {
        let bg = UIImageView(image: UIImage(named: "common_bg"))
        bg.contentMode = .scaleAspectFill
        bg.clipsToBounds = true
        view.insertSubview(bg, at: 0)
        bg.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(280)
        }
    }

    private func setupHeader() {
        let header = UIView()
        header.tag = 9001
        view.addSubview(header)
        header.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(52)
        }

        let canPop = (navigationController?.viewControllers.count ?? 0) > 1
        if canPop {
            let back = UIButton(type: .custom)
            back.setImage(UIImage(named: "common_back"), for: .normal)
            back.addTarget(self, action: #selector(backTap), for: .touchUpInside)
            header.addSubview(back)
            back.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(12)
                $0.centerY.equalToSuperview()
                $0.size.equalTo(36)
            }
        }

        let title = UILabel()
        title.text = "Discover"
        title.font = BXFont.title(30)
        title.textColor = .white
        header.addSubview(title)
        title.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(canPop ? 48 : 16)
            $0.centerY.equalToSuperview()
        }

        let add = UIButton(type: .custom)
        add.setImage(UIImage(named: "home_add"), for: .normal)
        add.addTarget(self, action: #selector(addTap), for: .touchUpInside)
        header.addSubview(add)
        add.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(40)
        }

        let msg = UIButton(type: .custom)
        msg.setImage(UIImage(named: "home_msg"), for: .normal)
        msg.addTarget(self, action: #selector(msgTap), for: .touchUpInside)
        header.addSubview(msg)
        msg.snp.makeConstraints {
            $0.trailing.equalTo(add.snp.leading).offset(-12)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(36)
        }
    }

    private func setupTable() {
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.dataSource = self
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "trend")
        table.register(RankCell.self, forCellReuseIdentifier: "rank")
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(52)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    @objc private func reloadData() {
        trending = Array(CurrentUserSession.shared.visiblePosts().sorted { $0.likeCount > $1.likeCount }.prefix(8))
        let users = CurrentUserSession.shared.users.filter { !$0.isPrivileged || CurrentUserSession.shared.user?.id == $0.id }
        ranking = users.map { u in
            let likes = CurrentUserSession.shared.posts(of: u.id).reduce(0) { $0 + $1.likeCount }
            return (u, max(likes, 0))
        }.sorted { $0.1 > $1.1 }
        table.reloadData()
    }

    @objc private func backTap() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func addTap() {
        bx_push(PublishViewController())
    }

    @objc private func msgTap() {
        bx_push(MessageListViewController())
    }
}

extension DiscoverViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int { 2 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : ranking.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = .clear
        let l = UILabel()
        l.text = section == 0 ? "Trending Builds" : "Build ranking"
        l.textColor = .white
        l.font = BXFont.headline(17)
        v.addSubview(l)
        l.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-6)
        }
        return v
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 0 ? 40 : 44
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { 8 }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "trend", for: indexPath)
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            let cv = TrendingCarousel(posts: trending) { [weak self] post in
                self?.bx_push(PostDetailViewController(postId: post.id))
            } onLike: { [weak self] post in
                CurrentUserSession.shared.toggleLike(postId: post.id) { _ in self?.reloadData() }
            } onAuthor: { [weak self] userId in
                self?.bx_push(UserHomeViewController(userId: userId))
            }
            cell.contentView.addSubview(cv)
            cv.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.height.equalTo(248)
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "rank", for: indexPath) as! RankCell
        let item = ranking[indexPath.row]
        cell.bind(rank: indexPath.row + 1, user: item.0, likes: item.1)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.section == 0 ? 248 : 76
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        bx_push(UserHomeViewController(userId: ranking[indexPath.row].0.id))
    }
}

// MARK: - Trending

final class TrendingCarousel: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var posts: [BrickPost]
    private let onTap: (BrickPost) -> Void
    private let onLike: (BrickPost) -> Void
    private let onAuthor: (String) -> Void

    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 168, height: 240)
        layout.minimumLineSpacing = 14
        let c = UICollectionView(frame: .zero, collectionViewLayout: layout)
        c.backgroundColor = .clear
        c.showsHorizontalScrollIndicator = false
        c.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        c.dataSource = self
        c.delegate = self
        c.register(TrendCell.self, forCellWithReuseIdentifier: "c")
        return c
    }()

    init(
        posts: [BrickPost],
        onTap: @escaping (BrickPost) -> Void,
        onLike: @escaping (BrickPost) -> Void,
        onAuthor: @escaping (String) -> Void
    ) {
        self.posts = posts
        self.onTap = onTap
        self.onLike = onLike
        self.onAuthor = onAuthor
        super.init(frame: .zero)
        addSubview(collection)
        collection.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    required init?(coder: NSCoder) { fatalError() }

    func update(_ posts: [BrickPost]) {
        self.posts = posts
        collection.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { posts.count }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "c", for: indexPath) as! TrendCell
        let p = posts[indexPath.item]
        cell.bind(p, author: CurrentUserSession.shared.user(by: p.authorId))
        cell.onLike = { [weak self] in self?.onLike(p) }
        cell.onAuthor = { [weak self] in self?.onAuthor(p.authorId) }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onTap(posts[indexPath.item])
    }
}

final class TrendCell: UICollectionViewCell {
    var onLike: (() -> Void)?
    var onAuthor: (() -> Void)?

    private let cover = UIImageView()
    private let avatar = UIImageView()
    private let name = UILabel()
    private let like = UIButton(type: .custom)

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear

        cover.contentMode = .scaleAspectFill
        cover.clipsToBounds = true
        cover.bx_round(18)
        contentView.addSubview(cover)
        cover.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(196)
        }

        avatar.bx_round(14)
        avatar.isUserInteractionEnabled = true
        avatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(authorTap)))
        contentView.addSubview(avatar)
        avatar.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(2)
            $0.top.equalTo(cover.snp.bottom).offset(10)
            $0.size.equalTo(28)
        }

        name.textColor = .white
        name.font = BXFont.headline(13)
        name.isUserInteractionEnabled = true
        name.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(authorTap)))
        contentView.addSubview(name)
        name.snp.makeConstraints {
            $0.leading.equalTo(avatar.snp.trailing).offset(8)
            $0.centerY.equalTo(avatar)
            $0.trailing.lessThanOrEqualToSuperview().offset(-36)
        }

        like.addTarget(self, action: #selector(likeTap), for: .touchUpInside)
        contentView.addSubview(like)
        like.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-2)
            $0.centerY.equalTo(avatar)
            $0.size.equalTo(28)
        }
    }
    required init?(coder: NSCoder) { fatalError() }

    func bind(_ post: BrickPost, author: UserProfile?) {
        cover.bx_set(post.imageName)
        avatar.bx_avatar(author?.avatarName)
        name.text = author?.nickname
        let liked = post.likedBy.contains(CurrentUserSession.shared.user?.id ?? "")
        like.setImage(UIImage(named: liked ? "discover_liked" : "discover_like"), for: .normal)
    }

    @objc private func likeTap() { onLike?() }
    @objc private func authorTap() { onAuthor?() }
}

// MARK: - Ranking

final class RankCell: UITableViewCell {
    private let card = UIView()
    private let rank = UILabel()
    private let avatar = UIImageView()
    private let name = UILabel()
    private let heart = UIImageView()
    private let likes = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear

        card.backgroundColor = BXColor.card
        card.bx_round(16)
        contentView.addSubview(card)
        card.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16))
        }

        rank.textColor = .white
        rank.font = BXFont.title(20)
        rank.textAlignment = .center

        avatar.bx_round(20)

        name.textColor = .white
        name.font = BXFont.headline(15)

        heart.image = UIImage(named: "discover_like")
        heart.contentMode = .scaleAspectFit

        likes.textColor = .white
        likes.font = BXFont.headline(14)

        [rank, avatar, name, heart, likes].forEach { card.addSubview($0) }
        rank.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(14)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(28)
        }
        avatar.snp.makeConstraints {
            $0.leading.equalTo(rank.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(40)
        }
        name.snp.makeConstraints {
            $0.leading.equalTo(avatar.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
            $0.trailing.lessThanOrEqualTo(heart.snp.leading).offset(-8)
        }
        likes.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
        heart.snp.makeConstraints {
            $0.trailing.equalTo(likes.snp.leading).offset(-4)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(18)
        }
    }
    required init?(coder: NSCoder) { fatalError() }

    func bind(rank r: Int, user: UserProfile, likes count: Int) {
        rank.text = "\(r)"
        avatar.bx_avatar(user.avatarName)
        name.text = user.nickname
        likes.text = Self.formatCount(count)
    }

    private static func formatCount(_ n: Int) -> String {
        if n >= 10_000 { return String(format: "%.0fk", Double(n) / 1000) }
        if n >= 1000 { return String(format: "%.1fk", Double(n) / 1000).replacingOccurrences(of: ".0k", with: "k") }
        return "\(n)"
    }
}
