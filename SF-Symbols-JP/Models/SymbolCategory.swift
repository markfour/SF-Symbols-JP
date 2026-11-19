import Foundation

/// SF Symbols のカテゴリ（symbols.json の1要素）
struct SymbolCategory: Decodable, Identifiable, Hashable {
    let key: String
    let icon: String
    let symbols: [String]

    var id: String { key }
}
