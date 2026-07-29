import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    private enum FeedTab: Int { case forYou, popular, following }
    private var feedTab: FeedTab = .forYou
    private var items: [BrickPost] = []
    private let table = UITableView(frame: .zero, style: .plain)
    private let tabStack = UIStackView()
    private var skeleton: BXSkeletonOverlay?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = BXColor.background
        setupHeader()
        setupTabs()
        setupTable()
        skeleton = BXSkeletonOverlay.attach(to: view, style: .feed)
        BX_NetworkManager.shared.request { _ in
            self.reload()
        }
        skeleton?.finish()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: .bxSessionChanged, object: nil)
    }

    private func setupHeader() {
        let title = UILabel()
        title.text = "Home"
        title.font = BXFont.title(30)
        title.textColor = .white
        view.addSubview(title)
        title.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }

        let add = UIButton(type: .custom)
        add.setImage(UIImage(named: "home_add"), for: .normal)
        add.addTarget(self, action: #selector(addTap), for: .touchUpInside)
        view.addSubview(add)
        add.snp.makeConstraints {
            $0.centerY.equalTo(title)
            $0.trailing.equalToSuperview().offset(-16)
            $0.size.equalTo(40)
        }

        let msg = UIButton(type: .custom)
        msg.setImage(UIImage(named: "home_msg"), for: .normal)
        msg.addTarget(self, action: #selector(msgTap), for: .touchUpInside)
        view.addSubview(msg)
        msg.snp.makeConstraints {
            $0.centerY.equalTo(title)
            $0.trailing.equalTo(add.snp.leading).offset(-12)
            $0.size.equalTo(36)
        }
        title.tag = 101
    }

    private func setupTabs() {
        tabStack.axis = .horizontal
        tabStack.spacing = 10
        tabStack.distribution = .fillEqually
        ["For You", "Popular", "Following"].enumerated().forEach { idx, name in
            let b = UIButton(type: .system)
            b.setTitle(name, for: .normal)
            b.titleLabel?.font = BXFont.headline(13)
            b.tag = idx
            b.bx_round(16)
            b.addTarget(self, action: #selector(tabTap(_:)), for: .touchUpInside)
            tabStack.addArrangedSubview(b)
        }
        view.addSubview(tabStack)
        tabStack.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(56)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(34)
        }
        refreshTabUI()
    }

    private func setupTable() {
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.dataSource = self
        table.delegate = self
        table.register(HomeFeedCell.self, forCellReuseIdentifier: "cell")
        table.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 20, right: 0)
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.top.equalTo(tabStack.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func refreshTabUI() {
        tabStack.arrangedSubviews.enumerated().forEach { idx, v in
            guard let b = v as? UIButton else { return }
            let on = idx == feedTab.rawValue
            b.backgroundColor = on ? BXColor.accent : BXColor.card
            b.setTitleColor(on ? .black : .white, for: .normal)
        }
    }

    @objc private func tabTap(_ sender: UIButton) {
        feedTab = FeedTab(rawValue: sender.tag) ?? .forYou
        refreshTabUI()
        reload()
    }

    @objc private func reload() {
        let all = CurrentUserSession.shared.visiblePosts()
        switch feedTab {
        case .forYou:
            items = all
        case .popular:
            items = all.sorted { $0.likeCount > $1.likeCount }
        case .following:
            let ids = Set(CurrentUserSession.shared.user?.followingIds ?? [])
            items = all.filter { ids.contains($0.authorId) }
        }
        table.reloadData()
    }

    @objc private func addTap() {
        bx_push(PublishViewController())
    }

    @objc private func msgTap() {
        bx_push(MessageListViewController())
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { items.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeFeedCell
        let post = items[indexPath.row]
        let author = CurrentUserSession.shared.user(by: post.authorId)
        cell.bind(post: post, authorName: author?.nickname ?? "")
        cell.onComment = { [weak self] in self?.bx_push(PostDetailViewController(postId: post.id)) }
        cell.onLike = { [weak self] in
            CurrentUserSession.shared.toggleLike(postId: post.id) { _ in self?.reload() }
        }
        cell.onAuthor = { [weak self] in
            self?.bx_push(UserHomeViewController(userId: post.authorId))
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 420 }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        bx_push(PostDetailViewController(postId: items[indexPath.row].id))
    }
}

final class HomeFeedCell: UITableViewCell {
    var onComment: (() -> Void)?
    var onLike: (() -> Void)?
    var onAuthor: (() -> Void)?

    private let card = UIImageView()
    private let nameLabel = UILabel()
    private let titleLabel = UILabel()
    private let tagLabel = UILabel()
    private let descLabel = UILabel()
    private let commentBtn = UIButton(type: .custom)
    private let likeBtn = UIButton(type: .custom)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        card.contentMode = .scaleAspectFill
        card.bx_round(22)
        contentView.addSubview(card)
        card.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        let dim = CAGradientLayer()
        dim.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.75).cgColor]
        dim.locations = [0.45, 1]
        dim.name = "dim"
        card.layer.addSublayer(dim)

        nameLabel.font = BXFont.headline(14)
        nameLabel.textColor = .white
        titleLabel.font = BXFont.body(13)
        titleLabel.textColor = UIColor(white: 0.9, alpha: 1)
        tagLabel.font = BXFont.caption(11)
        tagLabel.textColor = .black
        tagLabel.backgroundColor = BXColor.accent
        tagLabel.textAlignment = .center
        tagLabel.bx_round(10)
        descLabel.font = BXFont.body(13)
        descLabel.textColor = .white
        descLabel.numberOfLines = 3

        commentBtn.setImage(UIImage(named: "home_commit"), for: .normal)
        likeBtn.setImage(UIImage(named: "home_like"), for: .normal)
        commentBtn.addTarget(self, action: #selector(cTap), for: .touchUpInside)
        likeBtn.addTarget(self, action: #selector(lTap), for: .touchUpInside)
        nameLabel.isUserInteractionEnabled = true
        nameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(aTap)))

        [nameLabel, titleLabel, tagLabel, descLabel, commentBtn, likeBtn].forEach { card.addSubview($0) }
        nameLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(14)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(2)
            $0.leading.equalTo(nameLabel)
            $0.trailing.lessThanOrEqualTo(tagLabel.snp.leading).offset(-8)
        }
        tagLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(14)
            $0.height.equalTo(22)
            $0.width.greaterThanOrEqualTo(80)
        }
        likeBtn.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-14)
            $0.bottom.equalToSuperview().offset(-70)
            $0.size.equalTo(40)
        }
        commentBtn.snp.makeConstraints {
            $0.trailing.equalTo(likeBtn)
            $0.bottom.equalTo(likeBtn.snp.top).offset(-12)
            $0.size.equalTo(40)
        }
        descLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(14)
            $0.trailing.equalTo(likeBtn.snp.leading).offset(-10)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
    required init?(coder: NSCoder) { fatalError() }

    override func layoutSubviews() {
        super.layoutSubviews()
        card.layer.sublayers?.first { $0.name == "dim" }?.frame = card.bounds
    }

    func bind(post: BrickPost, authorName: String) {
        card.bx_set(post.imageName)
        nameLabel.text = authorName
        titleLabel.text = post.title
        tagLabel.text = "  \(post.tag)  "
        descLabel.text = post.body
        let liked = post.likedBy.contains(CurrentUserSession.shared.user?.id ?? "")
        likeBtn.setImage(UIImage(named: liked ? "home_liked" : "home_like"), for: .normal)
    }

    @objc private func cTap() { onComment?() }
    @objc private func lTap() { onLike?() }
    @objc private func aTap() { onAuthor?() }
}
