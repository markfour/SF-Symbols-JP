import SwiftUI

/// グリッドの1セル（アイコン + 名前）
struct SymbolCell: View {
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

/// シンボル名の配列をグリッド表示する（各セルは詳細画面へ遷移）
struct SymbolGrid: View {
    let symbols: [String]

    private let columns = [GridItem(.adaptive(minimum: 96), spacing: 12)]

    var body: some View {
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
    }
}

#Preview {
    NavigationStack {
        SymbolGrid(symbols: ["sun.max", "cloud", "cloud.rain", "snowflake"])
    }
}
