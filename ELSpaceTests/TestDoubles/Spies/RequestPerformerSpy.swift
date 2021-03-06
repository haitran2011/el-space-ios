@testable import ELSpace

import RxSwift
import Alamofire

class RequestPerformerSpy: Requesting {

    var response: Response?
    private(set) var url: URLConvertible?
    private(set) var method: HTTPMethod?
    private(set) var parameters: Parameters?
    private(set) var headers: HTTPHeaders?

    // MARK: - Requesting

    func request(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?) -> Observable<Response> {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.headers = headers
        return response == nil ? Observable.empty() : Observable.just(response!)
    }

}
