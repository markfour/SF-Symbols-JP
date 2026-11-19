#!/usr/bin/env python3
"""macOS の CoreGlyphs.bundle から SF Symbols のカテゴリ情報を読み取り、
アプリ同梱用の JSON を生成する。

使い方:
    python3 scripts/generate_symbols.py
出力:
    SF-Symbols-JP/Resources/symbols.json
"""

import json
import plistlib
from pathlib import Path

CORE_GLYPHS = Path("/System/Library/CoreServices/CoreGlyphs.bundle/Contents/Resources")
OUTPUT = Path(__file__).resolve().parent.parent / "SF-Symbols-JP" / "Resources" / "symbols.json"


def load_plist(name: str):
    with open(CORE_GLYPHS / name, "rb") as f:
        return plistlib.load(f)


def main() -> None:
    categories = load_plist("categories.plist")          # [{key, icon}]
    symbol_categories = load_plist("symbol_categories.plist")  # {symbol: [category keys]}
    symbol_order = load_plist("symbol_order.plist")      # [symbol] (公式の並び順)

    # 並び順にないシンボルは末尾へ（名前順）
    ordered = list(symbol_order)
    known = set(ordered)
    ordered += sorted(s for s in symbol_categories if s not in known)

    members: dict[str, list[str]] = {c["key"]: [] for c in categories}
    for symbol in ordered:
        for key in symbol_categories.get(symbol, []):
            if key in members:
                members[key].append(symbol)
    members["all"] = ordered

    output = {
        "categories": [
            {"key": c["key"], "icon": c["icon"], "symbols": members[c["key"]]}
            for c in categories
            if members[c["key"]]  # 対応シンボルがないカテゴリ（例: draw）は除外
        ]
    }

    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    with open(OUTPUT, "w", encoding="utf-8") as f:
        json.dump(output, f, ensure_ascii=False, separators=(",", ":"))

    print(f"wrote {OUTPUT}")
    for c in output["categories"]:
        print(f"  {c['key']:<20} {len(c['symbols']):>5}")


if __name__ == "__main__":
    main()
