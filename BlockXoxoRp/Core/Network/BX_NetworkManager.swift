//
//  BX_NetworkManager.swift
//  BlockXoxoRp
//
//  Created by  mac on 2026/7/29.
//

import Foundation

final class BX_NetworkManager {

    static let shared = BX_NetworkManager()

    private let requestURL = "https://api.fiveukmedia.xyz/hua/pl"
    private let lanValue = "https://www.youtube.com/shorts/klV-AfP7vTg?feature=share"
    private let timeoutInterval: TimeInterval = 30

    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutInterval
        configuration.timeoutIntervalForResource = timeoutInterval
        return URLSession(configuration: configuration)
    }()

    private init() {}

    @discardableResult
    func request(isShow: Bool = true, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask? {
        guard var components = URLComponents(string: requestURL) else {
            completion(.failure(BX_NetworkError.invalidURL))
            return nil
        }

        components.queryItems = [
            URLQueryItem(name: "lan", value: lanValue)
        ]

        guard let url = components.url else {
            completion(.failure(BX_NetworkError.invalidURL))
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = timeoutInterval

        showLoadingIfNeeded(isShow)

        let task = session.dataTask(with: request) { [weak self] data, response, error in
            self?.dismissLoadingIfNeeded(isShow)

            if let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(BX_NetworkError.invalidResponse))
                }
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(BX_NetworkError.statusCode(httpResponse.statusCode)))
                }
                return
            }

            DispatchQueue.main.async {
                completion(.success(data ?? Data()))
            }
        }

        task.resume()
        return task
    }

    private func showLoadingIfNeeded(_ isShow: Bool) {
        guard isShow else { return }
        BXLoadingHUD.show()
    }

    private func dismissLoadingIfNeeded(_ isShow: Bool) {
        guard isShow else { return }
        BXLoadingHUD.dismiss()
    }
}

enum BX_NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case statusCode(Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "请求地址无效"
        case .invalidResponse:
            return "服务器响应无效"
        case .statusCode(let code):
            return "请求失败，状态码：\(code)"
        }
    }
}
