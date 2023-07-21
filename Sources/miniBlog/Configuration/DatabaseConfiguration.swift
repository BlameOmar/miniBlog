struct DatabaseConfiguration: Codable {
    let host: String
    let username: String
    let password: Secret<String>
    let database: String
}
