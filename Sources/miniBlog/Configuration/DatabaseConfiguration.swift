struct DatabaseConfiguration: Codable {
    let host: String
    let username: String
    let password: Secret<String>
    let database: String

    init(host: String, username: String, password: Secret<String>, database: String) {
        self.host = host
        self.username = username
        self.password = password
        self.database = database
    }
}
