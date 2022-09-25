import SafeHTML
import Vapor

protocol HTMLView: ResponseEncodable, AsyncResponseEncodable {
    @HTMLBuilder var body: HTMLSafeString { get }
}

extension HTMLView {
    func encodeResponse(for request: Request) -> EventLoopFuture<Response> {
        let response = Response()
        response.headers.contentType = .html
        response.body = .init(buffer: ByteBuffer(string: .init(body)))
        return request.eventLoop.makeSucceededFuture(response)
    }

    func encodeResponse(for request: Request) async throws -> Response {
        let response = Response()
        response.headers.contentType = .html
        response.body = .init(buffer: ByteBuffer(string: .init(body)))
        return response
    }
}

extension HTMLBuilder {
    static func buildExpression(_ expression: HTMLView) -> HTMLSafeString {
        expression.body
    }
}
