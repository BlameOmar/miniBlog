@resultBuilder
public struct HTMLBuilder {
    public static func buildBlock(_ components: HTMLSafeString...) -> HTMLSafeString {
        components.filter { !$0.string.isEmpty }.joined(separator: "\n")
    }

    public static func buildOptional(_ component: HTMLSafeString?) -> HTMLSafeString {
        component ?? HTMLSafeString()
    }

    public static func buildEither(first component: HTMLSafeString) -> HTMLSafeString {
        component
    }

    public static func buildEither(second component: HTMLSafeString) -> HTMLSafeString {
        component
    }

    public static func buildArray(_ components: [HTMLSafeString]) -> HTMLSafeString {
        components.joined(separator: "\n")
    }

    public static func buildExpression(_ expression: HTMLSafeString) -> HTMLSafeString {
        expression
    }
}
