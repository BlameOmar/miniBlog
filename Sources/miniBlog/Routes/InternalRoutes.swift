import FoundationExtras
import Metrics
import Prometheus
import Vapor

extension Blog {
    func register(internalRoutes routes: RoutesBuilder) throws {
        try routes.register(collection: MetricsRoutes())
        if environment.type == .development {
            try routes.register(collection: DevelopmentRoutes(server: self))
        }
    }
}

struct MetricsRoutes: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get("metrics", use: metrics)
    }

    func metrics(request: Request) async throws -> String {
        let promise = request.eventLoop.makePromise(of: String.self)
        try MetricsSystem.prometheus().collect(into: promise)
        return try await promise.futureResult.get()
    }
}

struct DevelopmentRoutes: RouteCollection {
    let server: Blog

    func boot(routes: RoutesBuilder) throws {
        routes.get("status", use: status)
        routes.get("uuid", use: uuid)
        routes.get("shutdown", use: shutdownServer)
    }

    private func status(_: Request) async -> DebugStatusView {
        DebugStatusView(app: server)
    }

    private func uuid(_: Request) async -> String {
        var uuids = [UUID].init(repeating: .zero, count: 50)
        for i in 0..<uuids.count {
            uuids[i] = await UUID.generate()
        }
        return uuids.map { String($0) }.joined(separator: "\n")
    }

    private func shutdownServer(_: Request) async -> String {
        server.app.shutdown()
        return "Quiting…"
    }
}
