import UIKit
import IQKeyboardManager

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .black
        self.window = window

        let launchVC = BX_LaunchViewController()
        launchVC.completion = { [weak window] in
            guard let window else { return }
            RootRouter.bootstrap(in: window)
        }
        window.rootViewController = launchVC
        // Must show the window immediately; otherwise LaunchScreen ends on a black frame
        // and BX_LaunchViewController never appears until (or unless) makeKeyAndVisible runs later.
        window.makeKeyAndVisible()
        return true
    }
}
