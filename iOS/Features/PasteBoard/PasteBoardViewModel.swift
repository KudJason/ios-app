import Combine
import Foundation
import UIKit

class PasteBoardViewModel: ObservableObject {
    @Published var showPasteBoardView: Bool = false {
        willSet {
            if newValue {
                if let pasteBoardString = UIPasteboard.general.string, let newPasteBoardUrl = URL(string: pasteBoardString) {
                    WallabagUserDefaults.previousPasteBoardUrl = newPasteBoardUrl.absoluteString
                    pasteBoardUrl = newPasteBoardUrl.absoluteString
                }
            }
        }
    }

    @Published var pasteBoardUrl: String = ""
    @Injector var session: WallabagSession

    private var cancellableNotification: AnyCancellable?

    init() {
        cancellableNotification = NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .map { _ -> Bool in
                guard let pasteBoardString = UIPasteboard.general.string, let pasteBoardUrl = URL(string: pasteBoardString),
                      pasteBoardUrl.absoluteString != WallabagUserDefaults.previousPasteBoardUrl
                else {
                    return false
                }
                return true
            }
            .assign(to: \.showPasteBoardView, on: self)
    }

    deinit {
        cancellableNotification?.cancel()
    }

    func addUrl() {
        session.addEntry(url: pasteBoardUrl) {}
        showPasteBoardView = false
    }

    func hide() {
        showPasteBoardView = false
    }
}
