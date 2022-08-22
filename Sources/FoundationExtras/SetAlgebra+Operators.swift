extension SetAlgebra {
    /// Returns the union of two sets.
    public static func | (left: Self, right: Self) -> Self {
        left.union(right)
    }

    /// Returns the intersection of two sets.
    public static func & (left: Self, right: Self) -> Self {
        left.intersection(right)
    }
}
