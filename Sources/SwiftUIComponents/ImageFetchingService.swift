#if canImport(UIKit)
import UIKit

public protocol ImageFetchingService: class {
    func perform(
        request: URLRequest,
        withCompletion completion: @escaping (Result<UIKit.UIImage, Swift.Error>) -> Void
    )
    func cancel(request: URLRequest)
}
#endif
