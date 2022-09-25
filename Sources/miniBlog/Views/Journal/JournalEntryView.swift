import Foundation
import SafeHTML

struct JournalEntryView: HTMLView {
    let journalEntry: JournalEntry
    static let dateFormatter = makeDateFormatter()

    static func makeDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        let figureDash = "‒"

        formatter.locale = Locale.init(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy\(figureDash)MM\(figureDash)dd"
        formatter.timeZone = TimeZone.init(identifier: "America/New_York")

        return formatter
    }

    @HTMLBuilder var body: HTMLSafeString {
        ReaderPageTemplate(title: journalEntry.title) {
            """
            <article vocab="https://schema.org/" typeof="BlogPosting" class="journal-entry">
              <header>
                <p><time property="datePublished" datetime="\(journalEntry.publishedAt!)">\(journalEntry.publishedAt!, formatter: Self.dateFormatter)</time></p>
                <h1 property="headline">\(journalEntry.title)</h1>

              </header>
              <div property="articleBody">
            """
            MarkdownToHTMLRenderer(markdown: journalEntry.body).html
            """
              </div>
              <footer>
                <p><span property="author" typeof="Person"><span property="name">\(journalEntry.author.name)</span></span></p>
              </footer>
            </article>
            """
        }
    }
}
