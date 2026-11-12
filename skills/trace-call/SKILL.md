---
name: trace-call
description: ある特定の状況（入力・データ・状態）での処理の流れを、実際のコード断片に「なにをしているか」「今どんな状態か」のコメントを添えて、呼び出し順にたどって解説する。ユーザーから明示的に使用を指示された場合、または他のスキルの指示に基づいて使用が必要と判断された場合にのみ使用する。
---

# 特定の状況での呼び出しをコードでたどって解説する

ユーザーが指定した状況で処理がどう進むかを、実際のコード断片を使って呼び出し順に解説してください。

## 原則

- 解説する前に、対象のコードを実際に読む。記憶や推測でコードを書かない。
- コード断片は実際のコードから抜粋する。非本質な行は `...` で積極的に省略し、今回の状況で意味を持つ行だけを残す。行の中の非本質な引数なども、`(..., coupon_code)` のように `...` で省略してよい。
- 抜粋したコードに、独自のコメントで「なにをしているか」「今どんな状態か」を補足する。
- 既存の解説やスキルの例を改善するときは、依頼されていない言語・題材・関数・呼び出し経路の変更をしない。説明コメントや前提の改善と、コード自体の差し替えを分ける。
- 状況が曖昧で値や分岐が決まらない場合は、解説を始める前にユーザーへ確認するか、自分で置いた仮定を「前提」に明記する。
- コードから値や挙動を確定できない箇所は、推測である旨を明記する。

## 始める前に確認すること

- 対象が画面を持つコード（React・Vue などのコンポーネント）の場合は、解説を始める前に、画面のスクリーンショットを載せるかをユーザーに聞く。
  - 載せる場合は「スクリーンショット」の節の載せ方に従う。
  - 載せない場合や、画面を動かせない場合は、スクリーンショットなしで書く。

## 書き方

### 文体

- 前提・説明文・コメントは、すべてです・ます調ではなく言い切りの形で書く。

### 読み手が順に理解できる説明

- コードの構文を読めても、そのシステムの用語や変数名を知らない読み手を想定する。専門用語・型名・変数名を並べるだけのコメントにしない。
- 前提とコードコメントの両方で、まず対象や処理の意味を自然言語で説明し、その直後に括弧で対応する変数・属性・メソッド・型などの名前を添える。たとえば「注文する商品を入れたカート（cart）」「注文数（item.quantity）」のように書く。名前を先に置いて「quantityは注文数」と説明する形にせず、文章の意味を先に追えるようにする。
- 専門用語は、必要になる箇所で具体的な意味を説明してから使う。別の未説明の専門用語への言い換えで済ませない。APIのイベント名や型名を使う場合も、「ユーザーが話し始めた通知」など、今回の意味を先に示す。
- 状態値は、何を覚えている値か、今回どうなるか、その結果どの分岐へ進むかの順で説明する。`ready=true / active="" / repairs空` のように複数の状態を一行に圧縮しない。
- ひとつのコメントで、目的・用語・値・次の呼び出しを一度に説明しようとしない。意味のまとまりで行やコメントを分け、情報密度より読み進めやすさを優先する。
- 受け渡しでは「誰が何を誰へ渡すか」「誰が何を待つか」を説明する。矢印と関数名を長く並べるだけで、経路の説明を済ませない。
- 同じ意味をコードの各行で繰り返す必要はない。一度説明した言葉を使い、今回の状態や次へ進む理由に説明を割く。読みやすさのために関数呼び出しや重要な受け渡し経路を落とさない。

### 前提

- 最初の入口のコード断片の先頭に、「前提」から始まるコメントとして書く。別の項目は立てず、コードの言語に合うコメント記法を使う（Goなら `// 前提`、Pythonなら `# 前提`）。
- 前提は「どんな入力があり、何が起きる場面か」が分かる数行を基本にする。1項目にはひとつの条件を書く。後の関数で初めて使う識別名や状態値まで、冒頭に列挙しない。
- 前提の条件は、自然言語による説明の直後に括弧でコード上の名前を添えて対応付ける（例：`# - カートの商品一覧（cart.items）には、単価500円（item.product.price）・注文数3冊（item.quantity）のノートだけが入っている`）。データの構成やnil・空かどうかなど、分岐を決める条件は具体的に固定する。細かな条件は関係する関数や分岐の直前で説明してよいが、その分岐を追う時点では条件が分かるようにする。
- 外部APIの返答など、説明のために仮定した内容は、その箇所で仮定だと分かるようにする。複雑な条件も省略して推測で補わず、関係する箇所へ分けて説明する。

### 全体の構造

- 出力は `### 全体像` と `### 詳細` の2つに分け、全体像を先に書く。見出しのレベルは、出力先の文書の構造に合わせて調整してよい。
- ファイルとして書く場合は、全体像の前に、何をたどる文書か（対象・場面・パスの基準など）を2〜3行で書いてよい。前提の条件はここに書かず、入口のコード断片の「前提」に書く。
- 依頼された対象が複数の部品や関数のまとまり（あるフォルダの部品すべて、など）で、1つの状況では一部しか通らない場合は、導入の文で、今回たどるのはどれで、ほかはどこで分かれるかを1文で書く。通らない部品は、分かれ目のコード断片のコメントで「置かれない」と示す。

#### 全体像

- 詳細でたどる呼び出しの全体を、コードを載せずに箇条書きのネストだけで示す。
- 各項目は `クラス名.メソッド名` だけを書き、引数やファイルのパスは書かない。
- 必要に応じて、項目の行末に `# ひとこと説明` の形で、その処理が何をしているかを短く添える。
- 詳細でたどる関数と、全体像の項目を過不足なく一致させる。並び順と入れ子も詳細と同じにする。
- キューやコールバックなどの非同期の受け渡しを経由して別の起点から始まる処理は、送信元の子にせず、トップレベルに別の項目として並べる。必要なら行末の説明で、何を受け取って始まる処理かを示す。
- 全体像は折りたたまない。

全体像の例：

```
### 全体像

- Service.Run # 期限が来た処理を探して実行を依頼する
  - Service.RunDue
- main
- stage.run # 依頼された処理を受け取って順に実行する
  - stage.queueScheduled
  - stage.startScheduled
    - stage.handle
```

#### 詳細

- 呼び出しの入れ子を、箇条書きのネストで表す。
  - メソッドの項目は、見出しを `` `クラス名.メソッド名` `` とし、その横に定義されているファイルのパスを書く（例：`` `OrderService.place`（`app/services/order_service.rb`） ``）。
    - 呼び出し時の引数が解説に効く場合は、メソッド名のあとに今回の実引数を書いてもよい（例：`` `PriceCalculator.calculate(..., nil)`（`app/models/price_calculator.rb`） ``）。非本質な引数は `...` で省略してよい。
  - 見出しにしてよいのは関数呼び出しだけ。メソッドの中のコードの一部（`` `if coupon.blank?` `` など）や、処理のまとまり（「在庫の確認」など）を見出しにしない。それらは呼び出し元のメソッドのコード断片とコメントで説明する。
- 各項目は、次の順で書く。
  1. 見出しの直下に、その箇所のコード断片をコードブロックで示す。
  2. さらに深く呼び出す処理があれば、子項目として同じ形でたどる。
- 見出しの直下には、原則として自然言語の説明文を書かない。コードとそのコメントを読めば処理を追えるようにする。
  - コードとコメントだけでは伝わらない補足（今回の変更で足した箇所である、など）がある場合だけ、コード断片の前に1文で簡潔に書く。
- ネストが戻ることが、呼び出し元への return を表す。「〜に戻る」のような項目は作らない。
  - 呼び出しのあとの処理は、呼び出し元のメソッドのコード断片にあらかじめ含めておく。
  - 子項目でたどる呼び出しの行や、その戻り値に依存する行には、`# => 値` を書かない。読み手がまだ子項目を読んでいない時点で値を示すと、かえって分かりにくくなるため。
  - 関数呼び出しの行には、なにをする呼び出しなのかを短いコメントで書く。書く位置は、呼び出しコードの1行上か、その行末のどちらかにする（例：`# 支払額を求める`）。

### コード断片へのコメント

- コードコメントでも、対象や処理を自然言語で説明してから、括弧でコード上の名前を添える（例：`# 注文数（item.quantity）が在庫数（item.product.stock）を超えていないか確認する。`）。何の値を何のために扱うのかが分かる文章にし、変数名の列挙やメソッド名の言い換えだけで説明を終えない。具体的な値を示す箇所でも、その値がどのフィールドや式の評価結果か分かるように括弧で対応付ける。たとえば「単価500円（item.product.price）の商品を3冊（item.quantity）注文する」と書き、値だけを説明から浮かせない。
- 以下の `# => 値` は、値を補足するときの記法。値だけで意味が伝わらない場合は、何を表す値か、なぜそうなるかを普通の文で説明する。コメント記号は対象言語に合わせる。
- 今回の処理で確定する評価結果や状態をコメントで示す。短い結果は行末に書き、何を表す値かや分岐の理由など、長くなる説明は直前のコメントに分ける。
  - 値は `# => 値` の形で書く（例：`# => [ノート]`、`# => 1`）。
  - 値に補足があれば続けて書く（例：`# => 3。在庫の 5 を超えないので在庫不足にはならない`）。
  - 値が自明でない理由も書く（例：`# => 0（クーポンがないので）`）。
- 通らない分岐にも、通らないことと、その理由を書く（例：`# ゲスト購入ではないので通らない`）。
- 列挙型の値や定数など、数値だけでは意味が分からない値をコメントに書くときは、その名前や意味を括弧で添える（例：`# 5（OP_LTE）は 10（OP_EMPTY）ではないので通らない`）。
- 処理がそこで抜ける場合は、どこで抜けて何になるかを書く（例：`return 0  # => 割引額は 0`）。
- 今回の状況では到達しない後続のコードは、必要なら残したうえで「ここより下には来ない」と示す。
- コメントの開始位置は、ブロック内でなるべく揃える。行が長い場合は、次の行に字下げして書いてもよい。
- 説明済みの処理は、見出しやコードを再掲せず、短く参照するだけにする。
  - 同じ関数を別の場所からもう一度呼ぶ場合は、呼び出し元の項目の子に見出しだけを置き、中身は「〜の項目と同じ処理。今回は〜になる」と1文で書く。全体像にも同じ位置に項目を置く。

### 非同期の受け渡し

- 呼び出しの入れ子は直接の関数呼び出しを表す。キュー・チャネル・ネットワーク・コールバックの登録などを経由する場合、送信元が受信側の処理を直接呼んだような入れ子にしない。
- 送信する関数だけで終わらず、受け取る側の実際の関数まで追う。境界では、何を送り、どこで待ち、誰が受け取ってどの処理へ進むかをコードコメントでつなぐ。
- 共通の受け渡しは一度詳しく説明し、繰り返す箇所は送信元・渡す内容・受信先を明記して参照する。経路を短縮したように見せたり、実在しない関数名を作ったりしない。

### コンポーネント（React・Vue）の呼び出し

- React や Vue では、コンポーネントを描くこと（テンプレートや JSX の中で子のコンポーネントを置くこと）も関数呼び出しとして扱う。普通の関数（イベントで呼ぶメソッド、computed、hooks、store の action や mutation など）の呼び出しも、これまでどおり関数呼び出しとして扱う。
  - スクリプトの関数だけをたどると、どの画面の部品がどの部品を置き、どこでイベントが起きるかが抜け落ちる。画面の構造が読み取れるよう、コンポーネントの描画を入れ子の骨組みにする。
- コンポーネントの描画は、`コンポーネント名.template`（Vue）や `コンポーネント名.render`（React の関数コンポーネントの本体）を見出しにする。コード断片には、テンプレートや JSX のうち今回の状況で意味を持つ部分を抜粋する。
- 見出しの名前は、呼び出し元のコードに書かれている名前にそろえる。
  - コンポーネントは、親のテンプレートや JSX で使っている名前（`ValueSlot` など）にする。ファイル名と違う場合も、横に書くファイルのパスで対応が分かる。いちばん外側のコンポーネントは、ファイル名から付ける（`branch.vue` なら `Branch`）。
  - store の関数は `ストアの名前.関数名`（`cart.addItem` など）、ファイルの既定のエクスポート（default export）の関数は、呼び出し元で import している名前にする。
- computed と store の getter は、同じ規則で扱う。
- computed のうち、値を決めるだけの短いもの（文字列を数にするだけ、など）は項目にせず、使う側のコード断片に含めて値をコメントで示す。中で別の関数を呼ぶものや、分岐のあるものは項目にする。
- 描画の項目の子には、次のものを並べる。
  - そのテンプレートや JSX が置く子のコンポーネントの描画
  - そのテンプレートや JSX のイベント（クリックや入力の変更など）で呼ぶ関数
  - そのコンポーネントの watch・computed・ライフサイクル（`created`、`useEffect` など）のうち、今回の状況で動くもの
- 子の並び順は、今回の状況で動く順（開く → 描く → 操作する → 確定する、など）にする。同じ時点で動くものは、画面の上から下の順にする。
- watch やライフサイクルも、ひとつの関数として項目にする（例：`Dialog.watch.value`、`Form.created`）。その中で呼ぶ store の関数などは、その項目の子にする。watch から呼ぶ関数を、watch の項目を飛ばして描画の項目の直下に置かない。
- テンプレートや JSX の断片には、どの欄が何を出すか、どの値で出す・出さないが決まるか、どのイベントでどの関数を呼ぶかを、コメントで書く。今回の状況で置かれない子のコンポーネントにも、置かれないことと理由を書く。
- 親が子に関数を渡し（props の `onUpdate` など）、子がそれを呼んで親の関数が動く場合は、子の項目の下に親の関数を子項目として並べる。どの props で受け取った関数かをコメントで書く。
- 状態の変化で画面が描き直されることは、関数呼び出しとして入れ子にしない。どの値が変わり、どの表示が変わるかを、値を書き換えたコードのコメントで書く。

### スクリーンショット

ユーザーがスクリーンショットを載せると答えた場合は、次のように載せる。

- 画面全体ではなく、今回の部品が写っている部分を切り出す。
- 1枚の画像に複数の部品が写る場合は、部品ごとに色の違う枠で囲み、枠の角に部品の名前（ファイル名など）を描く。どの部分がどの部品かが、画像だけで分かるようにする。
- 切り出した画像は、文書のある場所から相対パスで参照できる場所に保存する（例：文書と同じ階層の `images/`）。ファイル名には、対象のシステムと部品が分かる名前を付ける。
- 画像の大きさは `<img src="..." width="400" alt="...">` のようにそろえる。Markdown の `![...]()` は大きさを指定できないので使わない。
- 画面に見える部品の描画の項目には、それぞれ画像を置く（親の画像を参照する場合を除く）。いちばん外側の画面（一覧など）も省かない。
- 枠と名前のラベルは、画面の文字や入力欄を隠さないように描く。ラベルは枠の外（枠の上の余白など）に置き、余白がなければ画像の外側に余白を足してから描く。枠が入れ子になる場合は、子のラベルを親の枠の中の余白に置いてよい。
- 画像は、その部品に焦点を当てた項目の `<details>` の中に置く。冒頭にまとめて並べない。
  - 基本は描画の項目（`〜.template`・`〜.render`）に置く。操作で画面が変わることを見せたい場合は、その操作で呼ぶ関数の項目に、操作後の画像を置いてよい。
  - 画像の直前に、何が写っていて、枠のどこが今回の項目の部品かを1〜2文で書く。
- 1枚の画像で親と子の部品を枠で示せる場合は、その1枚を親の項目に置く。子の項目では、同じ画像を作り直さずに「親の画像の赤枠の部分」のように参照する。子の部品の細部を見せたいときだけ、子の部分を切り出した画像を別に作る。
- 説明で「ここを押す」と書く操作の場所（マウスを載せたときだけ出るボタンなど）は、見える状態にして撮る。
- 描いたあとの画像を開いて確かめる。ラベルの文字が欠けていないか、枠が部品の境目と合っているかを見て、ずれていれば描き直す。
- 画面を動かして状態を変えて撮った場合（比べるために別の選択肢に切り替えた、など）は、保存されたデータを変えないようにし、どの状態の画面かを説明に書く。
- 確定や保存など、データが変わる操作は画面では行わない。その操作をコードでたどる項目には画像を置かず、「画面では押していないので画像はない」と1文で書く。
- 文字が読める解像度で撮る。撮った画像が画面より縮められていないか確かめ、縮められる場合は、縮められない大きさの表示に変えて撮る。切り出した画像を拡大して大きく見せない（拡大すると文字がぼやける）。表示の大きさは `width` 属性でそろえる。

### 強調すべき点

- ユーザーが今回の変更点や注目点を挙げている場合は、そこを通るか、通らないならなぜ届かないのかを明示する。
- 最終的な結果（戻り値、発生するエラー、状態の変化）が、コードとコメントから読み取れるようにする。

### 折りたたみ

- 出力先が折りたたみ（HTML の `<details>`）を描画できる場合は、メソッドの項目を折りたたむ。
  - 描画できる出力先の例：GitHub の PR・Issue・コメント、Markdown ファイルとして保存して GitHub で見る場合など。ターミナルへの出力のように描画できない場合や、判断がつかない場合は折りたたまない。
- 見出しを `<summary>` に入れ、コード断片と子項目を `<details>` の中に入れる。ネストは箇条書きのまま保つ。
- `<summary>` の中では Markdown のバッククォートが効かないことがあるので、`<code>` タグを使う。
- `<summary>` の直後と `</details>` の直前には空行を入れる。空行がないと、中の Markdown（コードブロックや箇条書き）が描画されない。

折りたたみの書き方は、出力例を参考にする。

## 出力例

元のRubyの注文処理を使い、同じコードに付ける説明の違いを示す。非本質な部分は `...` で省略している。

### 悪い例

```ruby
# 前提
# - cart.items=[ノート×3]、price=500、stock=5、guest?=false、member?=true
# - coupon_code=nil、subtotal=1500、POINT_RATE=0.01

def place(cart, coupon_code)
  ...
  items = cart.items
  items.each do |item|
    if item.quantity > item.product.stock # 3 > 5は偽
      ...
    end
  end
  ...
  total = PriceCalculator.new(user).calculate(cart, coupon_code) # calculateする
  point = PointService.new(user).earn(total) # ポイント計算
  ...
  Order.create!(..., total: total, point: point)
end
```

- 前提に変数や値を詰め込み、何の場面を追うか、どの値が何を表すかを説明していない。
- 「3 > 5は偽」だけでは、注文数と在庫を比べていることや、何を防ぐ分岐かが分からない。
- メソッド名の言い換えだけでは、呼び出す相手の役割や渡す内容が分からない。

### 良い例

同じ注文処理を、呼び出し順に追う。前提では場面を短く示し、在庫・小計・付与率などは、それを使う箇所で説明する。

#### 全体像

- OrderService.place # 在庫を確認し、支払額と付与ポイントを求めて注文を作る
  - PriceCalculator.calculate # 小計から割引額を引いて支払額を求める
    - DiscountResolver.resolve # 利用者とクーポンの条件から割引額を決める
  - PointService.earn # 支払額から付与ポイントを求める

#### 詳細

- <details>
  <summary><code>OrderService.place</code>（<code>app/services/order_service.rb</code>）</summary>

  ```ruby
  # 前提
  # - カートの商品一覧（cart.items）には、単価500円（item.product.price）のノートが3冊（item.quantity）だけ入っている。
  # - ユーザーは会員としてログインしている（user.guest?はfalse、user.member?はtrue）。
  # - クーポン（coupon_code）は入力していないため、値がない状態（nil）とする。

  # 注文する商品を確認し、支払額と付与ポイントを求めて注文を作る。
  # 注文する商品を入れたカート（cart）と、入力されたクーポン（coupon_code）を受け取る。
  def place(cart, coupon_code)
    ...
    # カートから商品一覧（cart.items）を取り出し、注文内容（items）として確認する。
    # 今回は注文数3冊（item.quantity）のノートだけが入っている。
    items = cart.items
    items.each do |item|
      # 注文数（item.quantity）が在庫数（item.product.stock）を超えていないか確認する。
      # 今回は注文数が3冊（item.quantity）、在庫数が5冊（item.product.stock）なので、この分岐には入らない。
      if item.quantity > item.product.stock
        ...
      end
    end
    ...
    # 支払額の計算（PriceCalculator.calculate）に、カートとクーポンを渡す。
    # クーポン（coupon_code）は未入力なので、nilのまま渡す。
    total = PriceCalculator.new(user).calculate(cart, coupon_code)
    # 付与ポイントの計算（PointService.earn）に、支払額（total）を渡す。
    point = PointService.new(user).earn(total)
    ...
    # 計算した支払額（total）と付与ポイント（point）を使って注文を保存する（Order.create!）。
    Order.create!(..., total: total, point: point)
  end
  ```

  - <details>
    <summary><code>PriceCalculator.calculate(..., nil)</code>（<code>app/models/price_calculator.rb</code>）</summary>

    ```ruby
    # カート内の商品代金から割引額を引き、支払額を返す。
    def calculate(cart, coupon_code)
      # 商品ごとの単価（item.product.price）に注文数（item.quantity）を掛け、合計する。
      # 今回は単価500円（item.product.price）で注文数3冊（item.quantity）なので、小計は1,500円（subtotal）となる。
      subtotal = cart.items.sum { |item| item.product.price * item.quantity }

      # 割引額の計算（DiscountResolver.resolve）に、小計とクーポンを渡す。
      discount = DiscountResolver.new(@user).resolve(subtotal, coupon_code)
      ...
      # 小計（subtotal）から割引額（discount）を引き、支払額を求める。
      # 割引が小計を超えても負の金額を返さないよう、0と比べて大きい方を選ぶ。
      [subtotal - discount, 0].max
    end
    ```

    - <details>
      <summary><code>DiscountResolver.resolve(1500, nil)</code>（<code>app/models/discount_resolver.rb</code>）</summary>

      会員割引の判定は、今回の変更で足したもの。

      ```ruby
      # 利用者とクーポンの条件を確認し、今回の注文の割引額を返す。
      def resolve(subtotal, coupon_code)
        # 会員としてログインしていない利用者かどうか（@user.guest?）を調べる。
        # 今回は会員なので、この分岐へは入らない。
        if @user.guest?
          ...
        end
        # クーポンが未入力か、空かを調べる（coupon_code.blank?）。
        # 今回のクーポン（coupon_code）はnilなので、この条件に当てはまる。
        if coupon_code.blank?
          # 割引額0円（DiscountResolver.resolveの戻り値）を返し、この関数の処理は終わる。
          return 0
        end
        ...
        # 会員かどうか（@user.member?）を調べ、会員なら小計に会員割引率（MEMBER_RATE）を掛ける。
        # ただし、今回はクーポン未入力の分岐で返したため、会員でもここへは届かない。
        if @user.member?
          return (subtotal * MEMBER_RATE).floor
        end
        ...
      end
      ```

      </details>

    </details>

  - <details>
    <summary><code>PointService.earn(1500)</code>（<code>app/services/point_service.rb</code>）</summary>

    ```ruby
    # 支払額に応じて、今回の注文に付けるポイントを求める。
    # 価格計算から返った支払額（total）を受け取る。今回は割引がないので1,500円となる。
    def earn(total)
      # 会員としてログインしていない場合（@user.guest?）は、ポイントを付けない。
      # 今回は会員なので、この分岐へは入らない。
      if @user.guest?
        return 0
      end
      ...
      # ポイントの付与率（POINT_RATE）は、1%を表す0.01とする。
      # 支払額1,500円（total）に付与率0.01（POINT_RATE）を掛け、小数点以下を切り捨てる。
      # 計算結果は15ポイント（PointService.earnの戻り値）となる。
      (total * POINT_RATE).floor
    end
    ```

    </details>

  </details>

### Vue の例

架空のアプリの、図書館の予約画面を題材にする。予約の一覧（`ReservationList.vue`）で予約を選ぶと、編集のダイアログ（`ReservationDialog.vue`）が開き、受け取り方法が「配送」なら配送先の入力欄（`DeliveryForm.vue`）を出す。ダイアログは store（`reservation`）を読み書きする。スクリーンショットは載せると答えた場合の例で、画像は架空のもの。

#### 全体像

- ReservationList.template # 予約の一覧を描き、行ごとの編集ボタンと、編集のダイアログを置く
  - ReservationList.selectReservation # 編集ボタンで選んだ予約を覚え、ダイアログを開く
  - ReservationDialog.template # 受け取り方法の選択欄を描き、受け取り方法で下の部品を選ぶ
    - ReservationDialog.watch.value # ダイアログが開いたら、選んだ予約を store に入れる
      - reservation.setReservation
    - DeliveryForm.template # 配送先の入力欄を描く
      - DeliveryForm.onChangePostalCode # 郵便番号が変わったら、store の予約を書き換える
        - reservation.assignAttributes
    - ReservationDialog.save # 保存したら、store の予約を一覧に返す
      - ReservationList.updateReservation # 返ってきた予約で、一覧の予約を置き換える

#### 詳細

- <details>
  <summary><code>ReservationList.template</code>（<code>src/components/ReservationList.vue</code>）</summary>

  予約の一覧。行の右の鉛筆が編集ボタン。

  <img src="images/library-app_reservation-list.png" width="400" alt="予約の一覧">

  ```pug
  //- 前提
  //- - 予約の一覧（reservations）には、本「はじめての園芸」の予約が1件だけある。
  //- - その予約の受け取り方法（reservation.pickupMethod）は配送（'delivery'）。

  ul
    //- 予約（reservations）を1件ずつ描く
    li(v-for="(reservation, i) in reservations" :key="reservation.id")
      span {{ reservation.bookTitle }}
      //- 鉛筆の編集ボタン。押すと、行の番号を渡して予約を選ぶ
      Icon(type="md-create" @click="selectReservation(i)")
  //- 編集のダイアログ。選んだ予約（selectedReservation）があるときだけ開く。
  //- 保存したときに呼ぶ関数（on-save）として、一覧の予約を置き換える関数を渡す
  ReservationDialog(:value="!!selectedReservation" :initial="selectedReservation" :on-save="updateReservation")
  ```

  - <details>
    <summary><code>ReservationList.selectReservation(0)</code>（<code>src/components/ReservationList.vue</code>）</summary>

    ```js
    selectReservation(index) {
      // 選んだ予約（selectedReservation）を覚える。
      // テンプレートでダイアログに渡している値なので、ここでダイアログが開く
      this.selectedReservation = { ...this.reservations[index], index }
    },
    ```

    </details>

  - <details>
    <summary><code>ReservationDialog.template</code>（<code>src/components/ReservationDialog.vue</code>）</summary>

    編集のダイアログ。青で囲んだ受け取り方法の選択欄はダイアログ自身が描き、赤で囲んだ部分は受け取り方法で入れ替わる。

    <img src="images/library-app_reservation-dialog.png" width="400" alt="編集のダイアログ">

    ```pug
    Modal(v-model="visible")
      //- 受け取り方法の選択欄。今回は「配送」
      RadioGroup(v-model="pickupMethod") ...
      //- 受け取り方法（pickupMethod）が配送なので、配送先の入力欄（DeliveryForm）を置く
      DeliveryForm(v-if="pickupMethod === 'delivery'")
      //- 窓口受け取りの案内（CounterNotice）。今回は配送なので置かれない
      CounterNotice(v-else)
      //- 保存ボタン。押すと save を呼ぶ
      Button(@click="save") 保存
    ```

    - <details>
      <summary><code>ReservationDialog.watch.value</code>（<code>src/components/ReservationDialog.vue</code>）</summary>

      ```js
      watch: {
        // 一覧で予約を選んだので、ダイアログを開く値（value）が true になった
        value(val) {
          // 開いたときなので通る
          if (val) {
            // 選んだ予約（initial）を store に入れる
            this.setReservation(this.initial)
          }
        },
      },
      ```

      - <details>
        <summary><code>reservation.setReservation</code>（<code>src/stores/reservation.js</code>）</summary>

        ```js
        setReservation(state, reservation) {
          // 選んだ予約を、store の予約（state.reservation）にする。
          // 受け取り方法（pickupMethod）は配送なので、ダイアログは DeliveryForm を置く
          state.reservation = { ...reservation }
        },
        ```

        </details>

      </details>

    - <details>
      <summary><code>DeliveryForm.template</code>（<code>src/components/DeliveryForm.vue</code>）</summary>

      画面では、編集のダイアログの画像の赤枠の部分。

      ```pug
      //- 郵便番号の入力欄。変えると onChangePostalCode を呼ぶ
      Input(:model-value="reservation.postalCode" @on-change="onChangePostalCode")
      //- 住所の入力欄
      Input(:model-value="reservation.address" ...)
      ```

      - <details>
        <summary><code>DeliveryForm.onChangePostalCode('100-0001')</code>（<code>src/components/DeliveryForm.vue</code>）</summary>

        ```js
        onChangePostalCode(postalCode) {
          // 入力された郵便番号（postalCode）で、store の予約を書き換える
          this.assignAttributes({ postalCode })
        },
        ```

        - <details>
          <summary><code>reservation.assignAttributes</code>（<code>src/stores/reservation.js</code>）</summary>

          ```js
          // store の予約（state.reservation）に、渡した値を書き込む。
          // 郵便番号（postalCode）が '100-0001' になり、入力欄の表示もそれに変わる
          assignAttributes(state, attributes) {
            Object.assign(state.reservation, attributes)
          },
          ```

          </details>

        </details>

      </details>

    - <details>
      <summary><code>ReservationDialog.save</code>（<code>src/components/ReservationDialog.vue</code>）</summary>

      ```js
      save() {
        // store の予約を、一覧から受け取った関数（onSave）に返す
        this.onSave(this.reservation)
      },
      ```

      - <details>
        <summary><code>ReservationList.updateReservation</code>（<code>src/components/ReservationList.vue</code>）</summary>

        ```js
        updateReservation(reservation) {
          // 選んだときに覚えた行の番号（index）の予約を、返ってきた予約で置き換える
          this.reservations[this.selectedReservation.index] = reservation
          // 選んだ予約を消すので、ダイアログが閉じる
          this.selectedReservation = null
        },
        ```

        </details>

      </details>

    </details>

  </details>


$ARGUMENTS
