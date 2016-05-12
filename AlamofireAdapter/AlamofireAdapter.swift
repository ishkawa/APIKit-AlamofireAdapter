import Foundation
import Alamofire
import APIKit

extension Alamofire.Request: SessionTaskType {


}

public class AlamofireAdapter: SessionAdapterType {
    public enum Error: ErrorType {
        case UnknownMethod(String)

    }

    public let manager: Alamofire.Manager

    public init(manager: Alamofire.Manager) {
        self.manager = manager
    }

    public func createTaskWithRequest<Request : RequestType>(request: Request, handler: (NSData?, NSURLResponse?, ErrorType?) -> Void) throws -> SessionTaskType {
        guard let method = Alamofire.Method(rawValue: request.method.rawValue) else {
            throw Error.UnknownMethod(request.method.rawValue)
        }

        let URL = try request.buildURL()
        var headerFields = request.headerFields

        let bodyParameters = request.bodyParameters
        if let bodyContentType = bodyParameters?.contentType {
            headerFields["Content-Type"] = bodyContentType
        }

        if let acceptContentType = request.dataParser.contentType {
            headerFields["Accept"] = acceptContentType
        }

        let alamofireRequest: Alamofire.Request

        switch try request.bodyParameters?.buildEntity() {
        case .Data(let data)?:
            alamofireRequest = manager.upload(method, URL, headers: headerFields, data: data)

        case .InputStream(let inputStream)?:
            alamofireRequest = manager.upload(method, URL, headers: headerFields, stream: inputStream)

        default:
            alamofireRequest = manager.request(method, URL, headers: headerFields)
        }

        alamofireRequest.responseData { response in
            handler(response.data, response.response, response.result.error)
        }

        return alamofireRequest
    }

    public func getTasksWithHandler(handler: [SessionTaskType] -> Void) {
        manager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            let allTasks = dataTasks as [NSURLSessionTask]
                + uploadTasks as [NSURLSessionTask]
                + downloadTasks as [NSURLSessionTask]

            handler(allTasks.map { $0 })
        }
    }
}
