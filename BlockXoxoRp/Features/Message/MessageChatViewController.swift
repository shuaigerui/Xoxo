import UIKit
import SnapKit

final class MessageListViewController: UIViewController {
    private let table = UITableView(frame: .zero, style: .plain)
    private var threads: [ChatThread] = []
    private let empty = BXEmptyView()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = BXColor.background

        let back = UIButton(type: .custom)
        back.setImage(UIImage(named: "common_back"), for: .normal)
        back.addTarget(self, action: #selector(backTap), for: .touchUpInside)
        view.addSubview(back)
        back.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.leading.equalToSuperview().offset(12)
            $0.size.equalTo(36)
        }

        let title = UILabel()
        title.text = "Chat"
        title.font = BXFont.title(30)
        title.textColor = .white
        view.addSubview(title)
        title.snp.makeConstraints {
            $0.centerY.equalTo(back)
            $0.leading.equalTo(back.snp.trailing).offset(4)
        }

        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.dataSource = self
        table.delegate = self
        table.register(ThreadCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        view.addSubview(empty)
        empty.snp.makeConstraints { $0.edges.equalTo(table) }
        let sk = BXSkeletonOverlay.attach(to: view, style: .list)
        BX_NetworkManager.shared.request { _ in
            self.reload()
        }
        sk.finish()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: .bxSessionChanged, object: nil)
    }

    @objc private func backTap() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func reload() {
        threads = CurrentUserSession.shared.visibleThreads()
        empty.isHidden = !threads.isEmpty
        table.reloadData()
    }
}

extension MessageListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { threads.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ThreadCell
        let t = threads[indexPath.row]
        cell.bind(thread: t, peer: CurrentUserSession.shared.user(by: t.peerId))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 88 }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let t = threads[indexPath.row]
        CurrentUserSession.shared.markThreadRead(t.id)
        bx_push(ChatViewController(threadId: t.id, peerId: t.peerId))
    }
}

final class ThreadCell: UITableViewCell {
    private let card = UIView()
    private let avatar = UIImageView()
    private let name = UILabel()
    private let sub = UILabel()
    private let time = UILabel()
    private let badge = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        card.backgroundColor = .clear
        card.layer.borderWidth = 1.5
        card.layer.borderColor = BXColor.border.cgColor
        card.bx_round(14)
        contentView.addSubview(card)
        card.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16))
        }
        avatar.bx_round(12)
        name.textColor = .white
        name.font = BXFont.headline(15)
        sub.textColor = BXColor.textSecondary
        sub.font = BXFont.caption(12)
        time.textColor = BXColor.textSecondary
        time.font = BXFont.caption(11)
        badge.backgroundColor = BXColor.accent
        badge.textColor = .black
        badge.font = BXFont.caption(10)
        badge.textAlignment = .center
        badge.bx_round(9)
        [avatar, name, sub, time, badge].forEach { card.addSubview($0) }
        avatar.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(48)
        }
        name.snp.makeConstraints {
            $0.leading.equalTo(avatar.snp.trailing).offset(10)
            $0.top.equalTo(avatar).offset(4)
            $0.trailing.lessThanOrEqualTo(time.snp.leading).offset(-8)
        }
        sub.snp.makeConstraints {
            $0.leading.equalTo(name)
            $0.top.equalTo(name.snp.bottom).offset(4)
            $0.trailing.lessThanOrEqualToSuperview().offset(-50)
        }
        time.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-12)
            $0.top.equalToSuperview().offset(14)
        }
        badge.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-12)
            $0.bottom.equalToSuperview().offset(-12)
            $0.height.equalTo(18)
            $0.width.greaterThanOrEqualTo(18)
        }
    }
    required init?(coder: NSCoder) { fatalError() }
    func bind(thread: ChatThread, peer: UserProfile?) {
        avatar.bx_avatar(peer?.avatarName)
        name.text = peer?.nickname
        sub.text = thread.lastText.isEmpty ? thread.subtitle : thread.lastText
        time.text = Date(timeIntervalSince1970: thread.updatedAt).bx_hm
        badge.isHidden = thread.unread <= 0
        badge.text = " \(thread.unread) "
    }
}

final class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let threadId: String
    private let peerId: String
    private var items: [ChatBubble] = []
    private let table = UITableView(frame: .zero, style: .plain)
    private let input = UITextField()

    init(threadId: String, peerId: String) {
        self.threadId = threadId
        self.peerId = peerId
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = BXColor.background
        let peer = CurrentUserSession.shared.user(by: peerId)

        let nav = BXNavBar()
        nav.configure(title: peer?.nickname, showBack: true, rightImage: "chat_alert")
        nav.onBack = { [weak self] in self?.navigationController?.popViewController(animated: true) }
        nav.onRight = { [weak self] in
            guard let self else { return }
            ReportBlockPresenter.present(from: self, targetId: self.peerId)
        }
        view.addSubview(nav)
        nav.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }

        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.dataSource = self
        table.delegate = self
        table.register(BubbleCell.self, forCellReuseIdentifier: "b")
        table.transform = CGAffineTransform(scaleX: 1, y: -1)
        view.addSubview(table)

        let video = UIButton(type: .custom)
        video.setImage(UIImage(named: "chat_video"), for: .normal)
        video.addTarget(self, action: #selector(videoTap), for: .touchUpInside)
        view.addSubview(video)

        let bar = UIView()
        bar.backgroundColor = BXColor.card
        view.addSubview(bar)
        input.backgroundColor = BXColor.input
        input.textColor = .white
        input.font = BXFont.body(14)
        input.bx_round(18)
        input.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 1))
        input.leftViewMode = .always
        input.attributedPlaceholder = NSAttributedString(string: "Please enter...", attributes: [.foregroundColor: BXColor.textSecondary])
        bar.addSubview(input)
        let send = UIButton(type: .custom)
        send.setImage(UIImage(named: "chat_send"), for: .normal)
        send.addTarget(self, action: #selector(sendTap), for: .touchUpInside)
        bar.addSubview(send)

        bar.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-56)
        }
        input.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalTo(send.snp.leading).offset(-8)
            $0.centerY.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-28)
            $0.height.equalTo(40)
        }
        send.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-12)
            $0.centerY.equalTo(input)
            $0.size.equalTo(32)
        }
        video.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(bar.snp.top).offset(-10)
            $0.height.equalTo(40)
            $0.width.equalTo(140)
        }
        table.snp.makeConstraints {
            $0.top.equalTo(nav.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(video.snp.top).offset(-8)
        }
        reload()
    }

    private func reload() {
        items = CurrentUserSession.shared.bubbles(in: threadId).reversed()
        table.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { items.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "b", for: indexPath) as! BubbleCell
        let b = items[indexPath.row]
        let mine = b.senderId == CurrentUserSession.shared.user?.id
        cell.bind(text: b.text, mine: mine)
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }

    @objc private func sendTap() {
        let text = input.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !text.isEmpty else { return }
        
        BX_NetworkManager.shared.request(isShow: false) { _ in

        }
        
        CurrentUserSession.shared.sendMessage(threadId: threadId, text: text) { [weak self] ok in
            if ok {
                self?.input.text = nil
                self?.reload()
            }
        }
    }

    @objc private func videoTap() {
        MediaPickerHelper.ensureAVPermissions(from: self) { [weak self] ok in
            guard let self, ok else { return }
            self.bx_push(VideoCallViewController(peerId: self.peerId))
        }
    }
}

final class BubbleCell: UITableViewCell {
    private let bubble = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        bubble.numberOfLines = 0
        bubble.font = BXFont.body(14)
        bubble.bx_round(14)
        contentView.addSubview(bubble)
    }
    required init?(coder: NSCoder) { fatalError() }
    func bind(text: String, mine: Bool) {
        bubble.text = "  \(text)  "
        bubble.textColor = .white
        bubble.backgroundColor = mine ? BXColor.purpleBubble : BXColor.card
        bubble.snp.remakeConstraints {
            $0.top.bottom.equalToSuperview().inset(6)
            $0.width.lessThanOrEqualToSuperview().multipliedBy(0.72)
            if mine {
                $0.trailing.equalToSuperview().offset(-16)
            } else {
                $0.leading.equalToSuperview().offset(16)
            }
        }
    }
}

final class VideoCallViewController: UIViewController {
    private let peerId: String
    private var micOn = true
    private var camOn = true
    private var speakerOn = true

    init(peerId: String) {
        self.peerId = peerId
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        BX_NetworkManager.shared.request(isShow: false) { _ in

        }
        
        let peer = CurrentUserSession.shared.user(by: peerId)
        let bg = UIImageView()
        bg.bx_avatar(peer?.avatarName)
        bg.contentMode = .scaleAspectFill
        view.addSubview(bg)
        bg.snp.makeConstraints { $0.edges.equalToSuperview() }
        let dim = UIView()
        dim.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        view.addSubview(dim)
        dim.snp.makeConstraints { $0.edges.equalToSuperview() }

        let name = UILabel()
        name.text = peer?.nickname
        name.textColor = .white
        name.font = BXFont.title(24)
        view.addSubview(name)
        name.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
        }
        let status = UILabel()
        status.text = "Connecting..."
        status.textColor = BXColor.textSecondary
        status.font = BXFont.body(14)
        view.addSubview(status)
        status.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(name.snp.bottom).offset(8)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            status.text = "Connected"
        }

        let hang = UIButton(type: .system)
        hang.setTitle("End", for: .normal)
        hang.backgroundColor = BXColor.danger
        hang.setTitleColor(.white, for: .normal)
        hang.bx_round(28)
        hang.addTarget(self, action: #selector(endTap), for: .touchUpInside)
        view.addSubview(hang)
        hang.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
            $0.size.equalTo(CGSize(width: 72, height: 56))
        }

        let mic = UIButton(type: .custom)
        mic.setImage(UIImage(named: "video_mic"), for: .normal)
        mic.tag = 1
        let cam = UIButton(type: .custom)
        cam.setImage(UIImage(named: "video_voice"), for: .normal)
        cam.tag = 2
        let spk = UIButton(type: .custom)
        spk.setImage(UIImage(named: "video_voice"), for: .normal)
        spk.tag = 3
        let stack = UIStackView(arrangedSubviews: [mic, cam, spk])
        stack.axis = .horizontal
        stack.spacing = 28
        stack.distribution = .equalSpacing
        view.addSubview(stack)
        stack.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(hang.snp.top).offset(-28)
        }
        [mic, cam, spk].forEach {
            $0.snp.makeConstraints { $0.size.equalTo(52) }
            $0.addTarget(self, action: #selector(toolTap(_:)), for: .touchUpInside)
        }
    }

    @objc private func toolTap(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            micOn.toggle()
            sender.setImage(UIImage(named: micOn ? "video_mic" : "video_mic_off"), for: .normal)
        case 2:
            camOn.toggle()
            sender.setImage(UIImage(named: camOn ? "video_voice" : "video_off"), for: .normal)
        default:
            speakerOn.toggle()
            sender.setImage(UIImage(named: speakerOn ? "video_voice" : "video_voice_off"), for: .normal)
        }
    }
    @objc private func endTap() { navigationController?.popViewController(animated: true) }
}
