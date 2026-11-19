import Foundation

extension SymbolCategory {
    /// カテゴリの日本語表示名（未知の key はそのまま表示）
    var japaneseName: String {
        Self.japaneseNames[key] ?? key
    }

    private static let japaneseNames: [String: String] = [
        "all": "すべて",
        "whatsnew": "新規",
        "draw": "描画",
        "variable": "可変",
        "multicolor": "マルチカラー",
        "communication": "コミュニケーション",
        "weather": "天気",
        "maps": "マップ",
        "objectsandtools": "オブジェクトとツール",
        "devices": "デバイス",
        "cameraandphotos": "カメラと写真",
        "gaming": "ゲーム",
        "connectivity": "接続",
        "transportation": "交通機関",
        "automotive": "自動車",
        "accessibility": "アクセシビリティ",
        "privacyandsecurity": "プライバシーとセキュリティ",
        "human": "人",
        "home": "ホーム",
        "fitness": "フィットネス",
        "nature": "自然",
        "editing": "編集",
        "textformatting": "テキストフォーマット",
        "media": "メディア",
        "keyboard": "キーボード",
        "commerce": "コマース",
        "time": "時間",
        "health": "ヘルス",
        "shapes": "図形",
        "arrows": "矢印",
        "indices": "インデックス",
        "math": "数学",
    ]
}
