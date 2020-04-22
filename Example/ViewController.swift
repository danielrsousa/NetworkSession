//
//  ViewController.swift
//  Example
//
//  Created by Daniel Rocha on 4/22/20.
//  Copyright © 2020 Daniel Rocha. All rights reserved.
//

import UIKit
import NetworkSession

class ViewController: UIViewController {

    let networkSession: NetworkProtocol = NetworkSession.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
    }

    func fetch() {
        let request = MyRequest(parameters: [:])

        networkSession.request(request: request, result: {(result: Result<CurrencyModel?, NetworkError>) in
            switch result {
            case .success(let response):
                guard let model = response else { return }
                print(model.BRL.symbol)
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}

struct MyRequest: NetworkRequestProtocol {
    var baseURL = "https://blockchain.info"
    var path: String = "/ticker"
    var method: HTTPMethod  = .get
    var headers: [String : String]?
    var parameters: [String : Any]
}

struct CurrencyModel: Decodable {
    let USD: CoinModel
    let BRL: CoinModel
    
    struct CoinModel: Decodable {
        let last: Float
        let buy: Float
        let sell: Float
        let symbol: String
    }
}
