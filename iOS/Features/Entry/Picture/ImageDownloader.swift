import Combine
import Foundation
#if canImport(UIKit)
    import UIKit
#endif

final class ImageDownloader {
    static var shared = ImageDownloader()

    private var cacheStore = ImageCache.shared

    private var dispatchQueue = DispatchQueue(label: "fr.district-web.wallabag.image-downloader", qos: .background)

    private init() {}

    func loadImage(url: URL) async -> UIImage? {
        if let imageCache = await cacheStore[url.absoluteString] {
            return imageCache
        }

        var request = URLRequest(url: url)
        request.allowsConstrainedNetworkAccess = false

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            guard let image = UIImage(data: data) else { return nil }

            await cacheStore.set(image, for: url.absoluteString)

            return image
        } catch {}

        return nil
    }

    /*
     func loadImage(url: URL) -> AnyPublisher<UIImage?, Never> {
         if let imageCache = cacheStore[url.absoluteString] {
             return Just(imageCache).eraseToAnyPublisher()
         }

         var request = URLRequest(url: url)
         request.allowsConstrainedNetworkAccess = false

         return URLSession.shared.dataTaskPublisher(for: request)
             .subscribe(on: dispatchQueue)
             .compactMap { [unowned self] in
                 guard let image = UIImage(data: $0.data) else { return nil }
                 self.cacheStore[url.absoluteString] = image
                 return image
             }
             .replaceError(with: nil)
             .eraseToAnyPublisher()
     }
      */
}
