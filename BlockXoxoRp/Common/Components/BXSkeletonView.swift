import UIKit
import SnapKit

final class BXSkeletonView: UIView {
    private let shimmer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.18, alpha: 1)
        bx_round(12)
        shimmer.colors = [
            UIColor(white: 0.18, alpha: 1).cgColor,
            UIColor(white: 0.28, alpha: 1).cgColor,
            UIColor(white: 0.18, alpha: 1).cgColor
        ]
        shimmer.startPoint = CGPoint(x: 0, y: 0.5)
        shimmer.endPoint = CGPoint(x: 1, y: 0.5)
        shimmer.locations = [0, 0.5, 1]
        layer.addSublayer(shimmer)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func layoutSubviews() {
        super.layoutSubviews()
        shimmer.frame = bounds
    }

    func start() {
        let anim = CABasicAnimation(keyPath: "locations")
        anim.fromValue = [-1, -0.5, 0]
        anim.toValue = [1, 1.5, 2]
        anim.duration = 1.1
        anim.repeatCount = .infinity
        shimmer.add(anim, forKey: "shimmer")
    }

    func stop() {
        shimmer.removeAnimation(forKey: "shimmer")
        isHidden = true
    }
}

final class BXSkeletonOverlay: UIView {
    private var bones: [BXSkeletonView] = []

    static func attach(to view: UIView, style: Style = .feed) -> BXSkeletonOverlay {
        let o = BXSkeletonOverlay()
        o.backgroundColor = BXColor.background
        view.addSubview(o)
        o.snp.makeConstraints { $0.edges.equalToSuperview() }
        o.build(style)
        o.bones.forEach { $0.start() }
        return o
    }

    enum Style { case feed, profile, list }

    private func build(_ style: Style) {
        switch style {
        case .feed:
            for i in 0..<3 {
                let b = BXSkeletonView()
                addSubview(b)
                b.snp.makeConstraints {
                    $0.leading.trailing.equalToSuperview().inset(16)
                    $0.top.equalToSuperview().offset(CGFloat(120 + i * 210))
                    $0.height.equalTo(190)
                }
                bones.append(b)
            }
        case .profile:
            let avatar = BXSkeletonView()
            avatar.bx_round(40)
            addSubview(avatar)
            avatar.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(16)
                $0.top.equalToSuperview().offset(100)
                $0.size.equalTo(80)
            }
            bones.append(avatar)
            for i in 0..<4 {
                let b = BXSkeletonView()
                addSubview(b)
                b.snp.makeConstraints {
                    $0.leading.trailing.equalToSuperview().inset(16)
                    $0.top.equalToSuperview().offset(CGFloat(200 + i * 70))
                    $0.height.equalTo(56)
                }
                bones.append(b)
            }
        case .list:
            for i in 0..<6 {
                let b = BXSkeletonView()
                addSubview(b)
                b.snp.makeConstraints {
                    $0.leading.trailing.equalToSuperview().inset(16)
                    $0.top.equalToSuperview().offset(CGFloat(100 + i * 72))
                    $0.height.equalTo(60)
                }
                bones.append(b)
            }
        }
    }

    func finish(after delay: TimeInterval = 0.7) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.bones.forEach { $0.stop() }
            UIView.animate(withDuration: 0.25, animations: { self.alpha = 0 }) { _ in
                self.removeFromSuperview()
            }
        }
    }
}
