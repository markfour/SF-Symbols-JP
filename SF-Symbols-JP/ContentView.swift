//
//  ContentView.swift
//  SF-Symbols-JP
//
//  Created by Kazumi Hayashida on 2026/11/18.
//

import SwiftUI

struct ContentView: View {
    private let result = Result { try SymbolStore.load() }

    var body: some View {
        switch result {
        case .success(let store):
            TabView {
                Tab("カテゴリ", systemImage: "square.grid.2x2") {
                    NavigationStack {
                        CategoryListView(categories: store.categories)
                            .symbolNavigationDestinations()
                    }
                }

                Tab("検索", systemImage: "magnifyingglass", role: .search) {
                    NavigationStack {
                        SymbolSearchView(
                            allSymbols: store.allSymbols,
                            categories: store.categories.filter { $0.key != "all" }
                        )
                            .symbolNavigationDestinations()
                    }
                }
            }
        case .failure(let error):
            ContentUnavailableView(
                "データを読み込めませんでした",
                systemImage: "exclamationmark.triangle",
                description: Text(error.localizedDescription)
            )
        }
    }
}

private extension View {
    /// 各タブの NavigationStack で共通の遷移先を登録する
    func symbolNavigationDestinations() -> some View {
        self
            .navigationDestination(for: SymbolCategory.self) { category in
                CategoryDetailView(category: category)
            }
            .navigationDestination(for: SymbolName.self) { symbol in
                SymbolDetailView(symbol: symbol)
            }
    }
}

#Preview {
    ContentView()
}
