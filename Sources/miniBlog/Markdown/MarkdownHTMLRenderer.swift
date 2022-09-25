import Markdown
import SafeHTML

struct MarkdownToHTMLRenderer: MarkupWalker {
    var content: [HTMLSafeString] = []

    init(markdown rawMarkup: String) {
        let document = Document(parsing: rawMarkup, options: .parseBlockDirectives)
        visit(document)
    }

    var html: HTMLSafeString {
        return content.joined(separator: "")
    }

    mutating func visitHeading(_ heading: Heading) {
        content.append("<h\(heading.level)>")
        descendInto(heading)
        content.append("</h\(heading.level)>\n")
    }

    mutating func visitParagraph(_ paragraph: Paragraph) {
        content.append("<p>")
        descendInto(paragraph)
        content.append("</p>\n")
    }

    mutating func visitOrderedList(_ orderedList: OrderedList) {
        content.append("<ol>")
        descendInto(orderedList)
        content.append("</ol>\n")
    }

    mutating func visitUnorderedList(_ unorderedList: UnorderedList) {
        content.append("<ul>")
        descendInto(unorderedList)
        content.append("</ul>\n")
    }

    mutating func visitListItem(_ listItem: ListItem) {
        content.append("<li>")
        descendInto(listItem)
        content.append("</li>")
    }

    mutating func visitBlockDirective(_ blockDirective: BlockDirective) {
        content.append(#"<div class="\#(blockDirective.name)">"#)
        descendInto(blockDirective)
        content.append("</div>\n")
    }

    // - Inline Nodes

    // - Inline leaves

    mutating func visitText(_ text: Text) {
        content.append("\(text.plainText)")
    }

    mutating func visitSoftBreak(_ softBreak: SoftBreak) {
        content.append("\n")
    }

    mutating func visitLineBreak(_ lineBreak: LineBreak) {
        content.append("<br>")
    }

    mutating func visitEmphasis(_ emphasis: Emphasis) {
        content.append("<em>")
        descendInto(emphasis)
        content.append("</em>")
    }

    mutating func visitStrong(_ strong: Strong) {
        content.append("<strong>")
        descendInto(strong)
        content.append("</strong>")
    }

    mutating func visitStrikethrough(_ strikethrough: Strikethrough) {
        content.append("<s>")
        descendInto(strikethrough)
        content.append("</s>")
    }

    mutating func visitLink(_ link: Link) {
        content.append(#"<a href="\#(link.destination ?? "")">"#)
        descendInto(link)
        content.append("</a>")
    }
}

// HTML
extension MarkdownToHTMLRenderer {
    mutating func visitHTMLBlock(_ html: HTMLBlock) {
        content.append("\(html.rawHTML)")
    }

    mutating func visitInlineHTML(_ inlineHTML: InlineHTML) {
        content.append("\(inlineHTML.rawHTML)")
    }
}

// Code
extension MarkdownToHTMLRenderer {
    mutating func visitCodeBlock(_ codeBlock: CodeBlock) {
        guard let language = codeBlock.language else {
            content.append("<pre><code>\(codeBlock.code)</code></pre>\n")
            return
        }

        if language == "!csv" {
            content.append("\(CSVTable(csv: codeBlock.code).html)\n")
        } else {
            content.append(#"<pre><code class="language-\#(language)">\#(codeBlock.code)</code></pre>\#n"#)
        }
    }

    mutating func visitInlineCode(_ inlineCode: InlineCode) {
        content.append("<code>\(inlineCode.code)</code>")
    }
}
