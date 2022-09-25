import Foundation
import FoundationExtras
import Punycode

extension StringProtocol {
    /// Whether the string is a valid email address.
    ///
    /// Email addresses containing Unicode characters are supported.
    ///
    /// Some syntactically valid email addresses are rejected as invalid due to policy:
    ///   * Email addresses containing quotes (eg. "user"@example.com).
    ///   * Email addresses using an IP address instead of a domain name (eg. user@[192.0.2.10]).
    var isValidEmailAddress: Bool {
        validate(emailAddress: self)
    }
}

// Private

private let maxAsciiEncodedDomainLength = 253
private let maxDNSLabelLength = 63
private let maxEmailAddressLength = 254
private let maxLocalPartLength = 64

private let dnsLabelCharacters = CharacterSet(charactersIn: "-") | .asciiAlphanumerics
private let localPartLabelCharacters =
    CharacterSet(charactersIn: "!#$%&'*+-/=?^_`{|}~") | .asciiAlphanumerics | .nonAsciiCharacters

private func validate<StringType: StringProtocol>(emailAddress: StringType) -> Bool {
    guard 1...maxEmailAddressLength ~= emailAddress.utf8.count else { return false }
    guard let atSymbolIndex = emailAddress.lastIndex(of: "@") else {
        return false
    }

    let localPart = emailAddress.prefix(upTo: atSymbolIndex)
    let domain = emailAddress.suffix(from: atSymbolIndex).dropFirst()

    return validate(localPart: localPart) && validate(domain: domain)
}

private func validate<S: StringProtocol>(localPart: S) -> Bool {
    guard 1...maxLocalPartLength ~= localPart.utf8.count else {
        return false
    }

    let labels = localPart.split(separator: ".", maxSplits: Int.max, omittingEmptySubsequences: false)

    return labels.allSatisfy { label in
        !label.isEmpty && label.containsOnly(charactersIn: localPartLabelCharacters)
    }
}

private func validate<S: StringProtocol>(domain: S) -> Bool {
    guard domain.containsOnly(charactersIn: .asciiCharacters) else {
        return validate(domain: Substring(domain).idnaEncoded!)
    }
    guard 1...maxAsciiEncodedDomainLength ~= domain.utf8.count else {
        return false
    }

    let labels = domain.split(separator: ".", maxSplits: Int.max, omittingEmptySubsequences: false)

    return labels.allSatisfy { label in
        1...maxDNSLabelLength ~= label.utf8.count && label.first!.isContained(in: .asciiLetters)
            && label.last! != "-"
            && label.containsOnly(charactersIn: dnsLabelCharacters)
    }
}
