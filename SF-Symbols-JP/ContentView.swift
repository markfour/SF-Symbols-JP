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
        NavigationStack {
            switch result {
            case .success(let store):
                CategoryListView(categories: store.categories)
                    .navigationDestination(for: SymbolCategory.self) { category in
                        CategoryDetailView(category: category)
                    }
                    .navigationDestination(for: SymbolName.self) { symbol in
                        SymbolDetailView(symbol: symbol)
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
}

#Preview {
    ContentView()
}
