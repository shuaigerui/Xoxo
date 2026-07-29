import UIKit
import SnapKit

final class WelcomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        let bg = UIImageView(image: UIImage(named: "welcome_bg"))
        bg.contentMode = .scaleAspectFill
        view.addSubview(bg)
        bg.snp.makeConstraints { $0.edges.equalToSuperview() }

        let start = UIButton(type: .custom)
        start.setImage(UIImage(named: "welcome_start"), for: .normal)
        start.addTarget(self, action: #selector(startTap), for: .touchUpInside)
        view.addSubview(start)
        start.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-28)
            $0.height.equalTo(56)
            $0.leading.trailing.equalToSuperview().inset(40)
        }
    }

    @objc private func startTap() {
        bx_push(GuideViewController(page: 0))
    }
}

final class GuideViewController: UIViewController {
    private let page: Int
    private let titles = ["Share Your Builds", "Join Brick Crews", "Chat & Inspire"]
    private let subs = [
        "Show off your amazing creations to the world.",
        "Find builders who love the same themes as you.",
        "Exchange tips and build together in BrickVerse."
    ]
    private let bgs = ["guide01_bg", "guide02_bg", "guide03_bg"]
    private let pages = ["guide01_page", "guide02_page", "guide03_page"]

    init(page: Int) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = UIColor(white: 0.96, alpha: 1)

        let title = UILabel()
        title.text = titles[page]
        title.font = BXFont.title(28)
        title.textColor = .black
        view.addSubview(title)
        title.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        let line = UIView()
        line.backgroundColor = BXColor.accent
        view.addSubview(line)
        line.snp.makeConstraints {
            $0.leading.equalTo(title)
            $0.top.equalTo(title.snp.bottom).offset(8)
            $0.width.equalTo(64)
            $0.height.equalTo(4)
        }

        let sub = UILabel()
        sub.text = subs[page]
        sub.font = BXFont.body(15)
        sub.textColor = .black
        sub.numberOfLines = 0
        view.addSubview(sub)
        sub.snp.makeConstraints {
            $0.top.equalTo(line.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        let art = UIImageView(image: UIImage(named: bgs[page]))
        art.contentMode = .scaleAspectFit
        view.addSubview(art)
        art.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        let dots = UIImageView(image: UIImage(named: pages[page]))
        dots.contentMode = .scaleAspectFit
        view.addSubview(dots)
        dots.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-28)
            $0.height.equalTo(12)
            $0.width.equalTo(48)
        }

        let next = UIButton(type: .custom)
        next.setImage(UIImage(named: "guide01_next"), for: .normal)
        next.addTarget(self, action: #selector(nextTap), for: .touchUpInside)
        view.addSubview(next)
        next.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.centerY.equalTo(dots)
            $0.size.equalTo(56)
        }
    }

    @objc private func nextTap() {
        if page < 2 {
            bx_push(GuideViewController(page: page + 1))
        } else {
            LocalStore.shared.isGuideFinished = true
            bx_push(LoginViewController())
        }
    }
}
