import SwiftUI

/// カテゴリ詳細画面: シンボルのグリッド一覧（名前で検索可）
struct CategoryDetailView: View {
    let category: SymbolCategory

    @State private var searchText = ""

    private let columns = [GridItem(.adaptive(minimum: 96), spacing: 12)]

    private var filteredSymbols: [String] {
        let query = searchText.trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else { return category.symbols }
        return category.symbols.filter { $0.localizedCaseInsensitiveContains(query) }
    }

    var body: some View {
        let symbols = filteredSymbols

        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(symbols, id: \.self) { name in
                    NavigationLink(value: SymbolName(name: name)) {
                        SymbolCell(name: name)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
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

/// グリッドの1セル（アイコン + 名前）
private struct SymbolCell: View {
    let name: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: name)
                .font(.title)
                .frame(height: 44)
            Text(name)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2, reservesSpace: true)
                .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 4)
        .background(.fill.quaternary, in: .rect(cornerRadius: 12))
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
