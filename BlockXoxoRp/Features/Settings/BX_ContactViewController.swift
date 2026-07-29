import UIKit
import SnapKit
import MessageUI

final class BX_ContactViewController: UIViewController {
    private let supportEmail = "Xoxofeadback@gmail.com"

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = BXColor.background
        setupUI()
    }

    private func setupUI() {
        let nav = BXNavBar()
        nav.configure(title: "Contact Us", showBack: true)
        nav.onBack = { [weak self] in self?.navigationController?.popViewController(animated: true) }
        view.addSubview(nav)
        nav.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }

        let title = UILabel()
        title.text = "Get in touch"
        title.textColor = .white
        title.font = BXFont.title(28)
        view.addSubview(title)
        title.snp.makeConstraints {
            $0.top.equalTo(nav.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        let subtitle = UILabel()
        subtitle.text = "Have a question, feedback, or need help? Email us and we’ll get back to you as soon as we can."
        subtitle.textColor = BXColor.textSecondary
        subtitle.font = BXFont.body(14)
        subtitle.numberOfLines = 0
        view.addSubview(subtitle)
        subtitle.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        let card = UIView()
        card.backgroundColor = BXColor.card
        card.bx_round(16)
        view.addSubview(card)
        card.snp.makeConstraints {
            $0.top.equalTo(subtitle.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        let emailLab = UILabel()
        emailLab.text = "Email"
        emailLab.textColor = BXColor.textSecondary
        emailLab.font = BXFont.caption(13)
        card.addSubview(emailLab)
        emailLab.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
        }

        let emailValue = UILabel()
        emailValue.text = supportEmail
        emailValue.textColor = .white
        emailValue.font = BXFont.headline(16)
        emailValue.numberOfLines = 1
        emailValue.adjustsFontSizeToFitWidth = true
        emailValue.minimumScaleFactor = 0.8
        card.addSubview(emailValue)
        emailValue.snp.makeConstraints {
            $0.top.equalTo(emailLab.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-16)
        }

        let copyBtn = UIButton(type: .custom)
        copyBtn.setTitle("Copy Email", for: .normal)
        copyBtn.setTitleColor(.black, for: .normal)
        copyBtn.titleLabel?.font = BXFont.headline(16)
        copyBtn.backgroundColor = BXColor.accent
        copyBtn.bx_round(26)
        copyBtn.addTarget(self, action: #selector(copyTap), for: .touchUpInside)
        view.addSubview(copyBtn)
        copyBtn.snp.makeConstraints {
            $0.top.equalTo(card.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }

        let mailBtn = UIButton(type: .system)
        mailBtn.setTitle("Send Email", for: .normal)
        mailBtn.setTitleColor(.white, for: .normal)
        mailBtn.titleLabel?.font = BXFont.headline(16)
        mailBtn.backgroundColor = BXColor.card
        mailBtn.bx_round(26)
        mailBtn.addTarget(self, action: #selector(mailTap), for: .touchUpInside)
        view.addSubview(mailBtn)
        mailBtn.snp.makeConstraints {
            $0.top.equalTo(copyBtn.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }
    }

    @objc private func copyTap() {
        UIPasteboard.general.string = supportEmail
        BXDialog.show(on: self, message: "Email copied to clipboard.", confirmTitle: "Continue")
    }

    @objc private func mailTap() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([supportEmail])
            mail.setSubject("BrickVerse Support")
            present(mail, animated: true)
            return
        }
        guard let url = URL(string: "mailto:\(supportEmail)") else { return }
        UIApplication.shared.open(url) { [weak self] ok in
            guard let self, !ok else { return }
            BXDialog.show(
                on: self,
                title: "Unable to open Mail",
                message: "Please email us at \(self.supportEmail)",
                confirmTitle: "Copy Email",
                cancelTitle: "Cancel",
                confirm: { [weak self] in
                    guard let self else { return }
                    UIPasteboard.general.string = self.supportEmail
                }
            )
        }
    }
}

extension BX_ContactViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        if result == .sent {
            BXDialog.show(on: self, message: "Thanks! Your message has been sent.", confirmTitle: "Continue")
        }
    }
}
