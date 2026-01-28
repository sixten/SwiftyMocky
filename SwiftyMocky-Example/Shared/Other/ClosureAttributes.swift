import Foundation

//sourcery: AutoMockable
protocol ProtocolWithClosureAttributes {
    func open(_ url: URL, completionHandler completion: (@MainActor @Sendable (Bool) -> Void)?)
}
