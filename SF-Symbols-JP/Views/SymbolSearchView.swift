import SwiftUI

/// 検索画面（検索タブのルート）: 全シンボルを対象に名前とカテゴリで絞り込む
/// 条件が空のときはグリッドを描画せず、案内だけを表示する（全件描画の負荷を避けるため）
struct SymbolSearchView: View {
    let allSymbols: [String]
    /// フィルターで選べるカテゴリ（"all" は含めない）
    let categories: [SymbolCategory]
    /// 検索文字列（検索バーは TabView 側の .searchable が持つ）
    let searchText: String

    @State private var selectedCategory: SymbolCategory?

    private var query: String {
        searchText.trimmingCharacters(in: .whitespaces)
    }

    private var hasCondition: Bool {
        !query.isEmpty || selectedCategory != nil
    }

    private var results: [String] {
        guard hasCondition else { return [] }
        let base = selectedCategory?.symbols ?? allSymbols
        guard !query.isEmpty else { return base }
        return base.filter { $0.localizedCaseInsensitiveContains(query) }
    }

    var body: some View {
        let symbols = results

        SymbolGrid(symbols: symbols)
            .overlay {
                if !hasCondition {
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    categoryFilterMenu
                }
            }
    }

    /// カテゴリを1つ選ぶメニュー（選択中はアイコンを塗りつぶしにする）
    private var categoryFilterMenu: some View {
        Menu {
            Picker("カテゴリ", selection: $selectedCategory) {
                Text("指定なし")
                    .tag(SymbolCategory?.none)
                ForEach(categories) { category in
                    Label(category.japaneseName, systemImage: category.icon)
                        .tag(Optional(category))
                }
            }
            .pickerStyle(.inline)
        } label: {
            Label(
                "カテゴリで絞り込む",
                systemImage: selectedCategory == nil
                    ? "line.3.horizontal.decrease.circle"
                    : "line.3.horizontal.decrease.circle.fill"
            )
        }
    }
}

#Preview {
    NavigationStack {
        SymbolSearchView(
            allSymbols: ["sun.max", "cloud", "cloud.rain", "snowflake", "wind", "tornado", "message", "phone"],
            categories: [
                SymbolCategory(key: "communication", icon: "message", symbols: ["message", "phone"]),
                SymbolCategory(key: "weather", icon: "cloud.sun", symbols: ["sun.max", "cloud", "cloud.rain"]),
            ],
            searchText: "cloud"
        )
    }
}
