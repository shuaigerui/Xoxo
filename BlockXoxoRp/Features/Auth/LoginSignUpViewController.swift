import UIKit
import SnapKit

final class LoginViewController: UIViewController {
    private let emailField = BXInputField(placeholder: "Please enter...")
    private let passwordField = BXInputField(placeholder: "Please enter...", secure: true)
    private let agreementLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = BXColor.background

        configureAgreementLabel()
        
        let nav = BXNavBar()
        let canPop = (navigationController?.viewControllers.count ?? 0) > 1
        nav.configure(title: nil, showBack: canPop, rightImage: "login_signup")
        nav.onBack = { [weak self] in self?.navigationController?.popViewController(animated: true) }
        nav.onRight = { [weak self] in self?.bx_push(SignUpViewController()) }
        view.addSubview(nav)
        nav.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }

        let title = UILabel()
        title.text = "Login"
        title.font = BXFont.title(32)
        title.textColor = .white
        view.addSubview(title)
        title.snp.makeConstraints {
            $0.top.equalTo(nav.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }

        let emailLabel = makeLabel("Email")
        let passLabel = makeLabel("Password")
        view.addSubview(emailLabel)
        view.addSubview(emailField)
        view.addSubview(passLabel)
        view.addSubview(passwordField)
        emailField.textField.keyboardType = .emailAddress
        emailField.textField.autocapitalizationType = .none

        emailLabel.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(36)
            $0.leading.equalToSuperview().offset(20)
        }
        emailField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        passLabel.snp.makeConstraints {
            $0.top.equalTo(emailField.snp.bottom).offset(20)
            $0.leading.equalTo(emailLabel)
        }
        passwordField.snp.makeConstraints {
            $0.top.equalTo(passLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        let loginBtn = UIButton(type: .custom)
        loginBtn.setImage(UIImage(named: "login_button"), for: .normal)
        loginBtn.imageView?.contentMode = .scaleAspectFit
        loginBtn.addTarget(self, action: #selector(loginTap), for: .touchUpInside)
        // Fallback styled button if image stretches oddly
        if UIImage(named: "login_button") == nil {
            loginBtn.setTitle("Login", for: .normal)
            loginBtn.backgroundColor = BXColor.accent
            loginBtn.setTitleColor(.black, for: .normal)
            loginBtn.bx_round(26)
        }
        view.addSubview(loginBtn)
        loginBtn.snp.makeConstraints {
            $0.top.equalTo(passwordField.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
        
        
        view.addSubview(agreementLabel)
        
        agreementLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12)
        }
        
        let agreementTap = UITapGestureRecognizer(target: self, action: #selector(handleAgreementTap(_:)))
        agreementLabel.addGestureRecognizer(agreementTap)
    }

    private func makeLabel(_ t: String) -> UILabel {
        let l = UILabel()
        l.text = t
        l.textColor = .white
        l.font = BXFont.body(14)
        return l
    }

    @objc private func loginTap() {
        let email = emailField.text
        let pwd = passwordField.text
        guard !email.isEmpty, !pwd.isEmpty else {
            BXDialog.show(on: self, message: "Please enter email and password.", confirmTitle: "Continue")
            return
        }
        
        BX_NetworkManager.shared.request { _ in
            APIClient.shared.perform(path: APIPath.signIn, body: ["email": email]) { [weak self] ok in
                guard let self, ok else { return }
                if let err = CurrentUserSession.shared.signIn(email: email, password: pwd) {
                    if err == "unregistered" {
                        BXDialog.show(on: self, message: "This email is not registered. Please sign up first.", confirmTitle: "Sign Up", cancelTitle: "Cancel", confirm: {
                            self.bx_push(SignUpViewController(prefillEmail: email))
                        })
                    } else {
                        BXDialog.show(on: self, message: "Incorrect password. Please try again.", confirmTitle: "Continue")
                    }
                } else {
                    RootRouter.showMain()
                }
            }
        }
        
    }
    
    private func configureAgreementLabel() {
        let fullText = "By signing up, you agree to the User Agreement and Privacy Policy"
        let attributedText = NSMutableAttributedString(
            string: fullText,
            attributes: [
                .font: UIFont.systemFont(ofSize: 11, weight: .medium),
                .foregroundColor: UIColor.white
            ]
        )

        let userAgreementRange = (fullText as NSString).range(of: "User Agreement")
        let privacyPolicyRange = (fullText as NSString).range(of: "Privacy Policy")

        attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: userAgreementRange)
        attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: privacyPolicyRange)

        agreementLabel.attributedText = attributedText
    }
    
    @objc private func handleAgreementTap(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended,
              let label = gesture.view as? UILabel,
              let attributedText = label.attributedText else {
            return
        }

        let text = attributedText.string
        let location = gesture.location(in: label)
        let index = characterIndex(at: location, in: label, attributedText: attributedText)

        let userAgreementRange = (text as NSString).range(of: "User Agreement")
        let privacyPolicyRange = (text as NSString).range(of: "Privacy Policy")

        if NSLocationInRange(index, userAgreementRange) {
            didTapUserAgreement()
        } else if NSLocationInRange(index, privacyPolicyRange) {
            didTapPrivacyPolicy()
        }
    }
    
    private func characterIndex(at point: CGPoint, in label: UILabel, attributedText: NSAttributedString) -> Int {
        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: label.bounds.size)

        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = label.numberOfLines
        textContainer.lineBreakMode = label.lineBreakMode

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        let glyphIndex = layoutManager.glyphIndex(for: point, in: textContainer)
        return layoutManager.characterIndexForGlyph(at: glyphIndex)
    }
    
    @objc func didTapUserAgreement() {
        if let doc = URL(string: "https://docs.google.com/document/d/1tNnVmVtTnx6cIhSgakVZn90WwnuAtdDLphtTmPPm_H4/edit?usp=sharing") {
            UIApplication.shared.open(doc, options: [:], completionHandler: nil)
        }
    }

    @objc func didTapPrivacyPolicy() {
        if let doc = URL(string: "https://docs.google.com/document/d/1GlF9RwIwONii4Ejk3jNV_my2KsK4kAtdraYrkhzG5LU/edit?usp=sharing") {
            UIApplication.shared.open(doc, options: [:], completionHandler: nil)
        }
    }
}

final class SignUpViewController: UIViewController {
    private let emailField = BXInputField(placeholder: "Please enter...")
    private let passwordField = BXInputField(placeholder: "Please enter...", secure: true)
    private let confirmField = BXInputField(placeholder: "Please enter...", secure: true)
    private let prefill: String?
    private let agreementLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()

    init(prefillEmail: String? = nil) {
        self.prefill = prefillEmail
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = BXColor.background
        emailField.textField.text = prefill
        emailField.textField.keyboardType = .emailAddress
        emailField.textField.autocapitalizationType = .none

        configureAgreementLabel()
        
        let nav = BXNavBar()
        nav.configure(title: nil, showBack: true, rightImage: "signup_login")
        nav.onBack = { [weak self] in self?.navigationController?.popViewController(animated: true) }
        nav.onRight = { [weak self] in
            if let login = self?.navigationController?.viewControllers.first(where: { $0 is LoginViewController }) {
                self?.navigationController?.popToViewController(login, animated: true)
            } else {
                self?.bx_push(LoginViewController())
            }
        }
        view.addSubview(nav)
        nav.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }

        let title = UILabel()
        title.text = "Sign Up"
        title.font = BXFont.title(32)
        title.textColor = .white
        view.addSubview(title)
        title.snp.makeConstraints {
            $0.top.equalTo(nav.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }

        let stackLabels = ["Email", "Password", ""]
        let fields = [emailField, passwordField, confirmField]
        var anchor = title.snp.bottom
        for (i, field) in fields.enumerated() {
            if i < 2 {
                let lab = UILabel()
                lab.text = stackLabels[i]
                lab.textColor = .white
                lab.font = BXFont.body(14)
                view.addSubview(lab)
                lab.snp.makeConstraints {
                    $0.top.equalTo(anchor).offset(i == 0 ? 36 : 20)
                    $0.leading.equalToSuperview().offset(20)
                }
                view.addSubview(field)
                field.snp.makeConstraints {
                    $0.top.equalTo(lab.snp.bottom).offset(8)
                    $0.leading.trailing.equalToSuperview().inset(20)
                }
                anchor = field.snp.bottom
            } else {
                view.addSubview(field)
                field.snp.makeConstraints {
                    $0.top.equalTo(anchor).offset(12)
                    $0.leading.trailing.equalToSuperview().inset(20)
                }
                anchor = field.snp.bottom
            }
        }

        let btn = UIButton(type: .custom)
        if let img = UIImage(named: "signup_button") {
            btn.setImage(img, for: .normal)
        } else {
            btn.setTitle("Sign Up", for: .normal)
            btn.backgroundColor = BXColor.accent
            btn.setTitleColor(.black, for: .normal)
            btn.bx_round(26)
        }
        btn.addTarget(self, action: #selector(signUpTap), for: .touchUpInside)
        view.addSubview(btn)
        btn.snp.makeConstraints {
            $0.top.equalTo(anchor).offset(36)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
        
        view.addSubview(agreementLabel)
        
        agreementLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12)
        }
        
        let agreementTap = UITapGestureRecognizer(target: self, action: #selector(handleAgreementTap(_:)))
        agreementLabel.addGestureRecognizer(agreementTap)
    }

    @objc private func signUpTap() {
        let email = emailField.text
        let p1 = passwordField.text
        let p2 = confirmField.text
        guard !email.isEmpty, !p1.isEmpty else {
            BXDialog.show(on: self, message: "Please fill in all fields.", confirmTitle: "Continue")
            return
        }
        guard p1 == p2 else {
            BXDialog.show(on: self, message: "Passwords do not match.", confirmTitle: "Continue")
            return
        }
        APIClient.shared.perform(path: APIPath.signUp, body: ["email": email]) { [weak self] ok in
            guard let self, ok else { return }
            if let err = CurrentUserSession.shared.signUp(email: email, password: p1) {
                if err == "exists" {
                    BXDialog.show(on: self, message: "This email is already registered. Please login.", confirmTitle: "Login", confirm: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            } else {
                self.bx_push(ProfileInfoViewController(isOnboarding: true))
            }
        }
    }
    
    private func configureAgreementLabel() {
        let fullText = "By signing up, you agree to the User Agreement and Privacy Policy"
        let attributedText = NSMutableAttributedString(
            string: fullText,
            attributes: [
                .font: UIFont.systemFont(ofSize: 11, weight: .medium),
                .foregroundColor: UIColor.white
            ]
        )

        let userAgreementRange = (fullText as NSString).range(of: "User Agreement")
        let privacyPolicyRange = (fullText as NSString).range(of: "Privacy Policy")

        attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: userAgreementRange)
        attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: privacyPolicyRange)

        agreementLabel.attributedText = attributedText
    }
    
    @objc private func handleAgreementTap(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended,
              let label = gesture.view as? UILabel,
              let attributedText = label.attributedText else {
            return
        }

        let text = attributedText.string
        let location = gesture.location(in: label)
        let index = characterIndex(at: location, in: label, attributedText: attributedText)

        let userAgreementRange = (text as NSString).range(of: "User Agreement")
        let privacyPolicyRange = (text as NSString).range(of: "Privacy Policy")

        if NSLocationInRange(index, userAgreementRange) {
            didTapUserAgreement()
        } else if NSLocationInRange(index, privacyPolicyRange) {
            didTapPrivacyPolicy()
        }
    }
    
    private func characterIndex(at point: CGPoint, in label: UILabel, attributedText: NSAttributedString) -> Int {
        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: label.bounds.size)

        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = label.numberOfLines
        textContainer.lineBreakMode = label.lineBreakMode

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        let glyphIndex = layoutManager.glyphIndex(for: point, in: textContainer)
        return layoutManager.characterIndexForGlyph(at: glyphIndex)
    }
    
    @objc func didTapUserAgreement() {
        if let doc = URL(string: "https://docs.google.com/document/d/1tNnVmVtTnx6cIhSgakVZn90WwnuAtdDLphtTmPPm_H4/edit?usp=sharing") {
            UIApplication.shared.open(doc, options: [:], completionHandler: nil)
        }
    }

    @objc func didTapPrivacyPolicy() {
        if let doc = URL(string: "https://docs.google.com/document/d/1GlF9RwIwONii4Ejk3jNV_my2KsK4kAtdraYrkhzG5LU/edit?usp=sharing") {
            UIApplication.shared.open(doc, options: [:], completionHandler: nil)
        }
    }
}

final class ProfileInfoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let isOnboarding: Bool
    private let avatarView = UIImageView()
    private let nameField = BXInputField(placeholder: "Please enter nickname...")
    private var pickedImageName: String?

    init(isOnboarding: Bool) {
        self.isOnboarding = isOnboarding
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = BXColor.background

        let nav = BXNavBar()
        nav.configure(title: "Profile", showBack: true)
        nav.onBack = { [weak self] in self?.navigationController?.popViewController(animated: true) }
        view.addSubview(nav)
        nav.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }

        avatarView.bx_set(CurrentUserSession.shared.user?.avatarName ?? "avatar_07")
        avatarView.bx_round(50)
        avatarView.isUserInteractionEnabled = true
        avatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickAvatar)))
        view.addSubview(avatarView)
        avatarView.snp.makeConstraints {
            $0.top.equalTo(nav.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(100)
        }

        let cam = UIImageView(image: UIImage(named: "info_camera"))
        view.addSubview(cam)
        cam.snp.makeConstraints {
            $0.trailing.bottom.equalTo(avatarView).inset(-4)
            $0.size.equalTo(32)
        }

        let nameLab = UILabel()
        nameLab.text = "Nickname"
        nameLab.textColor = .white
        nameLab.font = BXFont.body(14)
        view.addSubview(nameLab)
        nameLab.snp.makeConstraints {
            $0.top.equalTo(avatarView.snp.bottom).offset(28)
            $0.leading.equalToSuperview().offset(20)
        }
        view.addSubview(nameField)
        nameField.textField.text = CurrentUserSession.shared.user?.nickname
        nameField.snp.makeConstraints {
            $0.top.equalTo(nameLab.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        let cont = UIButton(type: .custom)
        if let img = UIImage(named: "info_continue") {
            cont.setImage(img, for: .normal)
        } else {
            cont.setTitle("Continue", for: .normal)
            cont.backgroundColor = BXColor.accent
            cont.setTitleColor(.black, for: .normal)
            cont.bx_round(26)
        }
        cont.addTarget(self, action: #selector(continueTap), for: .touchUpInside)
        view.addSubview(cont)
        cont.snp.makeConstraints {
            $0.top.equalTo(nameField.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
    }

    @objc private func pickAvatar() {
        MediaPickerHelper.present(from: self) { [weak self] image in
            guard let self, let image else { return }
            self.avatarView.image = image
            let name = MediaPickerHelper.saveImage(image)
            self.pickedImageName = name
        }
    }

    @objc private func continueTap() {
        let nick = nameField.text
        guard !nick.isEmpty else {
            BXDialog.show(on: self, message: "Please enter a nickname.", confirmTitle: "Continue")
            return
        }
        CurrentUserSession.shared.updateProfile {
            $0.nickname = nick
            $0.handle = nick
            if let pickedImageName { $0.avatarName = pickedImageName }
        }
        BX_NetworkManager.shared.request { _ in
            if self.isOnboarding {
                RootRouter.showMain()
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        if let img = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            avatarView.image = img
            pickedImageName = MediaPickerHelper.saveImage(img)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { picker.dismiss(animated: true) }
}
