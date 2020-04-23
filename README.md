[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=plastic)](https://github.com/Carthage/Carthage)
![Swift 5.0 compatible](https://img.shields.io/static/v1?label=Swift&message=5.0&style=plastic&logo=appveyo)
![Swift 5.0 compatible](https://img.shields.io/static/v1?label=Minimum%20iOS%20version&message=13.2&color=F76831&style=plastic&logo=appveyo)

# NetworkSession

This is network abstraction layer written in Swift

## ⚒ Instalation

### CocoaPods
Add this line in .podfile

`pod "NetworkSession" ~> 1.1.2`

### Carthage
To install it, simply add the following line to your .cartfile

`github "danielrsousa/NetworkSession" ~> 1.1.2`

## ❓ How to use 

Step 1 Create your request object:

```swift
struct MyRequest: NetworkRequestProtocol {
    var baseURL = "https://blockchain.info"
    var path: String = "/ticker"
    var method: HTTPMethod  = .get
    var headers: [String : String]?
    var parameters: [String : Any]
}
```

Step 2 Create your model using the Decodable protocol:

```swift
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
```

Step 3 Now you need create a instance of NetworkSession and call method `.request`, don't forget to `import NetworkSession`:

```swift
import Foundation
import NetworkSession

class MyClass {
    let networkSession: NetworkProtocol = NetworkSession.shared
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
```

## 📝 License

NetworkSession is released under the [MIT License](LICENSE.md).





