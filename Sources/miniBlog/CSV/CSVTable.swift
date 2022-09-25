import SafeHTML

final class CSVTable {
    var columnLabels: [String] = []
    var tableData: [[String]] = []

    init(csv: String) {
        csv.enumerateLines { line, stop in
            self.process(line: line)
        }
    }

    func process(line: String) {
        let line = line.trimmingCharacters(in: .whitespaces)
        guard !line.isEmpty else {
            return
        }

        guard !columnLabels.isEmpty else {
            columnLabels = csvSplit(line: line)
            return
        }

        let data = csvSplit(line: line)
        tableData.append(data)
    }

    @HTMLBuilder
    var html: HTMLSafeString {
        """
        <table class="markdown-csv">
          <tr>
        """
        for item in columnLabels {
            """
                <th>\(item)</th>
            """
        }
        """
          </tr>
        """
        for row in tableData {
            """
              <tr>
            """
            for item in row {
                """
                    <td>\(item)</td>
                """
            }
            """
              </tr>
            """
        }
        """
        </table>
        """
    }
}

private func csvSplit(line: String) -> [String] {
    var result = [String]()
    var field = ""
    var quoted = false

    var currentIndex = line.startIndex
    while currentIndex != line.endIndex {
        let character = line[currentIndex]
        if character == "\"" {
            let nextIndex = line.index(after: currentIndex)
            if nextIndex != line.endIndex, quoted && line[nextIndex] == "\"" {
                field.append(character)
                currentIndex = line.index(currentIndex, offsetBy: 2)
                continue
            }

            quoted.toggle()
        } else if character == "," && !quoted {
            result.append(field)
            field = ""
        } else {
            field.append(character)
        }

        currentIndex = line.index(after: currentIndex)
    }
    result.append(field)
    return result
}
