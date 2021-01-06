# はじめに

Pythonプロジェクト構成のスケルトンです。

appパッケージがアプリケーションコードです。
appパッケージは設定値LOG_LEVELを表示するだけのサンプルアプリケーションです。
環境変数`APP_CONFIG_FILE`で設定値を記述したファイル（app/config/内のファイル）を切り替えられます。

## 使い方

### 開発

```shell
# ベースイメージのビルド
$ make build-baseimage
# イメージのビルド
$ make build
# ローカルで起動
$ make run
docker run -it --rm --name app -w /usr/src -v $(pwd):/usr/src -e APP_CONFIG_FILE=base app/dev:local
LOG_LEVEL: DEBUG
```

開発中に別のコマンドを実行したいときは下記のように実行できます。

```shell
$ make run CMD='ls /usr/src/app'
docker run -it --rm --name app -w /usr/src -v $(pwd):/usr/src -e APP_CONFIG_FILE=base app/dev:local ls /usr/src/app
__init__.py  __pycache__  config  main.py  tests
```

### テスト実行

下記のコマンドを実行するとテストが動きます

```shell
$ make test
```

テストでは下記を行なっています。

- black によるコードフォーマットのチェック。（[実行時のオプション](https://github.com/rhoboro/pythonapp_skeleton/blob/main/pyproject.toml#L1)）
- isort によるインポート順序のチェック。（[実行時のオプション](https://github.com/rhoboro/pythonapp_skeleton/blob/main/pyproject.toml#L19)）
- pytest によるユニットテストの実行。（[実行時のオプション](https://github.com/rhoboro/pythonapp_skeleton/blob/main/setup.cfg#L10)）
- mypy による静的解析の実行。（[実行時のオプション](https://github.com/rhoboro/pythonapp_skeleton/blob/main/setup.cfg#L1)）

フォーマットチェックでエラーになった際は、下記でコード整形を実行できます。

```shell
$ make format
```

### 依存関係の追加

直接依存しているライブラリ名（必要に応じてバージョンも）を `requirements.txt` に追加し、下記を実行します。

```shell
$ rm requirements.lock
$ make requirements.lock
```

FastAPI自体のアプデートはベースイメージのビルドから行ってください。

## ディレクトリ構成

```shell
.
├── Dockerfile
├── Makefile
├── README.md
├── app
│   ├── __init__.py
│   ├── config
│   ├── main.py
│   └── tests
├── baseimage
│   └── Dockerfile
├── requirements.lock
├── requirements.txt
└── requirements_test.txt
```

### app/

- アプリケーション本体です
- Dockerイメージの/usr/src/app にマウントされます。
- テストコードは tests/ に配置します。

### baseimage/

- DockerHubから直接イメージを取得しているとリクエスト制限にひっかかり、CI/CDが失敗することがあります
- そのため、ベースイメージを作成しECRやGCRに保存しておくことを想定しています


