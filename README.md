# README

## 概要
Twitterの画像の表示に特化したViewer

## 機能(2/25現在)
- 検索条件のフィルター
- 検索履歴
- 画像のサムネイル表示
- 画像の表示

## 動作サンプル


https://user-images.githubusercontent.com/20943876/155585602-f6687852-97b2-4f9b-b815-afe11e68c6b0.mov



## 使用ライブラリ
- Kingfisher: https://github.com/onevcat/Kingfisher

## 使用技術
- Combine
- UIKit

## ビルド要件
- XCode13(13A1030d)
- 対応OS: iOS 13以上

## ビルド方法
1. TwitterDeveloperに登録する。https://developer.twitter.com/en/docs/platform-overview
2. DeveloperPotalから`Bearer Token`を生成する。
3. Resourceフォルダ以下に`Tokens.swift`ファイルを作成し、`Bearer Token`を追加する。
```
struct Tokens {
    static let twitterBearerToken = "Add to Bearer Token"
}
```
