#if canImport(UIKit)
import SwiftUI
import FoundationUtils

@available(iOS 13.0, *)
public struct RemoteImage: View {

    private let request: URLRequest
    private let imageFetchingService: ImageFetchingService
    private let loading: Color
    private let failure: Color

    @State private var image: Async<Result<UIImage, Swift.Error>> = .initial

    public init(
        request: URLRequest,
        loading: Color = .gray,
        failure: Color = .gray,
        imageFetchingService: ImageFetchingService = DefaultImageFetchingService.shared
    ) {
        self.request = request
        self.loading = loading
        self.failure = failure
        self.imageFetchingService = imageFetchingService
    }

    public var body: some View {
        switch image {
        case .initial:
            return AnyView(
                Rectangle()
                    .onAppear {
                        self.image = .loading
                        self.imageFetchingService.perform(request: self.request) { result in
                            self.image = .loaded(result)
                        }
                }
            )
        case .loading:
            return AnyView(
                Rectangle()
                    .fill(self.loading)
                    .onDisappear {
                        self.imageFetchingService.cancel(request: self.request)
                }
            )
        case .loaded(let result):
            switch result {
            case .failure:
                return AnyView(Rectangle().fill(self.failure))
            case .success(let image):
                return AnyView(
                    Image(uiImage: image)
                        .resizable()
                )
            }
        }
    }
}

extension RemoteImage {
    public enum Error: Swift.Error {
        case malformedImageData
    }
}

extension RemoteImage {
    public init(
        url: URL,
        loading: Color = .gray,
        failure: Color = .gray,
        imageFetchingService: ImageFetchingService = DefaultImageFetchingService.shared
    ) {
        self.init(
            request: URLRequest(url: url),
            loading: loading,
            failure: failure,
            imageFetchingService: imageFetchingService
        )
    }
}

#endif
