import SwiftUI
import UIKit

/// ナビゲーション用のシンボル名ラッパー（String の遷移先と衝突させないため）
struct SymbolName: Hashable {
    let name: String
}

/// シンボル詳細画面: 大きく表示し、名前をコピーできる
struct SymbolDetailView: View {
    let symbol: SymbolName

    @State private var copied = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: symbol.name)
                .font(.system(size: 120))
                .foregroundStyle(.tint)
                .frame(minHeight: 160)

            Text(symbol.name)
                .font(.title3.monospaced())
                .multilineTextAlignment(.center)
                .textSelection(.enabled)

            Button {
                UIPasteboard.general.string = symbol.name
                copied = true
            } label: {
                Label(copied ? "コピーしました" : "名前をコピー",
                      systemImage: copied ? "checkmark" : "doc.on.doc")
                    .contentTransition(.symbolEffect(.replace))
            }
            .buttonStyle(.borderedProminent)
            .sensoryFeedback(.success, trigger: copied) { _, new in new }
            .task(id: copied) {
                guard copied else { return }
                try? await Task.sleep(for: .seconds(2))
                copied = false
            }

            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SymbolDetailView(symbol: SymbolName(name: "cloud.sun.rain.fill"))
    }
}
