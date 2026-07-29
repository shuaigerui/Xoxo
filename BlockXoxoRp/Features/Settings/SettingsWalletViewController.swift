import UIKit
import SnapKit
import WebKit
import StoreKit

final class SettingsViewController: UIViewController {
    private let items = [
        "Blacklist",
        "Privacy agreement",
        "User agreement",
        "Contact Us",
        "Log out",
        "Deletion of account"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = BXColor.background

        let nav = BXNavBar()
        nav.configure(title: "Setting", showBack: true)
        nav.backButton.setImage(UIImage(named: "setting_back") ?? UIImage(named: "common_back"), for: .normal)
        nav.onBack = { [weak self] in self?.navigationController?.popViewController(animated: true) }
        view.addSubview(nav)
        nav.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }

        let scroll = UIScrollView()
        view.addSubview(scroll)
        scroll.snp.makeConstraints {
            $0.top.equalTo(nav.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        let box = UIView()
        scroll.addSubview(box)
        box.snp.makeConstraints {
            $0.edges.equalTo(scroll.contentLayoutGuide)
            $0.width.equalTo(scroll.frameLayoutGuide)
        }

        var anchor = box.snp.top
        for (idx, title) in items.enumerated() {
            let btn = UIButton(type: .system)
            btn.backgroundColor = BXColor.card
            btn.setTitle("  \(title)", for: .normal)
            btn.setTitleColor(.white, for: .normal)
            btn.contentHorizontalAlignment = .left
            btn.titleLabel?.font = BXFont.headline(15)
            btn.bx_round(14)
            btn.tag = idx
            btn.addTarget(self, action: #selector(itemTap(_:)), for: .touchUpInside)
            let arrow = UIImageView(image: UIImage(named: "profile_next"))
            arrow.contentMode = .scaleAspectFit
            btn.addSubview(arrow)
            arrow.snp.makeConstraints {
                $0.trailing.equalToSuperview().offset(-14)
                $0.centerY.equalToSuperview()
                $0.size.equalTo(14)
            }
            box.addSubview(btn)
            btn.snp.makeConstraints {
                $0.top.equalTo(anchor).offset(idx == 0 ? 16 : 12)
                $0.leading.trailing.equalToSuperview().inset(16)
                $0.height.equalTo(52)
            }
            anchor = btn.snp.bottom
        }
        let spacer = UIView()
        box.addSubview(spacer)
        spacer.snp.makeConstraints {
            $0.top.equalTo(anchor).offset(40)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(20)
        }
    }

    @objc private func itemTap(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            bx_push(BlacklistViewController())
        case 1:
            bx_push(BXWebController(titleText: "Privacy agreement", urlString: "https://docs.google.com/document/d/1GlF9RwIwONii4Ejk3jNV_my2KsK4kAtdraYrkhzG5LU/edit?usp=sharing"))
        case 2:
            bx_push(BXWebController(titleText: "User agreement", urlString: "https://docs.google.com/document/d/1tNnVmVtTnx6cIhSgakVZn90WwnuAtdDLphtTmPPm_H4/edit?usp=sharing"))
        case 3:
            bx_push(BX_ContactViewController())
        case 4:
            BXDialog.show(on: self, title: "Log out?", message: "You can sign in again anytime.", confirmTitle: "Log out", cancelTitle: "Cancel", confirm: {
                BX_NetworkManager.shared.request { _ in
                    CurrentUserSession.shared.signOut()
                    RootRouter.showLogin()
                }
            })
        case 5:
            BXDialog.show(on: self, title: "Delete account?", message: "This will remove your local profile and posts from this device.", confirmTitle: "Delete", cancelTitle: "Cancel", confirm: {
                BX_NetworkManager.shared.request { _ in
                    CurrentUserSession.shared.deleteAccount()
                    RootRouter.showLogin()
                }
            })
        default: break
        }
    }
}

final class BlacklistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var users: [UserProfile] = []
    private let table = UITableView(frame: .zero, style: .plain)
    private let empty = BXEmptyView()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = BXColor.background
        let nav = BXNavBar()
        nav.configure(title: "Blacklist", showBack: true)
        nav.onBack = { [weak self] in self?.navigationController?.popViewController(animated: true) }
        view.addSubview(nav)
        nav.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.dataSource = self
        table.delegate = self
        table.register(BlackCell.self, forCellReuseIdentifier: "c")
        view.addSubview(table)
        table.snp.makeConstraints {
            $0.top.equalTo(nav.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        view.addSubview(empty)
        empty.snp.makeConstraints { $0.edges.equalTo(table) }
        BX_NetworkManager.shared.request { _ in
            self.reload()
        }
    }

    private func reload() {
        let ids = CurrentUserSession.shared.user?.blockedIds ?? []
        users = ids.compactMap { CurrentUserSession.shared.user(by: $0) }
        empty.isHidden = !users.isEmpty
        table.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { users.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "c", for: indexPath) as! BlackCell
        let u = users[indexPath.row]
        cell.bind(u)
        cell.onRemove = { [weak self] in
            CurrentUserSession.shared.unblockUser(u.id) { _ in self?.reload() }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 76 }
}

final class BlackCell: UITableViewCell {
    var onRemove: (() -> Void)?
    private let avatar = UIImageView()
    private let name = UILabel()
    private let del = UIButton(type: .custom)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        let card = UIView()
        card.backgroundColor = BXColor.card
        card.bx_round(12)
        contentView.addSubview(card)
        card.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16))
        }
        avatar.bx_round(22)
        name.textColor = .white
        name.font = BXFont.headline(15)
        del.setImage(UIImage(named: "black_del"), for: .normal)
        del.addTarget(self, action: #selector(rm), for: .touchUpInside)
        [avatar, name, del].forEach { card.addSubview($0) }
        avatar.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(44)
        }
        name.snp.makeConstraints {
            $0.leading.equalTo(avatar.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
        }
        del.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-12)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(32)
        }
    }
    required init?(coder: NSCoder) { fatalError() }
    func bind(_ u: UserProfile) {
        avatar.bx_avatar(u.avatarName)
        name.text = u.nickname
    }
    @objc private func rm() { onRemove?() }
}

final class BXWebController: UIViewController {
    private let titleText: String
    private let urlString: String
    init(titleText: String, urlString: String) {
        self.titleText = titleText
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = BXColor.background
        let nav = BXNavBar()
        nav.configure(title: titleText, showBack: true)
        nav.onBack = { [weak self] in self?.navigationController?.popViewController(animated: true) }
        view.addSubview(nav)
        nav.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }
        let web = WKWebView()
        view.addSubview(web)
        web.snp.makeConstraints {
            $0.top.equalTo(nav.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        if let url = URL(string: urlString) {
            web.load(URLRequest(url: url))
        }
    }
}

final class WalletViewController: UIViewController {
    private let packs: [CoinPack] = [
        CoinPack(productId: "fxkpgbzeikxrbjiu", coins: 63700, priceText: "$99.99", price: 99.99),
        CoinPack(productId: "aphzviolhauqweaj", coins: 29400, priceText: "$49.99", price: 49.99),
        CoinPack(productId: "crcsqbbwqykveuxw", coins: 10800, priceText: "$19.99", price: 19.99),
        CoinPack(productId: "soorwnaliinignbn", coins: 5150, priceText: "$9.99", price: 9.99),
        CoinPack(productId: "dsvpouxsbcjbjozc", coins: 2450, priceText: "$4.99", price: 4.99),
        CoinPack(productId: "recvkuvzngxrewit", coins: 800, priceText: "$1.99", price: 1.99),
        CoinPack(productId: "vlusjghsogwcwbfc", coins: 400, priceText: "$0.99", price: 0.99)
    ]
    private let balanceLabel = UILabel()
    private var products: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = BXColor.background

        let nav = BXNavBar()
        nav.configure(title: "Get more coins", showBack: true)
        nav.onBack = { [weak self] in self?.navigationController?.popViewController(animated: true) }
        view.addSubview(nav)
        nav.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }

        let scroll = UIScrollView()
        view.addSubview(scroll)
        scroll.snp.makeConstraints {
            $0.top.equalTo(nav.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        let box = UIView()
        scroll.addSubview(box)
        box.snp.makeConstraints {
            $0.edges.equalTo(scroll.contentLayoutGuide)
            $0.width.equalTo(scroll.frameLayoutGuide)
        }

        let coin = UIImageView(image: UIImage(named: "wallet_coin"))
        coin.contentMode = .scaleAspectFit
        box.addSubview(coin)
        coin.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(96)
        }

        balanceLabel.text = "\(CurrentUserSession.shared.user?.coins ?? 0)"
        balanceLabel.textColor = .white
        balanceLabel.font = BXFont.title(18)
        balanceLabel.textAlignment = .center
        balanceLabel.backgroundColor = BXColor.card
        balanceLabel.bx_round(16)
        box.addSubview(balanceLabel)
        balanceLabel.snp.makeConstraints {
            $0.top.equalTo(coin.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(32)
            $0.width.greaterThanOrEqualTo(80)
        }

        let tip = UILabel()
        tip.text = "Use Coins to publish your builds."
        tip.textColor = .white
        tip.font = BXFont.body(13)
        tip.textAlignment = .center
        box.addSubview(tip)
        tip.snp.makeConstraints {
            $0.top.equalTo(balanceLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }

        var anchor = tip.snp.bottom
        for (idx, pack) in packs.enumerated() {
            let row = UIButton(type: .system)
            row.backgroundColor = BXColor.walletRow
            row.bx_round(14)
            row.tag = idx
            row.addTarget(self, action: #selector(buyTap(_:)), for: .touchUpInside)
            let icon = UIImageView(image: UIImage(named: "wallet_coin"))
            icon.contentMode = .scaleAspectFit
            let amount = UILabel()
            amount.text = "\(pack.coins)"
            amount.textColor = .white
            amount.font = BXFont.headline(16)
            let price = UILabel()
            price.text = pack.priceText
            price.textColor = .white
            price.font = BXFont.headline(15)
            [icon, amount, price].forEach { row.addSubview($0) }
            icon.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(14)
                $0.centerY.equalToSuperview()
                $0.size.equalTo(28)
            }
            amount.snp.makeConstraints {
                $0.leading.equalTo(icon.snp.trailing).offset(10)
                $0.centerY.equalToSuperview()
            }
            price.snp.makeConstraints {
                $0.trailing.equalToSuperview().offset(-16)
                $0.centerY.equalToSuperview()
            }
            box.addSubview(row)
            row.snp.makeConstraints {
                $0.top.equalTo(anchor).offset(idx == 0 ? 24 : 12)
                $0.leading.trailing.equalToSuperview().inset(16)
                $0.height.equalTo(56)
            }
            anchor = row.snp.bottom
        }
        let spacer = UIView()
        box.addSubview(spacer)
        spacer.snp.makeConstraints {
            $0.top.equalTo(anchor).offset(40)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(20)
        }

        Task { await loadProducts() }
        NotificationCenter.default.addObserver(self, selector: #selector(refreshBalance), name: .bxSessionChanged, object: nil)
    }

    @objc private func refreshBalance() {
        balanceLabel.text = "\(CurrentUserSession.shared.user?.coins ?? 0)"
    }

    private func loadProducts() async {
        do {
            let ids = Set(packs.map(\.productId))
            products = try await Product.products(for: ids)
        } catch {
            products = []
        }
    }

    @objc private func buyTap(_ sender: UIButton) {
        let pack = packs[sender.tag]
        Task { await purchase(pack) }
    }

    private func purchase(_ pack: CoinPack) async {
        let product = products.first { $0.id == pack.productId }
        do {
            if let product {
                let result = try await product.purchase()
                switch result {
                case .success(let verification):
                    if case .verified = verification {
                        await MainActor.run {
                            CurrentUserSession.shared.addCoins(pack.coins)
                            APIClient.shared.perform(path: APIPath.walletPurchase, body: ["productId": pack.productId, "coins": pack.coins]) { _ in }
                            BXDialog.show(on: self, message: "+\(pack.coins) coins added to your balance.", confirmTitle: "Continue")
                        }
                    }
                case .userCancelled, .pending:
                    break
                @unknown default:
                    break
                }
            } else {
                await MainActor.run {
                    BXDialog.show(on: self, message: "Store products are loading. Please try again in a moment.", confirmTitle: "Continue")
                }
            }
        } catch {
            await MainActor.run {
                BXDialog.show(on: self, message: "Purchase could not be completed. Please try again.", confirmTitle: "Continue")
            }
        }
    }
}
