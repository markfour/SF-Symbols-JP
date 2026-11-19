import SwiftUI

/// ルート画面: カテゴリ一覧
struct CategoryListView: View {
    let categories: [SymbolCategory]

    var body: some View {
        List(categories) { category in
            NavigationLink(value: category) {
                HStack(spacing: 12) {
                    Image(systemName: category.icon)
                        .foregroundStyle(.tint)
                        .frame(width: 28)
                    Text(category.japaneseName)
                    Spacer()
                    Text(category.symbols.count, format: .number)
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
            }
        }
        .navigationTitle("SF Symbols")
    }
}

#Preview {
    NavigationStack {
        CategoryListView(categories: [
            SymbolCategory(key: "communication", icon: "message", symbols: ["message", "phone"]),
            SymbolCategory(key: "weather", icon: "cloud.sun", symbols: ["sun.max", "cloud"]),
        ])
    }
}
