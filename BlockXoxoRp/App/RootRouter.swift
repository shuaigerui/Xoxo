import UIKit

enum RootRouter {
    static weak var window: UIWindow?

    static func bootstrap(in window: UIWindow) {
        self.window = window
        window.backgroundColor = .black
        CurrentUserSession.shared.bootstrap()
        refresh()
    }

    static func refresh() {
        guard let window else { return }
        window.backgroundColor = .black
        let root: UIViewController
        if CurrentUserSession.shared.isLoggedIn {
            root = MainTabBarController()
        } else if !LocalStore.shared.isGuideFinished {
            root = UINavigationController(rootViewController: WelcomeViewController())
        } else {
            root = UINavigationController(rootViewController: LoginViewController())
        }
        window.rootViewController = root
        window.makeKeyAndVisible()
    }

    static func showMain() {
        guard let window else { return }
        window.backgroundColor = .black
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = MainTabBarController()
        })
    }

    static func showLogin() {
        guard let window else { return }
        let nav = UINavigationController(rootViewController: LoginViewController())
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = nav
        })
    }
}
