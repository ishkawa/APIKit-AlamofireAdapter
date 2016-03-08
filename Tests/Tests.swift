import XCTest
import APIKit
import Alamofire
import AlamofireAdapter

class Tests: XCTestCase {
    struct ExampleRequest: RequestType {
        typealias Response = Void

        var baseURL: NSURL {
            return NSURL(string: "https://example.com")!
        }

        var method: HTTPMethod {
            return .GET
        }

        var path: String {
            return "/"
        }

        var responseBodyParser: ResponseBodyParser {
            return .Custom(acceptHeader: "*/*", parseData: { data in
                return NSObject()
            })
        }

        func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) throws -> Response {
            return ()
        }
    }

    func testExample() {
        let adapter = AlamofireAdapter(manager: Alamofire.Manager.sharedInstance)
        let session = Session(adapter: adapter)
        let request = ExampleRequest()
        let expectation = expectationWithDescription("wait for the response")

        session.sendRequest(request) { result in
            switch result {
            case .Success:
                break

            case .Failure:
                XCTFail()
            }

            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(1.0, handler: nil)
    }
}
