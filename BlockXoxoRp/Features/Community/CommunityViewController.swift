import UIKit
import SnapKit

final class CommunityViewController: UIViewController {
    private var hotMode = true
    private var posts: [BrickPost] = []
    private let table = UITableView(frame: .zero, style: .grouped)
    private var skeleton: BXSkeletonOverlay?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = BXColor.background
        setupHeader()
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.dataSource = self
        table.delegate = self
        table.register(CrewCell.self, forCellReuseIdentifier: "crew")
        table.register(CommunityPostCell.self, forCellReuseIdentifier: "post")
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(56)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        skeleton = BXSkeletonOverlay.attach(to: view, style: .feed)
        BX_NetworkManager.shared.request { _ in
            self.reload()
        }
        skeleton?.finish()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: .bxSessionChanged, object: nil)
    }

    private func setupHeader() {
        let title = UILabel()
        title.text = "Community"
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
    }

    @objc private func reload() {
        let all = CurrentUserSession.shared.visiblePosts()
        posts = hotMode ? all.sorted { $0.likeCount > $1.likeCount } : all.sorted { $0.createdAt > $1.createdAt }
        table.reloadData()
    }

    @objc private func addTap() { bx_push(PublishViewController()) }
    @objc private func msgTap() { bx_push(MessageListViewController()) }
}

extension CommunityViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int { 2 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? CurrentUserSession.shared.crews.count : posts.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = BXColor.background
        let lab = UILabel()
        lab.textColor = .white
        lab.font = BXFont.headline(16)
        v.addSubview(lab)
        lab.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        if section == 0 {
            lab.text = "Brick Groups"
        } else {
            lab.text = ""
            let hot = UIButton(type: .system)
            hot.setTitle("Hot", for: .normal)
            hot.tag = 1
            let neu = UIButton(type: .system)
            neu.setTitle("New", for: .normal)
            neu.tag = 2
            [hot, neu].forEach {
                $0.titleLabel?.font = BXFont.headline(13)
                $0.bx_round(14)
                $0.contentEdgeInsets = UIEdgeInsets(top: 6, left: 14, bottom: 6, right: 14)
                $0.addTarget(self, action: #selector(modeTap(_:)), for: .touchUpInside)
                v.addSubview($0)
            }
            hot.backgroundColor = hotMode ? BXColor.accent : .clear
            hot.setTitleColor(hotMode ? .black : .white, for: .normal)
            neu.backgroundColor = !hotMode ? BXColor.accent : .clear
            neu.setTitleColor(!hotMode ? .black : .white, for: .normal)
            hot.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(16)
                $0.centerY.equalToSuperview()
            }
            neu.snp.makeConstraints {
                $0.leading.equalTo(hot.snp.trailing).offset(8)
                $0.centerY.equalToSuperview()
            }
        }
        return v
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 40 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "crew", for: indexPath) as! CrewCell
            cell.bind(CurrentUserSession.shared.crews[indexPath.row])
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "post", for: indexPath) as! CommunityPostCell
        let post = posts[indexPath.row]
        cell.bind(post: post, author: CurrentUserSession.shared.user(by: post.authorId))
        cell.onVideo = { [weak self] in
            guard let self else { return }
            let peerId = post.authorId
            if peerId == CurrentUserSession.shared.user?.id {
                BXDialog.show(on: self, message: "You can’t video call yourself.", confirmTitle: "Continue")
                return
            }
            guard CurrentUserSession.shared.isMutual(with: peerId) else {
                BXDialog.show(
                    on: self,
                    title: "Follow each other first",
                    message: "Video call unlocks when you both follow each other.",
                    confirmTitle: "Continue"
                )
                return
            }
            MediaPickerHelper.ensureAVPermissions(from: self) { [weak self] ok in
                guard let self, ok else { return }
                self.bx_push(VideoCallViewController(peerId: peerId))
            }
        }
        cell.onLike = { [weak self] in
            CurrentUserSession.shared.toggleLike(postId: post.id) { _ in self?.reload() }
        }
        cell.onComment = { [weak self] in self?.bx_push(PostDetailViewController(postId: post.id)) }
        cell.onReport = { [weak self] in
            ReportBlockPresenter.present(from: self!, target: .post(post.id))
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.section == 0 ? 84 : 360
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            bx_push(CrewDetailViewController(crewId: CurrentUserSession.shared.crews[indexPath.row].id))
        } else {
            bx_push(PostDetailViewController(postId: posts[indexPath.row].id))
        }
    }
    @objc private func modeTap(_ sender: UIButton) {
        hotMode = sender.tag == 1
        reload()
    }
}

final class CrewCell: UITableViewCell {
    private let card = UIView()
    private let cover = UIImageView()
    private let name = UILabel()
    private let members = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        card.backgroundColor = BXColor.card
        card.bx_round(14)
        contentView.addSubview(card)
        card.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16))
        }
        cover.bx_round(10)
        card.addSubview(cover)
        cover.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview().inset(10)
            $0.width.equalTo(cover.snp.height)
        }
        name.textColor = .white
        name.font = BXFont.headline(15)
        members.textColor = BXColor.textSecondary
        members.font = BXFont.caption(12)
        card.addSubview(name)
        card.addSubview(members)
        name.snp.makeConstraints {
            $0.leading.equalTo(cover.snp.trailing).offset(12)
            $0.bottom.equalTo(card.snp.centerY).offset(-2)
        }
        members.snp.makeConstraints {
            $0.leading.equalTo(name)
            $0.top.equalTo(card.snp.centerY).offset(2)
        }
    }
    required init?(coder: NSCoder) { fatalError() }
    func bind(_ crew: BrickCrew) {
        cover.bx_set(crew.coverName)
        name.text = crew.name
        members.text = "\(crew.memberCount) members"
    }
}

final class CommunityPostCell: UITableViewCell {
    var onVideo: (() -> Void)?
    var onLike: (() -> Void)?
    var onComment: (() -> Void)?
    var onReport: (() -> Void)?

    private let card = UIView()
    private let avatar = UIImageView()
    private let name = UILabel()
    private let time = UILabel()
    private let videoBtn = UIButton(type: .custom)
    private let body = UILabel()
    private let image = UIImageView()
    private let commentBtn = UIButton(type: .custom)
    private let likeBtn = UIButton(type: .custom)
    private let reportBtn = UIButton(type: .custom)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        card.backgroundColor = BXColor.card
        card.bx_round(16)
        contentView.addSubview(card)
        card.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16))
        }
        avatar.bx_round(18)
        name.textColor = .white
        name.font = BXFont.headline(14)
        time.textColor = BXColor.textSecondary
        time.font = BXFont.caption(12)
        videoBtn.setImage(UIImage(named: "community_video"), for: .normal)
        videoBtn.addTarget(self, action: #selector(vTap), for: .touchUpInside)
        body.textColor = .white
        body.font = BXFont.body(14)
        body.numberOfLines = 3
        image.bx_round(14)
        commentBtn.setImage(UIImage(named: "community_commit"), for: .normal)
        likeBtn.setImage(UIImage(named: "community_like"), for: .normal)
        reportBtn.setImage(UIImage(named: "community_alert"), for: .normal)
        commentBtn.addTarget(self, action: #selector(cTap), for: .touchUpInside)
        likeBtn.addTarget(self, action: #selector(lTap), for: .touchUpInside)
        reportBtn.addTarget(self, action: #selector(rTap), for: .touchUpInside)
        [avatar, name, time, videoBtn, body, image, commentBtn, likeBtn, reportBtn].forEach { card.addSubview($0) }
        avatar.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(12)
            $0.size.equalTo(36)
        }
        name.snp.makeConstraints {
            $0.leading.equalTo(avatar.snp.trailing).offset(8)
            $0.top.equalTo(avatar)
        }
        time.snp.makeConstraints {
            $0.leading.equalTo(name)
            $0.top.equalTo(name.snp.bottom).offset(2)
        }
        videoBtn.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-12)
            $0.centerY.equalTo(avatar)
            $0.height.equalTo(32)
            $0.width.equalTo(110)
        }
        body.snp.makeConstraints {
            $0.top.equalTo(avatar.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        image.snp.makeConstraints {
            $0.top.equalTo(body.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(180)
        }
        commentBtn.snp.makeConstraints {
            $0.top.equalTo(image.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-12)
            $0.size.equalTo(28)
        }
        likeBtn.snp.makeConstraints {
            $0.centerY.equalTo(commentBtn)
            $0.leading.equalTo(commentBtn.snp.trailing).offset(16)
            $0.size.equalTo(28)
        }
        reportBtn.snp.makeConstraints {
            $0.centerY.equalTo(commentBtn)
            $0.trailing.equalToSuperview().offset(-12)
            $0.size.equalTo(28)
        }
    }
    required init?(coder: NSCoder) { fatalError() }

    func bind(post: BrickPost, author: UserProfile?) {
        avatar.bx_avatar(author?.avatarName)
        name.text = author?.nickname
        time.text = post.createdAt.bx_timeAgo
        body.text = post.body
        image.bx_set(post.imageName)
        commentBtn.setTitle(" \(post.commentCount)", for: .normal)
        commentBtn.setTitleColor(.white, for: .normal)
        likeBtn.setTitle(" \(post.likeCount)", for: .normal)
        likeBtn.setTitleColor(.white, for: .normal)
    }
    @objc private func vTap() { onVideo?() }
    @objc private func cTap() { onComment?() }
    @objc private func lTap() { onLike?() }
    @objc private func rTap() { onReport?() }
}

final class CrewDetailViewController: UIViewController {
    private let crewId: String
    init(crewId: String) {
        self.crewId = crewId
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = BXColor.background
        let crew = CurrentUserSession.shared.crews.first { $0.id == crewId }

        let nav = BXNavBar()
        nav.configure(title: crew?.name ?? "Group", showBack: true, rightImage: "community_alert")
        nav.onBack = { [weak self] in self?.navigationController?.popViewController(animated: true) }
        nav.onRight = { [weak self] in
            BXDialog.show(on: self, message: "Thanks for your report. Our team will review this group.", confirmTitle: "Continue")
        }
        view.addSubview(nav)
        nav.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }

        let scroll = UIScrollView()
        view.addSubview(scroll)
        scroll.snp.makeConstraints {
            $0.top.equalTo(nav.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        let box = UIView()
        scroll.addSubview(box)
        box.snp.makeConstraints {
            $0.edges.equalTo(scroll.contentLayoutGuide)
            $0.width.equalTo(scroll.frameLayoutGuide)
        }

        let cover = UIImageView()
        cover.bx_set(crew?.coverName)
        cover.bx_round(16)
        box.addSubview(cover)
        cover.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(200)
        }
        let about = UILabel()
        about.text = crew?.about
        about.textColor = .white
        about.font = BXFont.body(14)
        about.numberOfLines = 0
        box.addSubview(about)
        about.snp.makeConstraints {
            $0.top.equalTo(cover.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        let members = UILabel()
        members.text = "\(crew?.memberCount ?? 0) members"
        members.textColor = BXColor.textSecondary
        members.font = BXFont.caption(13)
        box.addSubview(members)
        members.snp.makeConstraints {
            $0.top.equalTo(about.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }

        let join = BXPrimaryButton()
        let joined = CurrentUserSession.shared.user?.joinedCrewIds.contains(crewId) == true
        join.setTitle(joined ? "Joined" : "Join · \(BXLayout.coinCost) coins", for: .normal)
        join.isEnabled = !joined
        join.alpha = joined ? 0.5 : 1
        join.addTarget(self, action: #selector(joinTap), for: .touchUpInside)
        box.addSubview(join)
        join.snp.makeConstraints {
            $0.top.equalTo(members.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
            $0.bottom.equalToSuperview().offset(-40)
        }
    }

    @objc private func joinTap() {
        CurrentUserSession.shared.joinCrew(crewId) { [weak self] err in
            guard let self else { return }
            if err == "insufficient" {
                BXDialog.show(on: self, title: "Not enough coins", message: "Joining a group costs \(BXLayout.coinCost) coins.", confirmTitle: "Get Coins", cancelTitle: "Cancel", confirm: {
                    self.bx_push(WalletViewController())
                })
            } else if err == nil {
                BXDialog.show(on: self, message: "Welcome to the group!", confirmTitle: "Continue") {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
