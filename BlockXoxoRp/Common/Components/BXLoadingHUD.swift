import UIKit
import SnapKit

/// Lightweight loading HUD to replace SVProgressHUD.
final class BXLoadingHUD {
    static let shared = BXLoadingHUD()

    private var overlay: BXLoadingOverlay?
    private var retainCount = 0

    private init() {}

    static func show(_ status: String? = nil) {
        shared.show(status: status)
    }

    static func dismiss() {
        shared.dismiss()
    }

    private func show(status: String?) {
        dispatchMain {
            self.retainCount += 1
            if let overlay = self.overlay {
                overlay.update(status: status)
                return
            }
            guard let window = Self.keyWindow else { return }
            let overlay = BXLoadingOverlay()
            overlay.update(status: status)
            overlay.alpha = 0
            window.addSubview(overlay)
            overlay.snp.makeConstraints { $0.edges.equalToSuperview() }
            self.overlay = overlay
            UIView.animate(withDuration: 0.18) {
                overlay.alpha = 1
            }
        }
    }

    private func dismiss() {
        dispatchMain {
            self.retainCount = max(0, self.retainCount - 1)
            guard self.retainCount == 0, let overlay = self.overlay else { return }
            UIView.animate(withDuration: 0.15, animations: {
                overlay.alpha = 0
            }, completion: { _ in
                overlay.removeFromSuperview()
                if self.retainCount == 0 {
                    self.overlay = nil
                }
            })
        }
    }

    private func dispatchMain(_ work: @escaping () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.async(execute: work)
        }
    }

    private static var keyWindow: UIWindow? {
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        let active = scenes.first { $0.activationState == .foregroundActive } ?? scenes.first
        return active?.windows.first { $0.isKeyWindow } ?? active?.windows.first
    }
}

private final class BXLoadingOverlay: UIView {
    private let card = UIView()
    private let spinner = UIActivityIndicatorView(style: .large)
    private let ring = CAShapeLayer()
    private let statusLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        backgroundColor = UIColor.black.withAlphaComponent(0.28)

        card.backgroundColor = UIColor(red: 28/255, green: 31/255, blue: 38/255, alpha: 0.96)
        card.layer.cornerRadius = 16
        card.clipsToBounds = true
        addSubview(card)

        spinner.color = BXColor.accent
        spinner.hidesWhenStopped = false
        spinner.startAnimating()
        card.addSubview(spinner)

        statusLabel.textColor = .white
        statusLabel.font = BXFont.body(14)
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 2
        statusLabel.isHidden = true
        card.addSubview(statusLabel)

        // Soft accent ring behind system spinner for a branded feel.
        let ringSize: CGFloat = 44
        ring.fillColor = UIColor.clear.cgColor
        ring.strokeColor = BXColor.accent.withAlphaComponent(0.35).cgColor
        ring.lineWidth = 2.5
        ring.path = UIBezierPath(
            ovalIn: CGRect(x: 0, y: 0, width: ringSize, height: ringSize)
        ).cgPath
        let ringHost = UIView()
        ringHost.layer.addSublayer(ring)
        card.insertSubview(ringHost, belowSubview: spinner)

        card.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.greaterThanOrEqualTo(108)
            $0.width.lessThanOrEqualTo(220)
        }
        spinner.snp.makeConstraints {
            $0.top.equalToSuperview().offset(22)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(36)
        }
        ringHost.snp.makeConstraints {
            $0.center.equalTo(spinner)
            $0.size.equalTo(ringSize)
        }
        statusLabel.snp.makeConstraints {
            $0.top.equalTo(spinner.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-20)
        }

        startRingPulse(on: ringHost)
    }

    required init?(coder: NSCoder) { fatalError() }

    func update(status: String?) {
        let text = status?.trimmingCharacters(in: .whitespacesAndNewlines)
        let hasStatus = !(text?.isEmpty ?? true)
        statusLabel.text = text
        statusLabel.isHidden = !hasStatus
        statusLabel.snp.remakeConstraints {
            $0.top.equalTo(spinner.snp.bottom).offset(hasStatus ? 12 : 0)
            $0.leading.trailing.equalToSuperview().inset(16)
            if hasStatus {
                $0.bottom.equalToSuperview().offset(-20)
            } else {
                $0.height.equalTo(0)
                $0.bottom.equalToSuperview().offset(-22)
            }
        }
    }

    private func startRingPulse(on host: UIView) {
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.fromValue = 0.92
        pulse.toValue = 1.08
        pulse.duration = 0.9
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        pulse.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        host.layer.add(pulse, forKey: "bx_loading_pulse")

        let fade = CABasicAnimation(keyPath: "opacity")
        fade.fromValue = 0.45
        fade.toValue = 1
        fade.duration = 0.9
        fade.autoreverses = true
        fade.repeatCount = .infinity
        ring.add(fade, forKey: "bx_loading_fade")
    }
}
