import SwiftUI

/// カテゴリ詳細画面: シンボルのグリッド一覧（名前で検索可）
struct CategoryDetailView: View {
    let category: SymbolCategory

    @State private var searchText = ""

    private var filteredSymbols: [String] {
        let query = searchText.trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else { return category.symbols }
        return category.symbols.filter { $0.localizedCaseInsensitiveContains(query) }
    }

    var body: some View {
        let symbols = filteredSymbols

        SymbolGrid(symbols: symbols)
            .overlay {
                if symbols.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                }
            }
            .navigationTitle(category.japaneseName)
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "シンボル名で検索")
    }
}

#Preview {
    NavigationStack {
        CategoryDetailView(category: SymbolCategory(
            key: "weather",
            icon: "cloud.sun",
            symbols: ["sun.max", "cloud", "cloud.rain", "snowflake", "wind", "tornado"]
        ))
    }
}
