# lv-portable

[English](README.md)

lv 4.51 を基に、Debian の修正と lv-mod の Windows 対応、Gentoo の ncurses 検出処理を統合した非公式版です。

**バージョン：4.51.portable.1／公開候補／2026-11-15**

本家 lv、lv-mod、Debian、Gentoo の公式リリースではありません。対話操作全般の検証はまだ完了していないため、試験版として提供します。

## lv について

lv は、複数の文字コードに対応したテキストビューアーです。ページャーとしての表示に加え、文字コード変換フィルターとしても使えます。`lgrep` という名前で起動すると、行を検索する grep モードになります。

原作は NARITA Tomio 氏によるものです。Windows 対応には K.Takata 氏らの [lv-mod](https://github.com/k-takata/lv-mod) を利用しています。

## この版の変更

- lv-mod の Windows コンソール・プロセス起動・Unicode 入出力・UTF-16 対応を維持。
- Debian 4.51-10.1 の修正を比較・統合。競合箇所では Windows／UTF-16 対応を残して調整。
- Unix では Gentoo のパッチに基づき、pkg-config で ncurses を検出。
- 一部の共有変数を `extern` 宣言と一か所の実体定義に整理し、`-fcommon` を不要化。
- 元にした作業ツリーで空になっていた文字コード変換表を、本家の配布ソースから復元。
- 通常のビルドで変換表を再生成しないよう、古い再生成ルールを maintainer mode に限定。
- Windows のヘルプ検索に合わせ、インストール時に `lv.hlp` を実行ファイル横にも配置。

Debian の全パッチを無変更で重ねたものではありません。変更の概要は [CHANGELOG.md](CHANGELOG.md)、取得元と統合方法は [PROVENANCE.md](PROVENANCE.md) を参照してください。

## 配布ファイル

| ファイル | 内容 |
| --- | --- |
| `lv-portable-4.51.portable.1.tar.gz` | ビルド用スクリプトと生成済み configure を含む全ソース |
| `lv-portable-4.51.portable.1-ucrt64.zip` | Windows 用実行ファイル、ヘルプ、ライセンス等 |
| `full-from-upstream-4.51.patch` | 本家 `lv_4.51.orig.tar.gz` からの完全なファイル内容差分 |
| `SHA256SUMS` | 配布ファイルの SHA-256 チェックサム |
| `validation-results.json` | 確認済みのテスト結果 |

ソースを再現する場合はソースアーカイブを推奨します。完全パッチはクリーンな本家ソースの最上位で `patch -p1` により適用できますが、実行権限までは復元しません。ファイルの権限は配布アーカイブを基準にしてください。

## Windows で使う

UCRT64 用 ZIP を展開し、`lv.exe` と `lv.hlp` を同じフォルダーに置きます。`lgrep.exe` も同じフォルダーに置いて使用できます。

Windows UCRT を使うネイティブ版で、`msys-2.0.dll` は不要です。ヘルプは実行ファイルの場所から検索します。起動時のカレントディレクトリは検索先ではありません。

### MSYS2 UCRT64 でビルド

UCRT64 用 GCC、make、pkg-config が必要です。UCRT64 端末を使い、展開したソースの**最上位ディレクトリ**で実行します。

```sh
tar xf lv-portable-4.51.portable.1.tar.gz
cd lv-portable-4.51.portable.1
sh ./build-ucrt64.sh
```

生成物は `src/lv.exe` です。インストールせずに確認する場合：

```sh
cp lv.hlp src/lv.hlp
./src/lv.exe -h
python tests/smoke.py src/lv.exe
```

テストには UCRT64 用 Python 3 が必要です。インストール先を指定する場合：

```sh
sh ./build-ucrt64.sh --prefix=/usr/local
make install
```

## Unix／Linux でビルド

C コンパイラ、make、pkg-config、ncurses の開発用ファイルが必要です。通常のビルドでは、文字コード変換表の外部ダウンロードは不要です。

展開したソースの最上位で実行します。`src` から configure を起動しないでください。

```sh
CFLAGS='-O2 -g -std=gnu17' ./configure --prefix=/usr/local
make
```

新しい GCC の既定規格と古い関数宣言の違いを避けるため、`-std=gnu17` を指定しています。`make CFLAGS=...` で設定全体を置き換えないでください。

配置先への書き込み権限がある状態で、次によりインストールできます。

```sh
make install
```

標準設定ではヘルプを `$(libdir)/lv/lv.hlp` に配置し、その場所を `LV_HELP_PATH` として埋め込みます。パッケージ管理下の `/usr/bin/lv` への直接の上書きを避けるには、`--prefix=/usr/local` を使用してください。

### 既存環境を変更しない検証

GNU tar、上記のビルド環境、Python 3 がある Linux では：

```sh
sh ./check-unix-release.sh
```

新しい一時ディレクトリへコピーし、ビルド・隔離インストール・日本語変換・ヘルプ表示を確認します。sudo は使わず、システムの lv を変更しません。検証先とログの場所を表示し、結果のファイルは残します。

Windows と Unix のビルドには、それぞれ別の展開先を使ってください。

## 使用例

UTF-8 のファイルを UTF-8 の端末に表示：

```sh
lv -Iu8 -Ou8 file.txt
```

入力を自動判定し、出力を UTF-8 に指定：

```sh
lv -Ou8 file.txt
```

Shift_JIS のファイルを UTF-8 に変換：

```sh
lv -Is -Ou8 file.txt > converted.txt
```

UTF-8 の検索語を使い、UTF-8 のファイルを検索：

```sh
lgrep -Iu8 -Ku8 -Ou8 '検索語' file.txt
```

`-I` は入力、`-O` は出力、`-K` はキーボード／検索語の文字コードを指定します。詳細は `lv -h`、同梱の `lv.1`・`index.html` を参照してください。

Windows のネイティブ版では、端末の文字コードとコマンドラインの検索語の文字コードが一致するとは限りません。確認した日本語 Windows 環境では検索語が CP932 として渡されたため、次の指定で日本語検索ができました。

```sh
lgrep -Iu8 -Ks -Ou8 '検索語' file.txt
```

`-K` は実際にプログラムへ渡される文字コードに合わせてください。Windows で常に `-Ku8` が適切というわけではありません。

## 確認済みの範囲

| 項目 | MSYS2 UCRT64／GCC 16.2.0 | Gentoo Linux／GCC 16.2.1 |
| --- | --- | --- |
| コンパイルとリンク | 成功 | 成功 |
| 隔離／仮インストール | 成功 | 成功 |
| 日本語 UTF-8 → UTF-8 | 成功 | 成功 |
| 日本語 CP932 → UTF-8 | 成功 | 成功 |
| BOM 付き UTF-16 → UTF-8 | 成功 | 成功 |
| ヘルプ表示 | 成功 | 成功 |

Windows では `-fcommon` なしでビルドしています。Gentoo では `libncurses.so.6` と `libtinfo.so.6` へのリンクを確認しました。Windows の出力は CRLF 改行になるため、変換テストでは改行を正規化して比較しています。

対話画面のキー操作全般、各圧縮形式、大容量ファイル、その他の OS／コンパイラは未検証です。セキュリティ監査は実施していません。GitHub Actions 上でも Linux／Windows のビルドとテストが成功しています（`a49e2cd`）。[実行結果](https://github.com/dydo/lv-portable/actions/runs/43617125778)を参照してください。

詳細は [VALIDATION.md](VALIDATION.md) と、配布物に付属する `validation-results.json` を参照してください。

## configure の再生成

生成済みの `configure` と `Makefile.in` を同梱しています。ビルド設定を変更した場合など、再生成が必要なときだけ、Autoconf／Automake／pkg-config を用意して最上位で実行します。

```sh
autoreconf -fi
```

`--enable-maintainer-mode` は外部データから変換表を再生成するための設定です。通常の利用・ビルドでは指定しないでください。

## 免責事項・無保証

本ソフトウェアは現状のまま提供されます。適用法令で認められる範囲で、商品性や特定目的への適合性を含む保証を行いません。適用法令によって義務付けられる場合、または書面による合意がある場合を除き、著作権者・改変者・再配布者は、本ソフトウェアの使用または使用不能により生じた損害について、[GPL.txt](GPL.txt) 第11条・第12条に定める責任制限の対象となります。

本節は同条項の要約であり、ライセンスの条件を変更したり、追加の利用制限を設けたりするものではありません。

## ライセンス・出典

lv の元のソースにある GPL version 2 or later の許諾と著作権表示を維持しています。GPL v2 の全文は `GPL.txt` にあります。`iscygpty` などの個別ファイルの許諾、Debian／Gentoo 由来の変更については [LICENSES.md](LICENSES.md) を確認してください。

実行ファイルを再配布するときは、対応する今回の全ソースとライセンス表示も提供してください。元の作者や各プロジェクトの公式版と誤解されないよう、非公式統合版であることを明記してください。

主な出典：

- [lv-mod](https://github.com/k-takata/lv-mod)
- [Debian lv](https://packages.debian.org/source/sid/lv)
- [Gentoo lv](https://packages.gentoo.org/packages/app-text/lv)

作業ツリーの変更を含む入力の記録とハッシュは、[PROVENANCE.md](PROVENANCE.md) とソース内の `input-manifest.json` に記載しています。
