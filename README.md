# OshiConnect（オシコネ） - 推し活SNS

推し活をする人のための特化型SNSアプリケーションです。

## 概要

OshiConnectは、アーティストやキャラクターなどを応援する「推し活」に特化したSNSです。
同じ推しを応援する仲間と気軽に交流でき、推しへの想いを全力で語れる環境を提供します。

## 主な機能

### 基本機能
- **ユーザー登録・ログイン機能**
  - メールアドレスとパスワードで登録
  - Deviseを使用した安全な認証

- **プロフィール設定**
  - 推し（アーティスト名・キャラクター名）を複数登録可能
  - 自己紹介文の設定
  - プロフィール画像のアップロード

### 投稿機能
- **テキスト投稿**
  - 推しへの想いや最近の出来事を投稿
  - 最大1000文字まで

- **画像添付**
  - 1枚の画像を投稿に添付可能
  - Active Storageを使用

- **ハッシュタグ機能**
  - #推しの名前 などのハッシュタグを自動抽出
  - ハッシュタグでの検索・フィルタリング

### タイムライン
- 全ユーザーの投稿を時系列で表示
- ハッシュタグでフィルタリング可能
- ページネーション対応

### いいね機能
- 投稿に「いいね」を付けられる
- いいね数の表示
- 重複いいね防止

### マイページ
- 自分の投稿一覧
- いいねした投稿一覧
- プロフィール編集

## 技術スタック

- **言語**: Ruby 3.2.2
- **フレームワーク**: Ruby on Rails 7.0
- **データベース**: PostgreSQL
- **認証**: Devise
- **画像処理**: Active Storage
- **コンテナ**: Docker / Docker Compose

## セットアップ方法

### 前提条件

以下のいずれかが必要です：
- Docker と Docker Compose
- Ruby 3.2.2 と PostgreSQL

### Dockerを使用する場合（推奨）

1. リポジトリをクローン
```bash
git clone <repository-url>
cd OshiConnect
```

2. Dockerコンテナをビルドして起動
```bash
docker compose build
docker compose up
```

3. データベースをセットアップ
```bash
docker compose exec web rails db:create
docker compose exec web rails db:migrate
```

4. ブラウザで http://localhost:3000 にアクセス

### ローカル環境で実行する場合

1. リポジトリをクローン
```bash
git clone <repository-url>
cd OshiConnect
```

2. 依存関係をインストール
```bash
bundle install
```

3. データベースをセットアップ
```bash
rails db:create
rails db:migrate
```

4. サーバーを起動
```bash
rails server
```

5. ブラウザで http://localhost:3000 にアクセス

## 使い方

### 1. ユーザー登録

1. トップページの「新規登録」をクリック
2. ユーザー名、メールアドレス、パスワードを入力
3. 「登録する」をクリック

### 2. プロフィール設定

1. ログイン後、ヘッダーの「プロフィール」をクリック
2. 「プロフィールを編集」から情報を更新
3. 推しの名前を追加フォームから入力して「追加」

### 3. 投稿する

1. ヘッダーの「投稿する」をクリック
2. 投稿内容を入力（ハッシュタグは#から始める）
3. 必要に応じて画像を添付
4. 「投稿する」をクリック

### 4. タイムラインを見る

- トップページで全ユーザーの投稿を閲覧
- ハッシュタグをクリックすると、そのハッシュタグの投稿のみを表示
- いいねボタンで投稿に「いいね」

### 5. マイページ

- 自分の投稿一覧を確認
- いいねした投稿を確認

## データベース設計

### Usersテーブル
- email（メールアドレス）
- encrypted_password（暗号化されたパスワード）
- username（ユーザー名）
- bio（自己紹介文）
- profile_image（プロフィール画像）

### Oshisテーブル
- user_id（ユーザーID）
- name（推しの名前）

### Postsテーブル
- user_id（ユーザーID）
- content（投稿内容）
- likes_count（いいね数）

### Hashtagsテーブル
- name（ハッシュタグ名）

### PostHashtagsテーブル（中間テーブル）
- post_id（投稿ID）
- hashtag_id（ハッシュタグID）

### Likesテーブル
- user_id（ユーザーID）
- post_id（投稿ID）

## 開発のポイント

### ハッシュタグの自動抽出

投稿作成時に、`#`で始まる文字列を自動的に抽出し、Hashtagsテーブルに保存します。
既存のハッシュタグは再利用され、データの重複を防ぎます。

```ruby
def extract_hashtags
  hashtag_names = content.scan(/#[一-龠ぁ-んァ-ヶーa-zA-Z0-9]+/).map { |tag| tag[1..-1] }
  hashtag_names.uniq.each do |name|
    hashtag = Hashtag.find_or_create_by(name: name)
    post_hashtags.create(hashtag: hashtag) unless hashtags.include?(hashtag)
  end
end
```

### N+1問題の対策

タイムライン表示時に`includes`を使用してクエリを最適化しています。

```ruby
@posts = Post.includes(:user, :hashtags).recent
```

### いいね機能の重複防止

データベースレベルでユニーク制約を設定し、同一ユーザーが同一投稿に複数回いいねできないようにしています。

```ruby
add_index :likes, [:user_id, :post_id], unique: true
```

## トラブルシューティング

### Dockerコンテナが起動しない

```bash
docker compose down
docker compose build --no-cache
docker compose up
```

### データベースエラーが発生する

```bash
docker compose exec web rails db:reset
```

### 画像がアップロードできない

`storage`ディレクトリの権限を確認してください：
```bash
mkdir -p storage
chmod 755 storage
```

## ライセンス

このプロジェクトは学習目的で作成されました。

## 作成者

慶應義塾大学 最終課題プロジェクト

## 今後の展望

- 検索機能の強化（全文検索）
- フォロー機能
- 通知機能
- コメント機能
- プライバシー設定（投稿の公開範囲設定）
- レスポンシブデザインの改善
- PWA対応
- デプロイ（Render、Herokuなど）
