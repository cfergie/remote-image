#if canImport(UIKit)
import UIKit

public final class DefaultImageFetchingService: ImageFetchingService {

    public static let shared: DefaultImageFetchingService = DefaultImageFetchingService()

    private let urlSession: URLSession
    private var requests: [URLRequest: URLSessionDataTask] = [:]

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    convenience init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        let session = URLSession(configuration: config)
        self.init(urlSession: session)
    }

    public func perform(
        request: URLRequest,
        withCompletion completion: @escaping (Result<UIImage, Swift.Error>) -> Void
    ) {
        let dataTask = urlSession.dataTask(with: request) { (data, response, error) in
            _ = self.requests.removeValue(forKey: request)

            completion(Result {
                if let error = error {
                    throw error
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    throw Error.nonHTTPResponse
                }

                guard httpResponse.statusCode < 400 else {
                    throw Error.httpError(httpResponse.statusCode)
                }

                guard let data = data else {
                    throw Error.noData
                }

                guard let image = UIImage(data: data) else {
                    throw Error.invalidImageData
                }

                return image
            })
        }
        dataTask.resume()

        requests[request] = dataTask
    }

    public func cancel(request: URLRequest) {
        let cancelledTask = requests.removeValue(forKey: request)
        cancelledTask?.cancel()
    }
}

extension DefaultImageFetchingService {
    enum Error: Swift.Error {
        case nonHTTPResponse
        case httpError(Int)
        case noData
        case invalidImageData
    }
}
#endif
