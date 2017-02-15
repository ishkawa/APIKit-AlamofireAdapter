import Foundation
import Alamofire
import APIKit

open class AlamofireAdapter: SessionAdapter {
    open let manager: Alamofire.SessionManager

    public init(manager: Alamofire.SessionManager) {
        self.manager = manager
    }

    public func createTask(with URLRequest: URLRequest, handler: @escaping (Data?, URLResponse?, Error?) -> Void) -> SessionTask {
        let request = manager.request(URLRequest)

        request.responseData { response in
            handler(response.data, response.response, response.result.error)
        }

        return request.task!
    }

    public func getTasks(with handler: @escaping ([SessionTask]) -> Void) {
        manager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            let allTasks = dataTasks as [URLSessionTask]
                + uploadTasks as [URLSessionTask]
                + downloadTasks as [URLSessionTask]

            handler(allTasks.map { $0 })
        }
    }
}
