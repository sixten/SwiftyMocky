import XCTest
import SwiftyMocky
#if os(iOS)
@testable import Mocky_Example_iOS
#else
@testable import Mocky_Example_macOS
#endif

class ClosureAttributeTests: XCTestCase {
    
    var service: ProtocolWithClosureAttributesMock!
    
    override func setUp() {
        super.setUp()
        
        service = ProtocolWithClosureAttributesMock()
    }
    
    override func tearDown() {
        service = nil
        
        super.tearDown()
    }
    
    func test_open() {
        Verify(service, .never, .open(.any, completionHandler: .any))
        service.open(URL(string: "https://example.com")!, completionHandler: .none)
        Verify(service, .once, .open(.any, completionHandler: .any))
    }
    
    func test_perform_open() async {
        Perform(service, .open(.any, completionHandler: .any, perform: { url, completion in
            Task { @MainActor in
                completion?(true)
            }
        }))
        await withCheckedContinuation { continuation in
            service.open(URL(string: "https://example.com")!) { _ in
                continuation.resume()
            }
        }
        Verify(service, .once, .open(.any, completionHandler: .any))
    }

}
