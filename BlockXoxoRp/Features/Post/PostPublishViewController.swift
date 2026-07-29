import UIKit
import SnapKit

final class PostDetailViewController: UIViewController {
    private let postId: String
    private var post: BrickPost?
    private var commentItems: [PostComment] = []

    private let nav = BXNavBar()
    private let scroll = UIScrollView()
    private let content = UIView()
    private let inputBar = UIView()
    private let commentField = UITextField()
    private let sendButton = UIButton(type: .custom)
    private var likeButton: UIButton?
    private var skeleton: BXSkeletonOverlay?
    private var sessionObserver: NSObjectProtocol?

    init(postId: String) {
        self.postId = postId
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    deinit {
        if let sessionObserver {
            NotificationCenter.default.removeObserver(sessionObserver)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = BXColor.background
        setupNav()
        setupScroll()
        setupInputBar()
        skeleton = BXSkeletonOverlay.attach(to: view, style: .feed)
        reload()
        skeleton?.finish()
        sessionObserver = NotificationCenter.default.addObserver(
            forName: .bxSessionChanged,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.handleSessionChange()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Ensure reported / deleted comments disappear when returning from report page.
        reload()
    }

    private func handleSessionChange() {
        if CurrentUserSession.shared.isPostHidden(postId)
            || CurrentUserSession.shared.posts.first(where: { $0.id == postId }) == nil {
            navigationController?.popViewController(animated: true)
            return
        }
        reload()
    }

    /// Called by report flow after hiding a comment so UI updates immediately.
    func refreshAfterContentChange() {
        reload()
    }

    private func setupNav() {
        nav.configure(title: nil, showBack: true, rightImage: "community_alert")
        nav.onBack = { [weak self] in self?.navigationController?.popViewController(animated: true) }
        nav.onRight = { [weak self] in
            guard let self else { return }
            ReportBlockPresenter.present(from: self, target: .post(self.postId))
        }
        view.addSubview(nav)
        nav.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }
    }

    private func setupScroll() {
        scroll.alwaysBounceVertical = true
        scroll.showsVerticalScrollIndicator = false
        scroll.keyboardDismissMode = .onDrag
        view.addSubview(scroll)
        scroll.snp.makeConstraints {
            $0.top.equalTo(nav.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
        }
        scroll.addSubview(content)
        content.snp.makeConstraints {
            $0.edges.equalTo(scroll.contentLayoutGuide)
            $0.width.equalTo(scroll.frameLayoutGuide)
        }
    }

    private func setupInputBar() {
        inputBar.backgroundColor = BXColor.background
        view.addSubview(inputBar)
        inputBar.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
        }

        let fieldWrap = UIView()
        fieldWrap.backgroundColor = BXColor.input
        fieldWrap.bx_round(22)
        inputBar.addSubview(fieldWrap)
        fieldWrap.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(44)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-8)
        }

        commentField.textColor = .white
        commentField.font = BXFont.body(14)
        commentField.returnKeyType = .send
        commentField.delegate = self
        commentField.attributedPlaceholder = NSAttributedString(
            string: "Please enter...",
            attributes: [.foregroundColor: BXColor.textSecondary]
        )
        fieldWrap.addSubview(commentField)
        sendButton.setImage(UIImage(named: "chat_send"), for: .normal)
        sendButton.addTarget(self, action: #selector(sendComment), for: .touchUpInside)
        fieldWrap.addSubview(sendButton)

        commentField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(14)
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalTo(sendButton.snp.leading).offset(-8)
        }
        sendButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(28)
        }
    }

    private func reload() {
        content.subviews.forEach { $0.removeFromSuperview() }
        likeButton = nil
        post = CurrentUserSession.shared.posts.first { $0.id == postId }
        commentItems = CurrentUserSession.shared.comments(for: postId)
        guard let post else { return }
        let author = CurrentUserSession.shared.user(by: post.authorId)

        // Hero image
        let image = UIImageView()
        image.bx_set(post.imageName)
        image.bx_round(22)
        image.isUserInteractionEnabled = true
        content.addSubview(image)
        image.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(image.snp.width).multipliedBy(1.05)
        }

        let like = UIButton(type: .custom)
        let liked = post.likedBy.contains(CurrentUserSession.shared.user?.id ?? "")
        like.setImage(UIImage(named: liked ? "home_liked" : "home_like"), for: .normal)
        like.addTarget(self, action: #selector(likeTap), for: .touchUpInside)
        image.addSubview(like)
        likeButton = like

        let comment = UIButton(type: .custom)
        comment.setImage(UIImage(named: "home_commit"), for: .normal)
        comment.addTarget(self, action: #selector(focusComment), for: .touchUpInside)
        image.addSubview(comment)

        like.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-14)
            $0.bottom.equalToSuperview().offset(-16)
            $0.size.equalTo(40)
        }
        comment.snp.makeConstraints {
            $0.trailing.equalTo(like.snp.leading).offset(-12)
            $0.centerY.equalTo(like)
            $0.size.equalTo(40)
        }

        // Author
        let avatar = UIImageView()
        avatar.bx_avatar(author?.avatarName)
        avatar.bx_round(22)
        avatar.isUserInteractionEnabled = true
        avatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openAuthor)))
        content.addSubview(avatar)
        avatar.snp.makeConstraints {
            $0.top.equalTo(image.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.size.equalTo(44)
        }

        let name = UILabel()
        name.text = author?.nickname
        name.textColor = .white
        name.font = BXFont.headline(16)
        content.addSubview(name)
        name.snp.makeConstraints {
            $0.leading.equalTo(avatar.snp.trailing).offset(10)
            $0.top.equalTo(avatar).offset(2)
            $0.trailing.lessThanOrEqualToSuperview().offset(-16)
        }

        let subtitle = UILabel()
        subtitle.text = post.title
        subtitle.textColor = UIColor(white: 0.92, alpha: 1)
        subtitle.font = BXFont.body(13)
        content.addSubview(subtitle)
        subtitle.snp.makeConstraints {
            $0.leading.equalTo(name)
            $0.top.equalTo(name.snp.bottom).offset(2)
            $0.trailing.lessThanOrEqualToSuperview().offset(-16)
        }

        let body = UILabel()
        body.text = post.body
        body.textColor = .white
        body.font = BXFont.body(15)
        body.numberOfLines = 0
        content.addSubview(body)
        body.snp.makeConstraints {
            $0.top.equalTo(avatar.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        var anchor = body.snp.bottom
        for (idx, c) in commentItems.enumerated() {
            let row = makeCommentRow(c)
            content.addSubview(row)
            row.snp.makeConstraints {
                $0.top.equalTo(anchor).offset(idx == 0 ? 22 : 16)
                $0.leading.trailing.equalToSuperview().inset(16)
            }
            anchor = row.snp.bottom
        }

        let spacer = UIView()
        content.addSubview(spacer)
        spacer.snp.makeConstraints {
            $0.top.equalTo(anchor).offset(24)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(16)
        }
    }

    private func makeCommentRow(_ c: PostComment) -> UIView {
        let box = UIView()
        let u = CurrentUserSession.shared.user(by: c.authorId)

        let av = UIImageView()
        av.bx_avatar(u?.avatarName)
        av.bx_round(22)
        av.isUserInteractionEnabled = true
        objc_setAssociatedObject(av, &DetailAssoc.authorId, c.authorId, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        av.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openCommentAuthor(_:))))
        box.addSubview(av)
        av.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
            $0.size.equalTo(44)
            $0.bottom.lessThanOrEqualToSuperview()
        }

        let report = UIButton(type: .custom)
        report.setImage(UIImage(named: "community_alert"), for: .normal)
        report.addTarget(self, action: #selector(reportComment(_:)), for: .touchUpInside)
        objc_setAssociatedObject(report, &DetailAssoc.commentId, c.id, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        box.addSubview(report)
        report.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.top.equalTo(av).offset(4)
            $0.size.equalTo(28)
        }

        let n = UILabel()
        n.text = u?.nickname
        n.textColor = .white
        n.font = BXFont.headline(15)
        box.addSubview(n)
        n.snp.makeConstraints {
            $0.leading.equalTo(av.snp.trailing).offset(10)
            $0.top.equalTo(av).offset(2)
            $0.trailing.lessThanOrEqualTo(report.snp.leading).offset(-8)
        }

        let t = UILabel()
        t.text = c.body
        t.textColor = UIColor(white: 0.9, alpha: 1)
        t.font = BXFont.body(13)
        t.numberOfLines = 0
        box.addSubview(t)
        t.snp.makeConstraints {
            $0.leading.equalTo(n)
            $0.top.equalTo(n.snp.bottom).offset(2)
            $0.trailing.equalTo(report.snp.leading).offset(-8)
            $0.bottom.equalToSuperview()
        }
        return box
    }

    @objc private func likeTap() {
        CurrentUserSession.shared.toggleLike(postId: postId) { [weak self] _ in
            guard let self else { return }
            // Update like icon without full rebuild when possible
            if let post = CurrentUserSession.shared.posts.first(where: { $0.id == self.postId }) {
                let liked = post.likedBy.contains(CurrentUserSession.shared.user?.id ?? "")
                self.likeButton?.setImage(UIImage(named: liked ? "home_liked" : "home_like"), for: .normal)
                self.post = post
            } else {
                self.reload()
            }
        }
    }

    @objc private func focusComment() {
        commentField.becomeFirstResponder()
    }

    @objc private func sendComment() {
        let text = commentField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !text.isEmpty else { return }
        CurrentUserSession.shared.addComment(postId: postId, text: text) { [weak self] ok in
            guard let self, ok else { return }
            self.commentField.text = nil
            self.commentField.resignFirstResponder()
            self.reload()
        }
    }

    @objc private func openAuthor() {
        guard let id = post?.authorId else { return }
        bx_push(UserHomeViewController(userId: id))
    }

    @objc private func openCommentAuthor(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view,
              let authorId = objc_getAssociatedObject(view, &DetailAssoc.authorId) as? String else { return }
        bx_push(UserHomeViewController(userId: authorId))
    }

    @objc private func reportComment(_ sender: UIButton) {
        guard let commentId = objc_getAssociatedObject(sender, &DetailAssoc.commentId) as? String else { return }
        ReportBlockPresenter.present(from: self, target: .comment(commentId))
    }
}

private enum DetailAssoc {
    static var commentId = 0
    static var authorId = 1
}

extension PostDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendComment()
        return true
    }
}

final class PublishViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let imageBox = UIImageView()
    private let textView = UITextView()
    private var imageName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = BXColor.background

        let nav = BXNavBar()
        nav.configure(title: nil, showBack: true)
        nav.onBack = { [weak self] in self?.navigationController?.popViewController(animated: true) }
        view.addSubview(nav)
        nav.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }

        let title = UILabel()
        title.text = "Post"
        title.font = BXFont.title(30)
        title.textColor = .white
        view.addSubview(title)
        title.snp.makeConstraints {
            $0.top.equalTo(nav.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }

        let scroll = UIScrollView()
        view.addSubview(scroll)
        scroll.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-80)
        }
        let box = UIView()
        scroll.addSubview(box)
        box.snp.makeConstraints {
            $0.edges.equalTo(scroll.contentLayoutGuide)
            $0.width.equalTo(scroll.frameLayoutGuide)
        }

        imageBox.backgroundColor = BXColor.card
        imageBox.bx_round(16)
        imageBox.contentMode = .scaleAspectFill
        imageBox.isUserInteractionEnabled = true
        imageBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickImage)))
        let cam = UIImageView(image: UIImage(named: "post_camera"))
        imageBox.addSubview(cam)
        cam.snp.makeConstraints { $0.center.equalToSuperview(); $0.size.equalTo(36) }
        box.addSubview(imageBox)
        imageBox.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(220)
        }

        let lab = UILabel()
        lab.text = "Describe"
        lab.textColor = .white
        lab.font = BXFont.body(14)
        box.addSubview(lab)
        lab.snp.makeConstraints {
            $0.top.equalTo(imageBox.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        textView.backgroundColor = BXColor.input
        textView.textColor = .white
        textView.font = BXFont.body(15)
        textView.bx_round(14)
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)
        box.addSubview(textView)
        textView.snp.makeConstraints {
            $0.top.equalTo(lab.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(140)
            $0.bottom.equalToSuperview().offset(-20)
        }

        let postBtn = UIButton(type: .custom)
        postBtn.backgroundColor = BXColor.accent
        postBtn.bx_round(26)
        postBtn.addTarget(self, action: #selector(postTap), for: .touchUpInside)
        view.addSubview(postBtn)
        postBtn.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12)
            $0.height.equalTo(56)
        }
        let postTitle = UILabel()
        postTitle.text = "Post"
        postTitle.font = BXFont.headline(16)
        postTitle.textColor = .black
        postBtn.addSubview(postTitle)
        let coin = UIImageView(image: UIImage(named: "post_coin"))
        postBtn.addSubview(coin)
        postTitle.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview().offset(-16)
        }
        coin.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(postTitle.snp.trailing).offset(8)
            $0.size.equalTo(24)
        }
    }

    @objc private func pickImage() {
        MediaPickerHelper.present(from: self) { [weak self] image in
            guard let self, let image else { return }
            self.imageBox.subviews.forEach { $0.removeFromSuperview() }
            self.imageBox.image = image
            self.imageName = MediaPickerHelper.saveImage(image)
        }
    }

    @objc private func postTap() {
        let body = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !body.isEmpty else {
            BXDialog.show(on: self, message: "Please describe your build.", confirmTitle: "Continue")
            return
        }
        let img = imageName ?? "post_10"
        
        BX_NetworkManager.shared.request { _ in
            CurrentUserSession.shared.publishPost(body: body, imageName: img, tag: "#Build") { [weak self] err in
                guard let self else { return }
                if err == "insufficient" {
                    BXDialog.show(on: self, title: "Not enough coins", message: "Publishing costs \(BXLayout.coinCost) coins. Get more coins to continue.", confirmTitle: "Get Coins", cancelTitle: "Cancel", confirm: {
                        self.bx_push(WalletViewController())
                    })
                } else if let err {
                    BXDialog.show(on: self, message: err, confirmTitle: "Continue")
                } else {
                    BXDialog.show(on: self, message: "Your build is live!", confirmTitle: "Continue") {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }        
    }
}
