import UIKit

enum BXColor {
    static let background = UIColor(red: 10/255, green: 14/255, blue: 20/255, alpha: 1)
    static let card = UIColor(red: 28/255, green: 31/255, blue: 38/255, alpha: 1)
    static let input = UIColor(red: 42/255, green: 47/255, blue: 54/255, alpha: 1)
    static let accent = UIColor(red: 245/255, green: 197/255, blue: 24/255, alpha: 1)
    static let textPrimary = UIColor.white
    static let textSecondary = UIColor(white: 0.62, alpha: 1)
    static let purpleBubble = UIColor(red: 123/255, green: 92/255, blue: 255/255, alpha: 1)
    static let danger = UIColor(red: 255/255, green: 107/255, blue: 129/255, alpha: 1)
    static let border = UIColor(red: 123/255, green: 92/255, blue: 255/255, alpha: 0.85)
    static let walletRow = UIColor(red: 58/255, green: 62/255, blue: 40/255, alpha: 1)
}

enum BXFont {
    static func title(_ size: CGFloat = 28) -> UIFont {
        UIFont.systemFont(ofSize: size, weight: .bold)
    }
    static func headline(_ size: CGFloat = 18) -> UIFont {
        UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    static func body(_ size: CGFloat = 15) -> UIFont {
        UIFont.systemFont(ofSize: size, weight: .regular)
    }
    static func caption(_ size: CGFloat = 12) -> UIFont {
        UIFont.systemFont(ofSize: size, weight: .regular)
    }
}

enum BXLayout {
    static let pageInset: CGFloat = 16
    static let corner: CGFloat = 16
    static let buttonHeight: CGFloat = 52
    static let coinCost = 10
}
