import Fluent
import Foundation
import Vapor

struct JournalController: RouteCollection {

    static let timeZone: TimeZone = TimeZone.init(identifier: "America/New_York")!
    static let fullDateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = timeZone
        formatter.formatOptions = [.withFullDate, .withDashSeparatorInDate]
        return formatter
    }()
    static let yearAndMonthDateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = timeZone
        formatter.formatOptions = [.withYear, .withMonth, .withDashSeparatorInDate]
        return formatter
    }()
    static let yearDateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = timeZone
        formatter.formatOptions = [.withYear, .withDashSeparatorInDate]
        return formatter
    }()
    static let calendar: Calendar = {
        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = JournalController.timeZone
        calendar.firstWeekday = 2
        return calendar
    }()

    func boot(routes: RoutesBuilder) throws {
        routes.get(use: listEntries)
        routes.get("**", use: getEntry)
    }

    func listEntries(request: Request) async throws -> Response {
        try await listEntries(request: request, status: .ok)
    }

    func listEntries(request: Request, status: HTTPStatus = .ok) async throws -> Response {
        try await ListJournalEntriesView(authenticatedUser: request.auth.get(), blogConfiguration: request.application.blogConfiguration).encodeResponse(
            status: status, for: request)
    }

    //  func manageEntries(request: Request) async throws -> Response {
    //    guard request.auth.has(User.self) else {
    //      throw Abort(.unauthorized)
    //    }
    //
    //    return try await ManageJournalEntriesView(authenticatedUser: request.auth.get()).encodeResponse(for: request)
    //  }

    //  func newEntry(request: Request) async throws -> Response {
    //    guard let user = request.auth.get(User.self) else {
    //      throw Abort(.unauthorized)
    //    }
    //
    //    return try await NewJournalEntryView(authenticatedUser: user).encodeResponse(for: request)
    //  }

    //  struct CreateJournalEntryRequest: Content {
    //    let title: String
    //    let body: String
    //  }
    //
    //  func createEntry(request: Request) async throws -> Response {
    //    guard let user = request.auth.get(User.self) else {
    //      throw Abort(.unauthorized)
    //    }
    //    let requestBody = try request.content.decode(CreateJournalEntryRequest.self)
    //    let entry = JournalEntry(
    //      id: request.application.idGenerator.next(),
    //      author: user,
    //      title: requestBody.title,
    //      body: requestBody.body
    //    )
    //
    //    try await entry.save(on: request.db)
    //    return request.redirect(to: "/journal/\(entry.id!)/\(entry.name)")
    //  }

    //  func getEntry(request: Request) async throws -> Response {
    //    guard let idOrName: String = request.parameters.get("identifier") else {
    //      return try await listEntries(request: request, status: .badRequest)
    //    }
    //
    //    guard let entry = try await JournalEntry.find(resolving: idOrName, on: request.db) else {
    //      return try await listEntries(request: request, status: .notFound)
    //    }
    //
    //    try await entry.$author.load(on: request.db)
    //    return try await JournalEntryView(journalEntry: entry).encodeResponse(for: request)
    //  }
    //
    //  func getEntryByName(request: Request) async throws -> Response {
    //    guard let name: String = request.parameters.get("name") else {
    //      return try await listEntries(request: request, status: .badRequest)
    //    }
    //
    //    guard let entry = try await JournalEntry.find(resolving: name, on: request.db) else {
    //      return try await listEntries(request: request, status: .notFound)
    //    }
    //
    //    return try await JournalEntryView(journalEntry: entry).encodeResponse(for: request)
    //  }
    func getEntry(request: Request) async throws -> Response {
        let database = request.db
        let entry: JournalEntry?
        let args = request.parameters.getCatchall()
        switch args.count {
        case 1:
            if let id = UUID(args[0]) {
                entry = try await JournalEntry.find(id, on: database)
            } else {
                let name = args[0]
                entry = try await JournalEntry.find(name: name, on: database)
            }
        case 2:
            let startDate: Date
            let endDate: Date
            if let date = JournalController.fullDateFormatter.date(from: args[0]) {
                request.logger.info("First parameter is full date")
                startDate = date
                endDate = JournalController.calendar.date(byAdding: DateComponents(day: 1), to: date)!
            } else if let date = JournalController.yearAndMonthDateFormatter.date(from: args[0]) {
                request.logger.info("First parameter is year and month")
                startDate = date
                endDate = JournalController.calendar.date(byAdding: DateComponents(month: 1), to: date)!
            } else if let date = JournalController.yearDateFormatter.date(from: args[0]) {
                request.logger.info("First parameter is year")
                startDate = date
                endDate = JournalController.calendar.date(byAdding: DateComponents(year: 1), to: date)!
            } else {
                return try await listEntries(request: request, status: .badRequest)
            }

            let name = args[1]
            entry = try await JournalEntry.find(name: name, dateRange: startDate..<endDate, on: database)
        default:
            return try await listEntries(request: request, status: .badRequest)
        }

        guard let entry = entry else {
            return try await listEntries(request: request, status: .notFound)
        }

        try await entry.$author.load(on: request.db)
        return try await JournalEntryView(journalEntry: entry, blogConfiguration: request.application.blogConfiguration).encodeResponse(for: request)
    }
}
