import UIKit
import SnapKit

enum ReportBlockPresenter {
    static func present(from vc: UIViewController, target: ReportTarget) {
        // Own post / comment → confirm delete instead of report flow.
        if case .post = target, CurrentUserSession.shared.isOwnedByCurrentUser(target) {
            presentDeleteConfirm(from: vc, target: target)
            return
        }
        if case .comment = target, CurrentUserSession.shared.isOwnedByCurrentUser(target) {
            presentDeleteConfirm(from: vc, target: target)
            return
        }
        let sheet = ReportBlockSheet(target: target)
        sheet.present(on: vc)
    }

    /// Convenience for user reports.
    static func present(from vc: UIViewController, targetId: String) {
        present(from: vc, target: .user(targetId))
    }

    private static func presentDeleteConfirm(from vc: UIViewController, target: ReportTarget) {
        let isPost: Bool
        switch target {
        case .post: isPost = true
        case .comment: isPost = false
        case .user: return
        }
        let title = isPost ? "Delete this post?" : "Delete this comment?"
        let message = isPost
            ? "This build will be removed from BrickVerse on this device."
            : "This comment will be removed permanently."
        BXDialog.show(
            on: vc,
            title: title,
            message: message,
            confirmTitle: "Delete",
            cancelTitle: "Cancel",
            confirm: {
                let ok: Bool
                switch target {
                case .post(let id):
                    ok = CurrentUserSession.shared.deleteOwnPost(id)
                case .comment(let id):
                    ok = CurrentUserSession.shared.deleteOwnComment(id)
                case .user:
                    ok = false
                }
                guard ok else { return }
                if isPost, vc is PostDetailViewController {
                    vc.navigationController?.popViewController(animated: true)
                }
            }
        )
    }
}

final class ReportBlockSheet: UIView {
    private let target: ReportTarget
    private weak var host: UIViewController?
    private let dim = UIView()
    private let panel = UIView()

    init(target: ReportTarget) {
        self.target = target
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }

    func present(on vc: UIViewController) {
        host = vc
        frame = vc.view.bounds
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vc.view.addSubview(self)

        dim.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        addSubview(dim)
        dim.snp.makeConstraints { $0.edges.equalToSuperview() }
        dim.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close)))

        panel.backgroundColor = UIColor(red: 40/255, green: 28/255, blue: 70/255, alpha: 1)
        panel.layer.cornerRadius = 20
        panel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        addSubview(panel)
        panel.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(140)
        }

        let report = UIButton(type: .custom)
        if let img = UIImage(named: "RB_report") {
            report.setImage(img, for: .normal)
        } else {
            report.setTitle("Report", for: .normal)
            report.backgroundColor = .white
            report.setTitleColor(.black, for: .normal)
            report.bx_round(22)
        }
        report.addTarget(self, action: #selector(reportTap), for: .touchUpInside)

        let block = UIButton(type: .custom)
        if let img = UIImage(named: "RB_block") {
            block.setImage(img, for: .normal)
        } else {
            block.setTitle("Block", for: .normal)
            block.backgroundColor = BXColor.danger
            block.setTitleColor(.white, for: .normal)
            block.bx_round(22)
        }
        block.addTarget(self, action: #selector(blockTap), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [report, block])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        panel.addSubview(stack)
        stack.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(48)
        }

        panel.transform = CGAffineTransform(translationX: 0, y: 140)
        UIView.animate(withDuration: 0.25) {
            self.panel.transform = .identity
        }
    }

    @objc private func close() {
        dismissSheet()
    }

    private func dismissSheet(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.2, animations: {
            self.panel.transform = CGAffineTransform(translationX: 0, y: 140)
            self.alpha = 0
        }, completion: { _ in
            self.removeFromSuperview()
            completion?()
        })
    }

    @objc private func reportTap() {
        guard let host else { return }
        let target = self.target
        dismissSheet {
            host.bx_push(BX_ReportViewController(target: target))
        }
    }

    @objc private func blockTap() {
        guard let host else { return }
        let userId: String?
        switch target {
        case .user(let id): userId = id
        case .post(let postId): userId = CurrentUserSession.shared.posts.first(where: { $0.id == postId })?.authorId
        case .comment(let commentId): userId = CurrentUserSession.shared.comments.first(where: { $0.id == commentId })?.authorId
        }
        guard let userId else { return }
        dismissSheet {
            BXDialog.show(on: host, title: "Block this builder?", message: "They won't be able to message you or appear in your feeds.", confirmTitle: "Block", cancelTitle: "Cancel", confirm: {
                CurrentUserSession.shared.blockUser(userId) { ok in
                    if ok {
                        BXDialog.show(on: host, message: "User blocked. You can manage the blacklist in Settings.", confirmTitle: "Continue") {
                            host.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            })
        }
    }
}
