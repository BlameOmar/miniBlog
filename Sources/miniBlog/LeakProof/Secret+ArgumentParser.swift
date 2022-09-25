import ArgumentParser

extension Secret: ExpressibleByArgument where Wrapped: ExpressibleByArgument {
    init?(argument: String) {
        guard let value = Wrapped(argument: argument) else {
            return nil
        }
        self.init(value)
    }
}
