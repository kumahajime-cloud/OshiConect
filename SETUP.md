# OshiConnect セットアップ・起動手順書

このドキュメントでは、OshiConnectをローカル環境で起動する詳細な手順を説明します。

## 目次

1. [前提条件の確認](#前提条件の確認)
2. [Dockerを使った起動方法（推奨）](#dockerを使った起動方法推奨)
3. [ローカル環境での起動方法](#ローカル環境での起動方法)
4. [よくある問題と解決方法](#よくある問題と解決方法)

---

## 前提条件の確認

### Dockerを使う場合

以下がインストールされていることを確認してください：

```bash
docker --version
# Docker version 20.10.0 以降

docker compose version
# Docker Compose version v2.0.0 以降
```

### ローカル環境で実行する場合

以下がインストールされていることを確認してください：

```bash
ruby --version
# ruby 3.2.2 以降

rails --version
# Rails 7.0.0 以降

psql --version
# psql (PostgreSQL) 12.0 以降
```

---

## Dockerを使った起動方法（推奨）

### Step 1: プロジェクトをクローン

```bash
git clone <repository-url>
cd OshiConnect
```

### Step 2: Dockerイメージをビルド

```bash
docker compose build
```

このコマンドは初回のみ時間がかかります（5〜10分程度）。

### Step 3: データベースを作成

```bash
docker compose run --rm web rails db:create
```

以下のようなメッセージが表示されれば成功です：
```
Created database 'oshiconnect_development'
Created database 'oshiconnect_test'
```

### Step 4: マイグレーションを実行

```bash
docker compose run --rm web rails db:migrate
```

以下のようにマイグレーションが実行されます：
```
== 20260120000001 DeviseCreateUsers: migrating ================================
-- create_table(:users)
   -> 0.0234s
...
```

### Step 5: サーバーを起動

```bash
docker compose up
```

または、バックグラウンドで起動する場合：
```bash
docker compose up -d
```

### Step 6: ブラウザでアクセス

ブラウザで以下のURLにアクセス：
```
http://localhost:3000
```

### Step 7: サーバーを停止

Ctrl+C を押すか、バックグラウンドで起動した場合は：
```bash
docker compose down
```

---

## ローカル環境での起動方法

### Step 1: Rubyのインストール

#### rbenvを使う場合

```bash
# rbenvのインストール（既にインストール済みの場合はスキップ）
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init - bash)"' >> ~/.bashrc
source ~/.bashrc

# ruby-buildのインストール
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# 必要な依存関係をインストール
sudo apt-get update
sudo apt-get install -y build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev

# Ruby 3.2.2をインストール
rbenv install 3.2.2
rbenv global 3.2.2

# 確認
ruby --version
```

### Step 2: PostgreSQLのインストール

```bash
sudo apt-get update
sudo apt-get install -y postgresql postgresql-contrib libpq-dev

# PostgreSQLを起動
sudo service postgresql start

# PostgreSQLユーザーを作成（パスワードは 'password' に設定）
sudo -u postgres psql
CREATE USER postgres WITH PASSWORD 'password';
ALTER USER postgres CREATEDB;
\q
```

### Step 3: プロジェクトをクローン

```bash
git clone <repository-url>
cd OshiConnect
```

### Step 4: 依存関係をインストール

```bash
# Bundlerのインストール
gem install bundler

# Gemのインストール
bundle install
```

Nodeパッケージもインストール（Webpackerを使用する場合）：
```bash
# Node.jsとYarnのインストール（まだの場合）
curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
npm install -g yarn

# パッケージのインストール
yarn install
```

### Step 5: データベース設定

`config/database.yml`を確認し、必要に応じて編集：

```yaml
development:
  adapter: postgresql
  encoding: unicode
  pool: 5
  host: localhost
  username: postgres
  password: password
  database: oshiconnect_development
```

### Step 6: データベースを作成

```bash
rails db:create
rails db:migrate
```

### Step 7: サーバーを起動

```bash
rails server
# または短縮形
rails s
```

サーバーが起動したら、以下のメッセージが表示されます：
```
=> Booting Puma
=> Rails 7.0.0 application starting in development
=> Run `bin/rails server --help` for more startup options
Puma starting in single mode...
* Puma version: 5.6.0 (ruby 3.2.2-p0) ("Birdie's Version")
* Listening on http://127.0.0.1:3000
Use Ctrl-C to stop
```

### Step 8: ブラウザでアクセス

ブラウザで以下のURLにアクセス：
```
http://localhost:3000
```

---

## 初期データの投入（オプション）

テスト用のデータを投入する場合は、以下のコマンドを実行：

### Dockerの場合
```bash
docker compose exec web rails db:seed
```

### ローカル環境の場合
```bash
rails db:seed
```

---

## よくある問題と解決方法

### 問題1: Dockerコンテナが起動しない

**エラーメッセージ:**
```
permission denied while trying to connect to the Docker daemon socket
```

**解決方法:**
ユーザーをdockerグループに追加：
```bash
sudo usermod -aG docker $USER
```

ログアウトして再度ログインするか、以下を実行：
```bash
newgrp docker
```

---

### 問題2: データベース接続エラー

**エラーメッセージ:**
```
could not connect to server: Connection refused
```

**解決方法（Docker）:**
データベースコンテナが起動しているか確認：
```bash
docker compose ps
```

データベースを再起動：
```bash
docker compose restart db
```

**解決方法（ローカル）:**
PostgreSQLが起動しているか確認：
```bash
sudo service postgresql status
```

起動していない場合：
```bash
sudo service postgresql start
```

---

### 問題3: マイグレーションエラー

**エラーメッセージ:**
```
PG::DuplicateTable: ERROR:  relation "users" already exists
```

**解決方法:**
データベースをリセット：
```bash
# Docker
docker compose exec web rails db:reset

# ローカル
rails db:reset
```

⚠️ 注意: このコマンドは全データを削除します。

---

### 問題4: 画像がアップロードできない

**エラーメッセージ:**
```
ActiveStorage::FileNotFoundError
```

**解決方法:**
storageディレクトリを作成：
```bash
mkdir -p storage
chmod 755 storage
```

---

### 問題5: Gemのインストールエラー

**エラーメッセージ:**
```
An error occurred while installing pg (1.x.x)
```

**解決方法:**
PostgreSQLの開発ライブラリをインストール：
```bash
sudo apt-get install -y libpq-dev
bundle install
```

---

### 問題6: ポート3000が既に使用されている

**エラーメッセージ:**
```
Address already in use - bind(2) for "127.0.0.1" port 3000
```

**解決方法:**
別のポートで起動：
```bash
# Docker
PORT=3001 docker compose up

# ローカル
rails s -p 3001
```

または、使用中のプロセスを停止：
```bash
lsof -ti:3000 | xargs kill -9
```

---

## コマンドチートシート

### Docker

```bash
# ビルド
docker compose build

# 起動（フォアグラウンド）
docker compose up

# 起動（バックグラウンド）
docker compose up -d

# 停止
docker compose down

# ログ確認
docker compose logs -f web

# コンテナ内でコマンド実行
docker compose exec web <command>

# データベースリセット
docker compose exec web rails db:reset

# Railsコンソール
docker compose exec web rails console
```

### ローカル環境

```bash
# サーバー起動
rails server

# データベース作成
rails db:create

# マイグレーション実行
rails db:migrate

# データベースリセット
rails db:reset

# Railsコンソール
rails console

# ルート確認
rails routes

# テスト実行
rails test
```

---

## サポート

問題が解決しない場合は、以下を確認してください：

1. エラーメッセージの全文
2. 実行したコマンド
3. 環境情報（OS、Rubyバージョンなど）

```bash
# 環境情報の確認
ruby --version
rails --version
docker --version
docker compose version
```

---

## 次のステップ

アプリケーションが正常に起動したら：

1. 新規ユーザー登録
2. プロフィール設定
3. 推しを登録
4. 投稿してみる
5. ハッシュタグを使ってみる

詳しい使い方は [README.md](README.md) を参照してください。
