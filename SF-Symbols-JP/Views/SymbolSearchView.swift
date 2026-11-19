import SwiftUI

/// 検索画面（検索タブのルート）: 全シンボルを対象に名前で絞り込む
/// 条件が空のときはグリッドを描画せず、案内だけを表示する（全件描画の負荷を避けるため）
struct SymbolSearchView: View {
    let allSymbols: [String]
    /// 検索文字列（検索バーは TabView 側の .searchable が持つ）
    let searchText: String

    private var query: String {
        searchText.trimmingCharacters(in: .whitespaces)
    }

    private var results: [String] {
        guard !query.isEmpty else { return [] }
        return allSymbols.filter { $0.localizedCaseInsensitiveContains(query) }
    }

    var body: some View {
        let symbols = results

        SymbolGrid(symbols: symbols)
            .overlay {
                if query.isEmpty {
                    ContentUnavailableView(
                        "シンボルを検索",
                        systemImage: "magnifyingglass",
                        description: Text("シンボル名を入力してください")
                    )
                } else if symbols.isEmpty {
                    ContentUnavailableView.search(text: query)
                }
            }
            .navigationTitle("検索")
    }
}

#Preview {
    NavigationStack {
        SymbolSearchView(
            allSymbols: ["sun.max", "cloud", "cloud.rain", "snowflake", "wind", "tornado"],
            searchText: "cloud"
        )
    }
}
