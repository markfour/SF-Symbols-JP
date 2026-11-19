import Foundation

/// バンドル内の symbols.json を読み込み、カテゴリ一覧を提供する
struct SymbolStore {
    let categories: [SymbolCategory]

    private struct Payload: Decodable {
        let categories: [SymbolCategory]
    }

    init(categories: [SymbolCategory]) {
        self.categories = categories
    }

    /// 指定バンドルの symbols.json から読み込む
    static func load(from bundle: Bundle = .main) throws -> SymbolStore {
        guard let url = bundle.url(forResource: "symbols", withExtension: "json") else {
            throw CocoaError(.fileNoSuchFile)
        }
        let data = try Data(contentsOf: url)
        let payload = try JSONDecoder().decode(Payload.self, from: data)
        return SymbolStore(categories: payload.categories)
    }
}
