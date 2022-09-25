import Vapor

extension Blog {
    func registerMigrations() {
        app.migrations.add(
            [
                CreateCitextExtension(),
                CreateUserTable(),
                CreatePasswordTable(),
                CreatePasswordLoginCredentialsView(),
                CreateJournalEntryTable(),
            ],
            to: .psql)
    }
}
