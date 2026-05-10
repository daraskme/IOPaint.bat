# IOPaint Launcher

[IOPaint](https://github.com/Sanster/IOPaint) を簡単に起動するためのランチャースクリプトです。  
初回実行時に仮想環境の作成・依存パッケージのインストールを自動で行います。

---

## 対応OS

| ファイル | 対象OS |
|---|---|
| `IOPaint.bat` | Windows（CUDA GPU / CPU） |
| `IOPaint.sh` | macOS（Apple Silicon MPS / CPU） |

---

## 必要なもの

### Windows
- Python 3.11（[ダウンロード](https://www.python.org/downloads/release/python-3119/)）
- CUDA対応GPU（任意）

### macOS
- Python 3.11
  - [公式サイト](https://www.python.org/downloads/release/python-3119/) からインストール
  - または `brew install python@3.11`
- Apple Silicon Mac（M1以降）推奨（Intel Macの場合はCPUモードで動作）

---

## 使い方

### Windows

`IOPaint.bat` をダブルクリックして実行します。

### macOS

ターミナルで以下を実行します。

```bash
bash IOPaint.sh
```

または Finder で `IOPaint.sh` を右クリック →「このアプリケーションで開く」→「ターミナル」。

---

## 動作の流れ

```
初回起動
  ├─ [1/5] IOPaint フォルダの作成
  ├─ [2/5] Python 3.11 仮想環境の作成
  ├─ [3/5] pip / setuptools / wheel のアップグレード
  ├─ [4/5] PyTorch のインストール
  └─ [5/5] IOPaint のインストール

2回目以降
  └─ インストール済みの環境をそのまま起動
```

起動後、ブラウザで `http://localhost:8080` が自動的に開きます。  
停止するには `Ctrl+C` を押します。

---

## GPU対応

| OS | GPU検出 | モード |
|---|---|---|
| Windows | CUDA 利用可能 | CUDA GPU |
| Windows | CUDA 利用不可 | CPU |
| macOS | MPS 利用可能（Apple Silicon） | MPS GPU |
| macOS | MPS 利用不可（Intel） | CPU |

---

## フォルダ構成

```
IOPaint.bat/
├── IOPaint.bat   # Windows用ランチャー
├── IOPaint.sh    # macOS用ランチャー
├── README.md     # このファイル
└── IOPaint/      # 初回起動時に自動生成
    └── venv/     # Python仮想環境
```

---

## ライセンス

IOPaint 本体のライセンスは [IOPaint リポジトリ](https://github.com/Sanster/IOPaint) を参照してください。
