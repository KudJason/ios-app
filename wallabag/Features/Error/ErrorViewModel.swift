import Combine
import Foundation

class ErrorViewModel: ObservableObject {
    static var shared = ErrorViewModel()

    private var resetAfter: Double

    init(_ resetAfter: Double = 10) {
        self.resetAfter = resetAfter
    }

    @Published private(set) var lastError: WallabagError?

    func setLast(_ error: WallabagError) {
        lastError = error
        DispatchQueue.main.asyncAfter(deadline: .now() + resetAfter) { [weak self] in
            self?.lastError = nil
        }
    }
}
