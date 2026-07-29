import UIKit
import SnapKit

final class UserHomeViewController: UIViewController {
    private let userId: String
    private let scroll = UIScrollView()
    private let content = UIView()
    private let chatBtn = UIButton(type: .custom)
    private let followBtn = UIButton(type: .custom)

    init(userId: String) {
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = BXColor.background

        let nav = BXNavBar()
        let isSelf = userId == CurrentUserSession.shared.user?.id
        nav.configure(title: nil, showBack: true, rightImage: isSelf ? nil : "community_alert")
        nav.onBack = { [weak self] in self?.navigationController?.popViewController(animated: true) }
        nav.onRight = { [weak self] in
            guard let self, self.userId != CurrentUserSession.shared.user?.id else { return }
            ReportBlockPresenter.present(from: self, targetId: self.userId)
        }
        view.addSubview(nav)
        // Keep nav fixed above scroll
        nav.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }

        scroll.alwaysBounceVertical = true
        view.addSubview(scroll)
        scroll.snp.makeConstraints {
            $0.top.equalTo(nav.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        scroll.addSubview(content)
        content.snp.makeConstraints {
            $0.edges.equalTo(scroll.contentLayoutGuide)
            $0.width.equalTo(scroll.frameLayoutGuide)
        }

        let sk = BXSkeletonOverlay.attach(to: view, style: .profile)
        render()
        sk.finish()
        NotificationCenter.default.addObserver(self, selector: #selector(render), name: .bxSessionChanged, object: nil)
    }

    @objc private func render() {
        content.subviews.forEach { $0.removeFromSuperview() }
        guard let user = CurrentUserSession.shared.user(by: userId) else { return }
        let me = CurrentUserSession.shared.user
        let isSelf = me?.id == userId

        let hero = UIImageView()
        hero.bx_avatar(user.avatarName)
        hero.contentMode = .scaleAspectFill
        content.addSubview(hero)
        hero.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(320)
        }

        if !isSelf {
            chatBtn.setImage(UIImage(named: "user_chat"), for: .normal)
            let mutual = CurrentUserSession.shared.isMutual(with: userId)
            chatBtn.alpha = mutual ? 1.0 : 0.45
            chatBtn.addTarget(self, action: #selector(chatTap), for: .touchUpInside)
            content.addSubview(chatBtn)
            let video = UIButton(type: .custom)
            video.setImage(UIImage(named: "user_video"), for: .normal)
            video.alpha = mutual ? 1.0 : 0.45
            video.addTarget(self, action: #selector(videoTap), for: .touchUpInside)
            content.addSubview(video)
            video.snp.makeConstraints {
                $0.trailing.equalToSuperview().offset(-16)
                $0.bottom.equalTo(hero.snp.bottom).offset(-16)
                $0.size.equalTo(48)
            }
            chatBtn.snp.makeConstraints {
                $0.trailing.equalTo(video.snp.leading).offset(-12)
                $0.centerY.equalTo(video)
                $0.size.equalTo(48)
            }
        }

        let nameRow = UIStackView()
        nameRow.axis = .horizontal
        nameRow.spacing = 8
        nameRow.alignment = .center
        let name = UILabel()
        name.text = user.nickname
        name.textColor = .white
        name.font = BXFont.title(24)
        nameRow.addArrangedSubview(name)
        if !isSelf {
            let following = CurrentUserSession.shared.isFollowing(userId)
            followBtn.setImage(UIImage(named: following ? "user_followed" : "user_follow"), for: .normal)
            followBtn.addTarget(self, action: #selector(followTap), for: .touchUpInside)
            followBtn.snp.makeConstraints { $0.size.equalTo(28) }
            nameRow.addArrangedSubview(followBtn)
        }
        content.addSubview(nameRow)
        nameRow.snp.makeConstraints {
            $0.top.equalTo(hero.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }

        let title = UILabel()
        title.text = user.title
        title.textColor = BXColor.textSecondary
        title.font = BXFont.body(13)
        content.addSubview(title)
        title.snp.makeConstraints {
            $0.top.equalTo(nameRow.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(16)
        }
        let bio = UILabel()
        bio.text = user.bio
        bio.textColor = .white
        bio.font = BXFont.body(14)
        bio.numberOfLines = 0
        content.addSubview(bio)
        bio.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        let stats = UIStackView()
        stats.axis = .horizontal
        stats.distribution = .fillEqually
        content.addSubview(stats)
        stats.snp.makeConstraints {
            $0.top.equalTo(bio.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(54)
        }
        let postCount = CurrentUserSession.shared.posts(of: userId).count
        [("\(postCount)", "Post", 0), ("\(user.followingCount)", "Following", 1), ("\(user.followerCount)", "Follower", 2)].forEach { item in
            let box = UIControl()
            box.tag = item.2
            box.addTarget(self, action: #selector(statTap(_:)), for: .touchUpInside)
            let n = UILabel()
            n.text = item.0
            n.textAlignment = .center
            n.textColor = .white
            n.font = BXFont.title(18)
            let l = UILabel()
            l.text = item.1
            l.textAlignment = .center
            l.textColor = BXColor.textSecondary
            l.font = BXFont.caption(12)
            box.addSubview(n)
            box.addSubview(l)
            n.snp.makeConstraints { $0.top.centerX.equalToSuperview() }
            l.snp.makeConstraints { $0.top.equalTo(n.snp.bottom).offset(2); $0.centerX.equalToSuperview() }
            stats.addArrangedSubview(box)
        }

        let section = UILabel()
        section.text = "My Post"
        section.textColor = .white
        section.font = BXFont.headline(16)
        content.addSubview(section)
        section.snp.makeConstraints {
            $0.top.equalTo(stats.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }

        var anchor = section.snp.bottom
        for p in CurrentUserSession.shared.posts(of: userId) {
            let card = UIView()
            card.backgroundColor = BXColor.card
            card.bx_round(14)
            content.addSubview(card)
            card.snp.makeConstraints {
                $0.top.equalTo(anchor).offset(12)
                $0.leading.trailing.equalToSuperview().inset(16)
            }
            let av = UIImageView()
            av.bx_avatar(user.avatarName)
            av.bx_round(16)
            let n = UILabel()
            n.text = user.nickname
            n.textColor = .white
            n.font = BXFont.headline(14)
            let t = UILabel()
            t.text = p.createdAt.bx_timeAgo
            t.textColor = BXColor.textSecondary
            t.font = BXFont.caption(12)
            let body = UILabel()
            body.text = p.body
            body.textColor = .white
            body.font = BXFont.body(14)
            body.numberOfLines = 0
            let img = UIImageView()
            img.bx_set(p.imageName)
            img.bx_round(12)
            [av, n, t, body, img].forEach { card.addSubview($0) }
            av.snp.makeConstraints { $0.top.leading.equalToSuperview().inset(12); $0.size.equalTo(32) }
            n.snp.makeConstraints { $0.leading.equalTo(av.snp.trailing).offset(8); $0.top.equalTo(av) }
            t.snp.makeConstraints { $0.leading.equalTo(n); $0.top.equalTo(n.snp.bottom).offset(2) }
            body.snp.makeConstraints { $0.top.equalTo(av.snp.bottom).offset(10); $0.leading.trailing.equalToSuperview().inset(12) }
            img.snp.makeConstraints {
                $0.top.equalTo(body.snp.bottom).offset(10)
                $0.leading.trailing.equalToSuperview().inset(12)
                $0.height.equalTo(180)
                $0.bottom.equalToSuperview().offset(-12)
            }
            card.isUserInteractionEnabled = true
            card.tag = 0
            objc_setAssociatedObject(card, &UHAssoc.postId, p.id, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            card.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openPost(_:))))
            anchor = card.snp.bottom
        }
        let spacer = UIView()
        content.addSubview(spacer)
        spacer.snp.makeConstraints {
            $0.top.equalTo(anchor).offset(40)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(20)
        }
    }

    @objc private func followTap() {
        CurrentUserSession.shared.toggleFollow(targetId: userId) { [weak self] _ in self?.render() }
    }

    @objc private func chatTap() {
        guard CurrentUserSession.shared.isMutual(with: userId) else {
            BXDialog.show(on: self, title: "Follow each other first", message: "Chat unlocks when you and this builder follow each other.", confirmTitle: "Continue")
            return
        }
        let t = CurrentUserSession.shared.openOrCreateThread(peerId: userId)
        bx_push(ChatViewController(threadId: t.id, peerId: userId))
    }

    @objc private func videoTap() {
        guard CurrentUserSession.shared.isMutual(with: userId) else {
            BXDialog.show(on: self, title: "Follow each other first", message: "Video call unlocks when you both follow each other.", confirmTitle: "Continue")
            return
        }
        MediaPickerHelper.ensureAVPermissions(from: self) { [weak self] ok in
            guard let self, ok else { return }
            self.bx_push(VideoCallViewController(peerId: self.userId))
        }
    }

    @objc private func statTap(_ sender: UIControl) {
        switch sender.tag {
        case 1: bx_push(FollowListViewController(userId: userId, mode: .following))
        case 2: bx_push(FollowListViewController(userId: userId, mode: .followers))
        default: break
        }
    }

    @objc private func openPost(_ g: UITapGestureRecognizer) {
        guard let v = g.view, let id = objc_getAssociatedObject(v, &UHAssoc.postId) as? String else { return }
        bx_push(PostDetailViewController(postId: id))
    }
}

private enum UHAssoc { static var postId = 0 }
