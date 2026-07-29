import UIKit
import SnapKit

final class ProfileViewController: UIViewController {
    private let scroll = UIScrollView()
    private let content = UIView()
    private var skeleton: BXSkeletonOverlay?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = BXColor.background
        scroll.alwaysBounceVertical = true
        view.addSubview(scroll)
        scroll.snp.makeConstraints { $0.edges.equalToSuperview() }
        scroll.addSubview(content)
        content.snp.makeConstraints {
            $0.edges.equalTo(scroll.contentLayoutGuide)
            $0.width.equalTo(scroll.frameLayoutGuide)
        }
        skeleton = BXSkeletonOverlay.attach(to: view, style: .profile)
        BX_NetworkManager.shared.request { _ in
            self.render()
        }
        skeleton?.finish()
        NotificationCenter.default.addObserver(self, selector: #selector(render), name: .bxSessionChanged, object: nil)
    }

    @objc private func render() {
        content.subviews.forEach { $0.removeFromSuperview() }
        guard let me = CurrentUserSession.shared.user else { return }

        let setting = UIButton(type: .custom)
        setting.setImage(UIImage(named: "profile_setting"), for: .normal)
        setting.addTarget(self, action: #selector(settingsTap), for: .touchUpInside)
        content.addSubview(setting)
        setting.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.size.equalTo(32)
        }

        let avatar = UIImageView()
        avatar.bx_avatar(me.avatarName)
        avatar.bx_round(44)
        content.addSubview(avatar)
        avatar.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(16)
            $0.size.equalTo(88)
        }
        let edit = UIButton(type: .custom)
        edit.setImage(UIImage(named: "profile_edit"), for: .normal)
        edit.addTarget(self, action: #selector(editTap), for: .touchUpInside)
        content.addSubview(edit)
        edit.snp.makeConstraints {
            $0.trailing.bottom.equalTo(avatar).offset(2)
            $0.size.equalTo(28)
        }

        let name = UILabel()
        name.text = me.nickname
        name.textColor = .white
        name.font = BXFont.title(22)
        content.addSubview(name)
        name.snp.makeConstraints {
            $0.leading.equalTo(avatar.snp.trailing).offset(14)
            $0.top.equalTo(avatar).offset(10)
            $0.trailing.lessThanOrEqualTo(setting.snp.leading).offset(-8)
        }
        let handle = UILabel()
        handle.text = me.handle
        handle.textColor = BXColor.textSecondary
        handle.font = BXFont.body(13)
        content.addSubview(handle)
        handle.snp.makeConstraints {
            $0.leading.equalTo(name)
            $0.top.equalTo(name.snp.bottom).offset(4)
        }

        let coinBtn = UIButton(type: .custom)
        coinBtn.setBackgroundImage(UIImage(named: "profile_coinBg"), for: .normal)
        coinBtn.addTarget(self, action: #selector(walletTap), for: .touchUpInside)
        content.addSubview(coinBtn)
        coinBtn.snp.makeConstraints {
            $0.top.equalTo(avatar.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(40)
            $0.width.equalTo(180)
        }
        let coinLab = UILabel()
        coinLab.text = "My Coins : \(me.coins)"
        coinLab.textColor = .black
        coinLab.font = BXFont.headline(13)
        coinBtn.addSubview(coinLab)
        coinLab.snp.makeConstraints { $0.center.equalToSuperview() }

        let stats = UIView()
        stats.backgroundColor = BXColor.card
        stats.bx_round(14)
        content.addSubview(stats)
        stats.snp.makeConstraints {
            $0.top.equalTo(coinBtn.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(72)
        }
        let postCount = CurrentUserSession.shared.posts(of: me.id).count
        let items: [(String, String, Int)] = [
            ("\(postCount)", "Post", 0),
            ("\(me.followingCount)", "Following", 1),
            ("\(me.followerCount)", "Follower", 2)
        ]
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stats.addSubview(stack)
        stack.snp.makeConstraints { $0.edges.equalToSuperview() }
        for item in items {
            let box = UIControl()
            box.tag = item.2
            box.addTarget(self, action: #selector(statTap(_:)), for: .touchUpInside)
            let n = UILabel()
            n.text = item.0
            n.textColor = .white
            n.font = BXFont.title(20)
            n.textAlignment = .center
            let l = UILabel()
            l.text = item.1
            l.textColor = BXColor.textSecondary
            l.font = BXFont.caption(12)
            l.textAlignment = .center
            box.addSubview(n)
            box.addSubview(l)
            n.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().offset(14)
            }
            l.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(n.snp.bottom).offset(2)
            }
            stack.addArrangedSubview(box)
        }

        let likeTitle = sectionTitle("My Likes")
        content.addSubview(likeTitle)
        likeTitle.snp.makeConstraints {
            $0.top.equalTo(stats.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        let likedPosts = CurrentUserSession.shared.posts.filter { me.likedPostIds.contains($0.id) }
        let likeScroll = UIScrollView()
        likeScroll.showsHorizontalScrollIndicator = false
        likeScroll.alwaysBounceVertical = false
        likeScroll.clipsToBounds = true
        likeScroll.isDirectionalLockEnabled = true
        content.addSubview(likeScroll)
        likeScroll.snp.makeConstraints {
            $0.top.equalTo(likeTitle.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(205)
        }
        var prev: UIView?
        for p in likedPosts.prefix(8) {
            let card = makeLikeCard(p)
            likeScroll.addSubview(card)
            // Pin height to scroll *frame* (205), not contentLayoutGuide —
            // UIImageView intrinsic size would otherwise inflate contentSize.height.
            card.snp.makeConstraints {
                $0.top.equalTo(likeScroll.contentLayoutGuide.snp.top)
                $0.height.equalTo(likeScroll.frameLayoutGuide.snp.height)
                $0.width.equalTo(155)
                if let prev {
                    $0.leading.equalTo(prev.snp.trailing).offset(10)
                } else {
                    $0.leading.equalTo(likeScroll.contentLayoutGuide.snp.leading).offset(16)
                }
            }
            prev = card
        }
        if let prev {
            prev.snp.makeConstraints { $0.trailing.equalTo(likeScroll.contentLayoutGuide.snp.trailing).offset(-16) }
        }

        let postTitle = sectionTitle("My Post")
        content.addSubview(postTitle)
        postTitle.snp.makeConstraints {
            $0.top.equalTo(likeScroll.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        var anchor = postTitle.snp.bottom
        let myPosts = CurrentUserSession.shared.posts(of: me.id)
        if myPosts.isEmpty {
            let empty = UILabel()
            empty.text = "No posts yet. Share your first build!"
            empty.textColor = BXColor.textSecondary
            empty.font = BXFont.body(13)
            content.addSubview(empty)
            empty.snp.makeConstraints {
                $0.top.equalTo(anchor).offset(12)
                $0.leading.equalToSuperview().offset(16)
            }
            anchor = empty.snp.bottom
        } else {
            for p in myPosts {
                let row = makePostRow(p, author: me)
                content.addSubview(row)
                row.snp.makeConstraints {
                    $0.top.equalTo(anchor).offset(12)
                    $0.leading.trailing.equalToSuperview().inset(16)
                }
                anchor = row.snp.bottom
            }
        }
        let spacer = UIView()
        content.addSubview(spacer)
        spacer.snp.makeConstraints {
            $0.top.equalTo(anchor).offset(40)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(40)
        }
    }

    private func sectionTitle(_ t: String) -> UILabel {
        let l = UILabel()
        l.text = t
        l.textColor = .white
        l.font = BXFont.headline(16)
        return l
    }

    private func makeLikeCard(_ post: BrickPost) -> UIView {
        let v = UIImageView()
        v.bx_set(post.imageName)
        v.bx_round(12)
        v.contentMode = .scaleAspectFill
        v.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeCardTap(_:)))
        v.addGestureRecognizer(tap)
        v.tag = CurrentUserSession.shared.posts.firstIndex(where: { $0.id == post.id }) ?? 0
        objc_setAssociatedObject(v, &Assoc.postId, post.id, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        return v
    }

    private func makePostRow(_ post: BrickPost, author: UserProfile) -> UIView {
        let card = UIView()
        card.backgroundColor = BXColor.card
        card.bx_round(14)
        let av = UIImageView()
        av.bx_avatar(author.avatarName)
        av.bx_round(16)
        let n = UILabel()
        n.text = author.nickname
        n.textColor = .white
        n.font = BXFont.headline(14)
        let t = UILabel()
        t.text = post.createdAt.bx_timeAgo
        t.textColor = BXColor.textSecondary
        t.font = BXFont.caption(12)
        let body = UILabel()
        body.text = post.body
        body.textColor = .white
        body.font = BXFont.body(14)
        body.numberOfLines = 0
        let img = UIImageView()
        img.bx_set(post.imageName)
        img.bx_round(12)
        [av, n, t, body, img].forEach { card.addSubview($0) }
        av.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(12)
            $0.size.equalTo(32)
        }
        n.snp.makeConstraints {
            $0.leading.equalTo(av.snp.trailing).offset(8)
            $0.top.equalTo(av)
        }
        t.snp.makeConstraints {
            $0.leading.equalTo(n)
            $0.top.equalTo(n.snp.bottom).offset(2)
        }
        body.snp.makeConstraints {
            $0.top.equalTo(av.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        img.snp.makeConstraints {
            $0.top.equalTo(body.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(160)
            $0.bottom.equalToSuperview().offset(-12)
        }
        card.isUserInteractionEnabled = true
        objc_setAssociatedObject(card, &Assoc.postId, post.id, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        card.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(postTap(_:))))
        return card
    }

    @objc private func settingsTap() { bx_push(SettingsViewController()) }
    @objc private func editTap() { bx_push(EditProfileViewController()) }
    @objc private func walletTap() { bx_push(WalletViewController()) }
    @objc private func statTap(_ sender: UIControl) {
        guard let me = CurrentUserSession.shared.user else { return }
        switch sender.tag {
        case 1: bx_push(FollowListViewController(userId: me.id, mode: .following))
        case 2: bx_push(FollowListViewController(userId: me.id, mode: .followers))
        default: break
        }
    }
    @objc private func likeCardTap(_ g: UITapGestureRecognizer) {
        guard let v = g.view, let id = objc_getAssociatedObject(v, &Assoc.postId) as? String else { return }
        bx_push(PostDetailViewController(postId: id))
    }
    @objc private func postTap(_ g: UITapGestureRecognizer) {
        guard let v = g.view, let id = objc_getAssociatedObject(v, &Assoc.postId) as? String else { return }
        bx_push(PostDetailViewController(postId: id))
    }
}

private enum Assoc { static var postId = 0 }

final class EditProfileViewController: UIViewController {
    private let avatar = UIImageView()
    private let cameraIcon = UIImageView(image: UIImage(named: "info_camera"))
    private let nameField = BXInputField(placeholder: "Please enter...")
    private var avatarName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = BXColor.background
        let me = CurrentUserSession.shared.user
        avatarName = me?.avatarName

        let nav = BXNavBar()
        nav.configure(title: "Edit Profile", showBack: true)
        nav.onBack = { [weak self] in self?.navigationController?.popViewController(animated: true) }
        view.addSubview(nav)
        nav.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }

        let info = UILabel()
        info.text = "Info"
        info.textColor = .white
        info.font = BXFont.title(32)
        view.addSubview(info)
        info.snp.makeConstraints {
            $0.top.equalTo(nav.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(20)
        }

        let avatarTap = UIControl()
        avatarTap.addTarget(self, action: #selector(pick), for: .touchUpInside)
        view.addSubview(avatarTap)
        avatarTap.snp.makeConstraints {
            $0.top.equalTo(info.snp.bottom).offset(28)
            $0.leading.equalToSuperview().offset(20)
            $0.size.equalTo(100)
        }

        avatar.backgroundColor = BXColor.card
        avatar.contentMode = .scaleAspectFill
        avatar.bx_round(50)
        if let name = me?.avatarName, !name.isEmpty {
            avatar.bx_avatar(name)
        }
        avatarTap.addSubview(avatar)
        avatar.snp.makeConstraints { $0.edges.equalToSuperview() }

        cameraIcon.contentMode = .scaleAspectFit
        avatarTap.addSubview(cameraIcon)
        refreshCameraVisibility()

        let userLab = UILabel()
        userLab.text = "Username"
        userLab.textColor = .white
        userLab.font = BXFont.headline(15)
        view.addSubview(userLab)
        userLab.snp.makeConstraints {
            $0.top.equalTo(avatarTap.snp.bottom).offset(28)
            $0.leading.equalToSuperview().offset(20)
        }

        nameField.textField.text = me?.nickname
        nameField.textField.returnKeyType = .done
        view.addSubview(nameField)
        nameField.snp.makeConstraints {
            $0.top.equalTo(userLab.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        let save = UIButton(type: .custom)
        if let img = UIImage(named: "edit_save") {
            save.setBackgroundImage(img, for: .normal)
        } else {
            save.setTitle("Save", for: .normal)
            save.setTitleColor(.black, for: .normal)
            save.titleLabel?.font = BXFont.headline(16)
            save.backgroundColor = BXColor.accent
            save.bx_round(26)
        }
        save.addTarget(self, action: #selector(saveTap), for: .touchUpInside)
        view.addSubview(save)
        save.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            $0.height.equalTo(52)
        }
    }

    private func refreshCameraVisibility() {
        if avatar.image != nil {
            cameraIcon.snp.remakeConstraints {
                $0.trailing.bottom.equalToSuperview().offset(2)
                $0.size.equalTo(32)
            }
        } else {
            cameraIcon.snp.remakeConstraints {
                $0.center.equalToSuperview()
                $0.size.equalTo(36)
            }
        }
    }

    @objc private func pick() {
        MediaPickerHelper.present(from: self) { [weak self] image in
            guard let self, let image else { return }
            self.avatar.image = image
            self.avatarName = MediaPickerHelper.saveImage(image)
            self.refreshCameraVisibility()
        }
    }

    @objc private func saveTap() {
        let nick = nameField.text
        guard !nick.isEmpty else {
            BXDialog.show(on: self, message: "Username cannot be empty.", confirmTitle: "Continue")
            return
        }
        CurrentUserSession.shared.updateProfile {
            $0.nickname = nick
            $0.handle = nick
            if let avatarName { $0.avatarName = avatarName }
        }
        BX_NetworkManager.shared.request { _ in
            self.navigationController?.popViewController(animated: true)
        }
    }
}

final class FollowListViewController: UIViewController {
    enum Mode { case following, followers, friends }
    private let userId: String
    private let mode: Mode
    private var users: [UserProfile] = []
    private let table = UITableView(frame: .zero, style: .plain)

    init(userId: String, mode: Mode) {
        self.userId = userId
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = BXColor.background
        let titles: [Mode: String] = [.following: "Following", .followers: "Follower", .friends: "Friends"]
        let nav = BXNavBar()
        nav.configure(title: titles[mode], showBack: true)
        nav.onBack = { [weak self] in self?.navigationController?.popViewController(animated: true) }
        view.addSubview(nav)
        nav.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.dataSource = self
        table.delegate = self
        table.register(FollowCell.self, forCellReuseIdentifier: "c")
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.top.equalTo(nav.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        let sk = BXSkeletonOverlay.attach(to: view, style: .list)
        BX_NetworkManager.shared.request { _ in
            self.reload()
        }
        sk.finish()
    }

    private func reload() {
        guard let u = CurrentUserSession.shared.user(by: userId) else { return }
        let ids: [String]
        switch mode {
        case .following: ids = u.followingIds
        case .followers: ids = u.followerIds
        case .friends: ids = u.friendIds
        }
        users = ids.compactMap { CurrentUserSession.shared.user(by: $0) }
        table.reloadData()
    }
}

extension FollowListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { users.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "c", for: indexPath) as! FollowCell
        cell.bind(users[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 72 }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        bx_push(UserHomeViewController(userId: users[indexPath.row].id))
    }
}

final class FollowCell: UITableViewCell {
    private let avatar = UIImageView()
    private let name = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        let card = UIView()
        card.backgroundColor = BXColor.card
        card.bx_round(12)
        contentView.addSubview(card)
        card.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16))
        }
        avatar.bx_round(22)
        name.textColor = .white
        name.font = BXFont.headline(15)
        card.addSubview(avatar)
        card.addSubview(name)
        avatar.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(44)
        }
        name.snp.makeConstraints {
            $0.leading.equalTo(avatar.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) { fatalError() }
    func bind(_ u: UserProfile) {
        avatar.bx_avatar(u.avatarName)
        name.text = u.nickname
    }
}
