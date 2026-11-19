import SwiftUI

/// 検索画面（検索タブのルート）: 全シンボルを対象に名前とカテゴリで絞り込む
/// 条件が空のときはグリッドを描画せず、案内だけを表示する（全件描画の負荷を避けるため）
struct SymbolSearchView: View {
    let allSymbols: [String]
    /// フィルターで選べるカテゴリ（"all" は含めない）
    let categories: [SymbolCategory]

    @State private var searchText = ""
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
                        description: Text("シンボル名を入力するか、カテゴリを選んでください")
                    )
                } else if symbols.isEmpty {
                    emptyResultView
                }
            }
            .navigationTitle("検索")
            // 画面表示直後から検索バーを出す（スクロールで隠れないよう .always）
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "シンボル名で検索"
            )
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    categoryFilterMenu
                }
            }
    }

    /// 0件のときの表示（フィルター中はカテゴリ名と解除ボタンを出す）
    @ViewBuilder
    private var emptyResultView: some View {
        if let category = selectedCategory {
            ContentUnavailableView {
                Label("見つかりません", systemImage: "magnifyingglass")
            } description: {
                Text("「\(category.japaneseName)」に「\(query)」を含むシンボルはありません")
            } actions: {
                Button("フィルターを解除") {
                    selectedCategory = nil
                }
                .buttonStyle(.bordered)
            }
        } else {
            ContentUnavailableView.search(text: query)
        }
    }

    /// カテゴリを1つ選ぶメニュー（選択中はアイコンを塗りつぶしにする）
    private var categoryFilterMenu: some View {
        Menu {
            if selectedCategory != nil {
                Button("フィルターを解除", systemImage: "xmark.circle", role: .destructive) {
                    selectedCategory = nil
                }
            }
            Picker("カテゴリ", selection: $selectedCategory) {
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
            ]
        )
    }
}
