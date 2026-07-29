import UIKit
import SnapKit

final class BXDialog {
    @discardableResult
    static func show(
        on host: UIViewController? = nil,
        title: String? = nil,
        message: String? = nil,
        image: UIImage? = nil,
        confirmTitle: String = "Continue",
        cancelTitle: String? = nil,
        cancel: (() -> Void)? = nil,
        confirm: (() -> Void)? = nil
    ) -> BXDialogView {
        let parent = host ?? UIApplication.shared.bx_topController
        let dialog = BXDialogView()
        dialog.configure(title: title, message: message, image: image, confirmTitle: confirmTitle, cancelTitle: cancelTitle)
        dialog.onConfirm = { [weak dialog] in
            dialog?.dismiss()
            confirm?()
        }
        dialog.onCancel = { [weak dialog] in
            dialog?.dismiss()
            cancel?()
        }
        dialog.onClose = { [weak dialog] in dialog?.dismiss() }
        if let parent {
            dialog.present(on: parent.view)
        }
        return dialog
    }
}

final class BXDialogView: UIView {
    var onConfirm: (() -> Void)?
    var onCancel: (() -> Void)?
    var onClose: (() -> Void)?

    private let dim = UIView()
    private let card = UIView()
    private let closeBtn = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let imageView = UIImageView()
    private let confirmBtn = UIButton(type: .system)
    private let cancelBtn = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        dim.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        addSubview(dim)
        dim.snp.makeConstraints { $0.edges.equalToSuperview() }
        dim.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeTap)))

        card.backgroundColor = .white
        card.bx_round(22)
        addSubview(card)
        card.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(36)
        }

        closeBtn.setTitle("✕", for: .normal)
        closeBtn.setTitleColor(.white, for: .normal)
        closeBtn.backgroundColor = .black
        closeBtn.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        closeBtn.bx_round(12)
        closeBtn.addTarget(self, action: #selector(closeTap), for: .touchUpInside)
        card.addSubview(closeBtn)
        closeBtn.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(12)
            $0.size.equalTo(24)
        }

        titleLabel.font = BXFont.headline(18)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        messageLabel.font = BXFont.body(14)
        messageLabel.textColor = UIColor.darkGray
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0

        imageView.contentMode = .scaleAspectFit

        confirmBtn.backgroundColor = BXColor.accent
        confirmBtn.setTitleColor(.black, for: .normal)
        confirmBtn.titleLabel?.font = BXFont.headline(16)
        confirmBtn.bx_round(26)
        confirmBtn.addTarget(self, action: #selector(confirmTap), for: .touchUpInside)

        cancelBtn.setTitleColor(.darkGray, for: .normal)
        cancelBtn.titleLabel?.font = BXFont.body(14)
        cancelBtn.addTarget(self, action: #selector(cancelTap), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [imageView, titleLabel, messageLabel, confirmBtn, cancelBtn])
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .fill
        card.addSubview(stack)
        stack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(36)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
        imageView.snp.makeConstraints { $0.height.equalTo(0) }
        confirmBtn.snp.makeConstraints { $0.height.equalTo(52) }
    }

    func configure(title: String?, message: String?, image: UIImage?, confirmTitle: String, cancelTitle: String?) {
        titleLabel.text = title
        titleLabel.isHidden = title == nil
        messageLabel.text = message
        messageLabel.isHidden = message == nil
        imageView.image = image
        imageView.isHidden = image == nil
        imageView.snp.updateConstraints { $0.height.equalTo(image == nil ? 0 : 90) }
        confirmBtn.setTitle(confirmTitle, for: .normal)
        cancelBtn.setTitle(cancelTitle, for: .normal)
        cancelBtn.isHidden = cancelTitle == nil
    }

    func present(on parent: UIView) {
        frame = parent.bounds
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        parent.addSubview(self)
        alpha = 0
        card.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        UIView.animate(withDuration: 0.22) {
            self.alpha = 1
            self.card.transform = .identity
        }
    }

    func dismiss() {
        UIView.animate(withDuration: 0.18, animations: {
            self.alpha = 0
            self.card.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }, completion: { _ in self.removeFromSuperview() })
    }

    @objc private func closeTap() { onClose?() }
    @objc private func confirmTap() { onConfirm?() }
    @objc private func cancelTap() { onCancel?() }
}

extension UIApplication {
    var bx_topController: UIViewController? {
        let scene = connectedScenes.compactMap { $0 as? UIWindowScene }.first { $0.activationState == .foregroundActive }
        var top = scene?.windows.first { $0.isKeyWindow }?.rootViewController
        while let presented = top?.presentedViewController { top = presented }
        if let nav = top as? UINavigationController { top = nav.visibleViewController }
        if let tab = top as? UITabBarController { top = tab.selectedViewController }
        while let nav = top as? UINavigationController { top = nav.visibleViewController }
        return top
    }
}
