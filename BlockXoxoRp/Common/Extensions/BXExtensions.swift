import UIKit
import SnapKit

extension UIView {
    func bx_round(_ r: CGFloat = BXLayout.corner) {
        layer.cornerRadius = r
        layer.masksToBounds = true
    }

    func bx_gradient(colors: [UIColor], start: CGPoint = CGPoint(x: 0, y: 0), end: CGPoint = CGPoint(x: 1, y: 1)) {
        let g = CAGradientLayer()
        g.colors = colors.map { $0.cgColor }
        g.startPoint = start
        g.endPoint = end
        g.frame = bounds
        g.name = "bx_gradient"
        layer.sublayers?.removeAll { $0.name == "bx_gradient" }
        layer.insertSublayer(g, at: 0)
    }
}

extension UIImageView {
    func bx_set(_ name: String?, placeholder: String? = nil) {
        if let name, let img = MediaPickerHelper.loadLocal(name) {
            image = img
        } else if let placeholder, let img = MediaPickerHelper.loadLocal(placeholder) {
            image = img
        } else {
            image = nil
        }
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
}

extension String {
    var bx_timeAgo: String {
        guard let t = Double(self) else { return self }
        return Date(timeIntervalSince1970: t).bx_timeAgo
    }
}

extension TimeInterval {
    var bx_timeAgo: String {
        Date(timeIntervalSince1970: self).bx_timeAgo
    }
}

extension Date {
    var bx_timeAgo: String {
        let s = Int(Date().timeIntervalSince(self))
        if s < 60 { return "just now" }
        if s < 3600 { return "\(s / 60)m ago" }
        if s < 86400 { return "\(s / 3600)h ago" }
        return "\(s / 86400)d ago"
    }

    var bx_hm: String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f.string(from: self)
    }
}

extension UIImage {
    /// Flatten orientation metadata so JPEG encoding is stable for camera/library picks.
    func bx_normalized() -> UIImage {
        guard imageOrientation != .up else { return self }
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = scale
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

extension UIViewController {
    func bx_push(_ vc: UIViewController, animated: Bool = true) {
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: animated)
    }

    func bx_embedScroll(content: UIView) -> UIScrollView {
        let scroll = UIScrollView()
        scroll.alwaysBounceVertical = true
        scroll.showsVerticalScrollIndicator = false
        view.addSubview(scroll)
        scroll.snp.makeConstraints { $0.edges.equalToSuperview() }
        scroll.addSubview(content)
        content.snp.makeConstraints {
            $0.edges.equalTo(scroll.contentLayoutGuide)
            $0.width.equalTo(scroll.frameLayoutGuide)
        }
        return scroll
    }
}
