# NetworkClient

A lightweight and simple Swift library for making network requests in iOS applications using `URLSession`. This library provides an easy way to handle HTTP requests and parse responses using `Decodable` types.

## Features

- ✅ Supports GET, POST, PUT, DELETE, and other HTTP methods.
- ✅ Decodes JSON responses automatically.
- ✅ Uses `URLSession` with dependency injection support.
- ✅ Handles common HTTP errors gracefully.
- ✅ Fully asynchronous with Swift Concurrency (`async/await`).

## Installation

### Swift Package Manager (SPM)

To add `NetworkClient` to your project, follow these steps:

1. Open Xcode and navigate to `File > Swift Packages > Add Package Dependency`.
2. Enter the repository URL:
   ```sh
   https://github.com/novecapa/DCNetworkClient.git
   ```
3. Choose the latest version and add it to your project.

## Usage

### Importing the Library
```swift
import NetworkClient
```

### Creating an Instance of NetworkClient
```swift
let networkClient = DCNetworkClient(urlSession: URLSession.shared)
```

### Making a Network Request
```swift
struct User: Decodable {
    let id: Int
    let name: String
}

Task {
    do {
        let user: User = try await networkClient.call(
            baseURL: "https://api.example.com/user/1",
            method: .get,
            of: User.self
        )
        print("User name: \(user.name)")
    } catch {
        print("Request failed: \(error)")
    }
}
```

## Error Handling
The `DCNetworkClient` throws `NetworkError` cases:
- `.badURL` – Invalid URL.
- `.badResponse` – No valid response received.
- `.badRequest` – 4xx client errors.
- `.serverError` – 5xx server errors.

## Contributing
Contributions are welcome! Feel free to submit a pull request or open an issue.

## License
This project is licensed under the MIT License.

## Contact
For any questions or support, reach out

