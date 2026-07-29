//
//  BX_LaunchViewController.swift
//  BlockXoxoRp
//
//  Created by  mac on 2026/7/29.
//

import UIKit
import SnapKit

class BX_LaunchViewController: UIViewController {

    var completion: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationController?.navigationBar.isHidden = true

        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.completion?()
        }
    }

    private let bgView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.clipsToBounds = true
        v.image = UIImage(named: "launch_bg")
        return v
    }()
}
