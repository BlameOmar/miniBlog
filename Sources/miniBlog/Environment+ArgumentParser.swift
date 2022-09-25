import ArgumentParser

extension Environment.EnvironmentType: ExpressibleByArgument {}

extension Environment: ExpressibleByArgument {
    init?(argument: String) {
        let components = argument.split(separator: ".", maxSplits: 1)
        guard !components.isEmpty, let type = EnvironmentType(argument: String(components.first!)) else {
            return nil
        }
        guard components.count == 2, let name = components.last else {
            self.init(type: type)
            return
        }

        self.init(type: type, name: String(name))
    }
}

extension Environment.Parameters {
    subscript<T: ExpressibleByArgument>(name: String) -> T? {
        guard let value = self[name] else { return nil }
        return T(argument: value)
    }
}
