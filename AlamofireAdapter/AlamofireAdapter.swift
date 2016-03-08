import Foundation
import Alamofire
import APIKit

class AlamofireAdapter: SessionAdapterType {
    let manager: Alamofire.Manager

    init(manager: Alamofire.Manager) {
        self.manager = manager
    }

    func resumedTaskWithURLRequest(URLRequest: NSURLRequest, handler: (NSData?, NSURLResponse?, NSError?) -> Void) -> SessionTaskType {
        let request = Alamofire.request(URLRequest)

        request.responseData { response in
            handler(response.data, response.response, response.result.error)
        }

        return request.task
    }

    func getTasksWithHandler(handler: [SessionTaskType] -> Void) {
        manager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            let allTasks = dataTasks as [NSURLSessionTask]
                + uploadTasks as [NSURLSessionTask]
                + downloadTasks as [NSURLSessionTask]

            handler(allTasks.map { $0 })
        }
    }
}
