FROM ruby:3.2.2

# 必要なパッケージをインストール
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs npm && \
    npm install -g yarn && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 作業ディレクトリを設定
WORKDIR /app

# Gemfileをコピーしてbundle install
COPY Gemfile Gemfile.lock ./
RUN bundle install

# アプリケーションのファイルをコピー
COPY . .

# ポート3000を公開
EXPOSE 3000

# サーバー起動コマンド
CMD ["rails", "server", "-b", "0.0.0.0"]
