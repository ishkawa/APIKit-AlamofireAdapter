import XCTest
import APIKit
import Alamofire
import AlamofireAdapter


class Tests: XCTestCase {
    class StringDataParser: DataParserType {
        enum Error: ErrorType {
            case InvlidaData(NSData)
        }

        var contentType: String? {
            return nil
        }

        func parseData(data: NSData) throws -> AnyObject {
            guard let string = NSString(data: data, encoding: NSUTF8StringEncoding) else {
                throw Error.InvlidaData(data)
            }

            return string
        }
    }

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

        var dataParser: DataParserType {
            return StringDataParser()
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

        waitForExpectationsWithTimeout(10.0, handler: nil)
    }
}
