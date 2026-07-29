import UIKit
import SnapKit

final class BX_ReportViewController: UIViewController {
    private let target: ReportTarget

    private let reasons = [
        "Inappropriate Content",
        "Copyright Issue",
        "Fake or Misleading Content",
        "Spam",
        "Scam or Fraud",
        "Incorrect Build Information",
        "Stolen Creation",
        "Unsafe Challenge Content"
    ]

    init(target: ReportTarget) {
        self.target = target
        super.init(nibName: nil, bundle: nil)
    }

    convenience init(targetId: String) {
        self.init(target: .user(targetId))
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = BXColor.background

        let nav = BXNavBar()
        nav.configure(title: "Report", showBack: true, rightImage: "")
        nav.onBack = { [weak self] in self?.navigationController?.popViewController(animated: true) }
        view.addSubview(nav)
        nav.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }

        let scroll = UIScrollView()
        scroll.alwaysBounceVertical = true
        scroll.showsVerticalScrollIndicator = false
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

        var anchor = box.snp.top
        for (idx, reason) in reasons.enumerated() {
            let btn = UIButton(type: .system)
            btn.backgroundColor = BXColor.card
            btn.setTitle(reason, for: .normal)
            btn.setTitleColor(.white, for: .normal)
            btn.titleLabel?.font = BXFont.headline(15)
            btn.bx_round(16)
            btn.tag = idx
            btn.addTarget(self, action: #selector(reasonTap(_:)), for: .touchUpInside)
            box.addSubview(btn)
            btn.snp.makeConstraints {
                $0.top.equalTo(anchor).offset(idx == 0 ? 20 : 12)
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.height.equalTo(52)
            }
            anchor = btn.snp.bottom
        }

        let spacer = UIView()
        box.addSubview(spacer)
        spacer.snp.makeConstraints {
            $0.top.equalTo(anchor).offset(40)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(20)
        }
    }

    @objc private func reasonTap(_ sender: UIButton) {
        let reason = reasons[sender.tag]
        CurrentUserSession.shared.submitReport(target, reason: reason) { [weak self] ok in
            guard let self, ok else { return }
            BXDialog.show(
                on: self,
                message: "Report submitted. Thank you for keeping BrickVerse safe.",
                confirmTitle: "Continue",
                confirm: { [weak self] in
                    self?.finishAfterReport()
                }
            )
        }
    }

    private func finishAfterReport() {
        guard let nav = navigationController else { return }
        switch target {
        case .post:
            // Leave report page and the post detail page.
            if nav.viewControllers.count >= 2,
               nav.viewControllers[nav.viewControllers.count - 2] is PostDetailViewController {
                let root = Array(nav.viewControllers.dropLast(2))
                if root.isEmpty {
                    nav.popToRootViewController(animated: true)
                } else {
                    nav.setViewControllers(root, animated: true)
                }
            } else {
                nav.popViewController(animated: true)
            }
        case .comment:
            // Pop back to detail; detail will refresh in viewWillAppear / session observer.
            if let detail = nav.viewControllers.compactMap({ $0 as? PostDetailViewController }).last {
                nav.popToViewController(detail, animated: true)
                detail.refreshAfterContentChange()
            } else {
                nav.popViewController(animated: true)
            }
        case .user:
            nav.popViewController(animated: true)
        }
    }
}