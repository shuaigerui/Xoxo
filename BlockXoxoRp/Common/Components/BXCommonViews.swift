import UIKit
import SnapKit

final class BXNavBar: UIView {
    let backButton = UIButton(type: .custom)
    let titleLabel = UILabel()
    let rightButton = UIButton(type: .custom)
    var onBack: (() -> Void)?
    var onRight: (() -> Void)?
    private var rightWidthConstraint: Constraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear

        backButton.setImage(UIImage(named: "common_back"), for: .normal)
        backButton.addTarget(self, action: #selector(backTap), for: .touchUpInside)
        addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-8)
            $0.size.equalTo(36)
        }

        rightButton.imageView?.contentMode = .scaleAspectFit
        rightButton.addTarget(self, action: #selector(rightTap), for: .touchUpInside)
        addSubview(rightButton)
        rightButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-12)
            $0.centerY.equalTo(backButton)
            $0.height.equalTo(36)
            rightWidthConstraint = $0.width.equalTo(36).constraint
        }

        titleLabel.font = BXFont.headline(17)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backButton)
            $0.leading.greaterThanOrEqualTo(backButton.snp.trailing).offset(8)
            $0.trailing.lessThanOrEqualTo(rightButton.snp.leading).offset(-8)
        }
    }
    required init?(coder: NSCoder) { fatalError() }

    func configure(title: String?, showBack: Bool = true, rightImage: String? = nil, rightTitle: String? = nil) {
        titleLabel.text = title
        backButton.isHidden = !showBack
        if let rightImage, let img = UIImage(named: rightImage) {
            rightButton.setImage(img, for: .normal)
            rightButton.setTitle(nil, for: .normal)
            rightButton.isHidden = false
            // Wide assets (e.g. Sign Up / Login pills) keep aspect; square icons stay 36.
            let ratio = img.size.width / max(img.size.height, 1)
            let width: CGFloat = ratio > 1.4 ? min(120, 36 * ratio) : 36
            rightWidthConstraint?.update(offset: width)
        } else if let rightTitle {
            rightButton.setImage(nil, for: .normal)
            rightButton.setTitle(rightTitle, for: .normal)
            rightButton.setTitleColor(.white, for: .normal)
            rightButton.titleLabel?.font = BXFont.body(14)
            rightButton.isHidden = false
            rightWidthConstraint?.update(offset: 72)
        } else {
            rightButton.isHidden = true
            rightWidthConstraint?.update(offset: 36)
        }
    }

    @objc private func backTap() { onBack?() }
    @objc private func rightTap() { onRight?() }
}

final class BXEmptyView: UIView {
    private let imageView = UIImageView(image: UIImage(named: "common_empty"))
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        label.text = "Nothing here yet"
        label.textColor = BXColor.textSecondary
        label.font = BXFont.body(14)
        label.textAlignment = .center
        addSubview(label)
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-20)
            $0.width.height.equalTo(140)
        }
        label.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) { fatalError() }
}

final class BXPrimaryButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = BXColor.accent
        setTitleColor(.black, for: .normal)
        titleLabel?.font = BXFont.headline(16)
        bx_round(26)
    }
    required init?(coder: NSCoder) { fatalError() }
}

final class BXInputField: UIView {
    let textField = UITextField()
    private let eyeButton = UIButton(type: .custom)
    private var isSecure = false

    init(placeholder: String, secure: Bool = false) {
        super.init(frame: .zero)
        backgroundColor = BXColor.input
        bx_round(14)
        isSecure = secure
        textField.placeholder = placeholder
        textField.textColor = .white
        textField.font = BXFont.body(15)
        textField.isSecureTextEntry = secure
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: BXColor.textSecondary])
        addSubview(textField)
        textField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(14)
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().offset(secure ? -44 : -14)
            $0.height.equalTo(48)
        }
        if secure {
            eyeButton.setImage(UIImage(named: "login_show") ?? UIImage(named: "signup_show"), for: .normal)
            eyeButton.addTarget(self, action: #selector(toggle), for: .touchUpInside)
            addSubview(eyeButton)
            eyeButton.snp.makeConstraints {
                $0.trailing.equalToSuperview().offset(-10)
                $0.centerY.equalToSuperview()
                $0.size.equalTo(28)
            }
        }
    }
    required init?(coder: NSCoder) { fatalError() }

    @objc private func toggle() {
        textField.isSecureTextEntry.toggle()
    }

    var text: String { textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "" }
}
