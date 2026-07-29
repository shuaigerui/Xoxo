import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BXColor.background
        configureTabBarAppearance()
        setupTabs()
    }

    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()

        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.clear]
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.isTranslucent = false
        tabBar.barTintColor = .black
        tabBar.backgroundColor = .black
        tabBar.tintColor = BXColor.accent
        tabBar.unselectedItemTintColor = UIColor(white: 0.55, alpha: 1)
    }

    private func setupTabs() {
        func makeItem(normal: String, selected: String) -> UITabBarItem {
            let normalImage = UIImage(named: normal)?.withRenderingMode(.alwaysOriginal)
            let selectedImage = UIImage(named: selected)?.withRenderingMode(.alwaysOriginal)
            let item = UITabBarItem(title: nil, image: normalImage, selectedImage: selectedImage)
            item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            return item
        }

        // 0 Home · 1 Discover · 2 Community · 3 Profile
        // Message list / chat are secondary pages (pushed from header bell).
        let home = UINavigationController(rootViewController: HomeViewController())
        home.tabBarItem = makeItem(normal: "tab_home", selected: "tab_home_sel")

        let discover = UINavigationController(rootViewController: DiscoverViewController())
        discover.tabBarItem = makeItem(normal: "tab_discover", selected: "tab_discover_sel")

        let community = UINavigationController(rootViewController: CommunityViewController())
        community.tabBarItem = makeItem(normal: "tab_message", selected: "tab_message_sel")

        let profile = UINavigationController(rootViewController: ProfileViewController())
        profile.tabBarItem = makeItem(normal: "tab_profile", selected: "tab_profile_sel")

        viewControllers = [home, discover, community, profile]
    }
}
