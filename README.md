[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=plastic)](https://github.com/Carthage/Carthage)
![Swift 5.0 compatible](https://img.shields.io/static/v1?label=Swift&message=5.0&style=plastic&logo=appveyo)
![Swift 5.0 compatible](https://img.shields.io/static/v1?label=Minimum%20iOS%20version&message=13.2&color=F76831&style=plastic&logo=appveyo)

# NetworkSession

This is network abstraction layer written in Swift

## ⚒ Instalation

### Carthage
To install it, simply add the following line to your .cartfile

`github "danielrsousa/NetworkSession" ~> 1.0`

## ❓ How to use 

Step 1: Create your request object:

```swift
struct MyRequest: ApiRequestProtocol {
    var baseURL = "https:/myservice"
    var path: String
    var method: HTTPMethod  = .get
    var headers: [String : String]?
    var parameters: [String : Any]
}
```

Step 2: Create your model implements Decodable protocol:

```swift
struct MyModel: Decodable {
    let id: Int?
    let name: String?
    let description: String?
    let thumbnail : Thumbnail?
}
```

Step 3: Now you need create a instance of NetworkSession and call method `.request`:

```swift
class MyClass {
  let networkSession: NetworkProtocol = NetworkSession.shared
  
  func fetch(completion: @escaping (Result<[MyModel], ApiError>) -> Void) {
    let request = MyRequest(path: "/v1/public/endpoint", parameters: [:])

    networkSession.request(request: request, result: {(result: Result<Response<MyModel>, ApiError>) in
        switch result {
        case .success(let response):
            completion(.success(response.results))
        case .failure(let error):
            completion(.failure(error))
        }
    })
  }
}
```

## 📝 License

NetworkSession is released under the [MIT License](LICENSE.md).





