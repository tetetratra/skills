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
- 状況が曖昧で値や分岐が決まらない場合は、解説を始める前にユーザーへ確認するか、自分で置いた仮定を「前提」に明記する。
- コードから値や挙動を確定できない箇所は、推測である旨を明記する。

## 書き方

### 文体

- 前提・説明文・コメントは、すべてです・ます調ではなく言い切りの形で書く。

### 前提

- どんな状況を考えるのかを、最初の呼び出し（入口のメソッド）のコード断片の先頭に、`# 前提` から始まるコメントとして書く。別の項目は立てない。
- 条件は `# - ` で始まる行に1つずつ書く。
- 各条件には、その条件がコード上のどの変数・属性・メソッドの値にあたるのかを、名前とともに書く（例：`# - カート（cart.items）には「ノート（500円）」が3個だけ入っている`）。
- データの構成や、値が nil・空であるかなど、以降の分岐を決める条件をここで固定する。

### 全体の構造

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

- 行末のコメントで、その行の評価結果や状態を書く。
  - 値は `# => 値` の形で書く（例：`# => [ノート]`、`# => 1`）。
  - 値に補足があれば続けて書く（例：`# => 3。在庫の 5 を超えないので在庫不足にはならない`）。
  - 値が自明でない理由も書く（例：`# => 0（クーポンがないので）`）。
- 通らない分岐にも、通らないことと、その理由を書く（例：`# ゲスト購入ではないので通らない`）。
- 処理がそこで抜ける場合は、どこで抜けて何になるかを書く（例：`return 0  # => 割引額は 0`）。
- 今回の状況では到達しない後続のコードは、必要なら残したうえで「ここより下には来ない」と示す。
- コメントの開始位置は、ブロック内でなるべく揃える。行が長い場合は、次の行に字下げして書いてもよい。
- 説明済みの処理は、見出しやコードを再掲せず、短く参照するだけにする。

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

以下は出力の形式と粒度の例です（折りたたみを使える場合）。内容ではなく、書き方を参考にしてください。

- <details>
  <summary><code>OrderService.place</code>（<code>app/services/order_service.rb</code>）</summary>

  ```ruby
  # 前提
  # - カート（cart.items）には「ノート（500円）」が3個だけ入っている
  # - ノートの在庫（product.stock）は5個ある
  # - 会員としてログインしている（user.guest? は false、user.member? は true）
  # - クーポンコード（coupon_code）は入力していない（nil）
  # - ポイントの付与率（PointService::POINT_RATE）は 0.01

  def place(cart, coupon_code)
    ...
    items = cart.items                       # => [ノート × 3]
    items.each do |item|
      if item.quantity > item.product.stock  # 3 > 5 は偽なので通らない
        ...
      end
    end
    ...
    # 支払額を求める。coupon_code は nil のまま渡す
    total = PriceCalculator.new(user).calculate(cart, coupon_code)
    point = PointService.new(user).earn(total)              # 支払額に応じた付与ポイントを求める
    ...
    Order.create!(..., total: total, point: point)          # 支払額と付与ポイントをもとに注文を作る
  end
  ```

  - <details>
    <summary><code>PriceCalculator.calculate(..., nil)</code>（<code>app/models/price_calculator.rb</code>）</summary>

    ```ruby
    def calculate(cart, coupon_code)
      subtotal = cart.items.sum { |item| item.product.price * item.quantity }
                                             # => 1500
      # 割引額を求める
      discount = DiscountResolver.new(@user).resolve(subtotal, coupon_code)
      ...
      [subtotal - discount, 0].max           # 小計から割引額を引いたものを支払額として返す
    end
    ```

    - <details>
      <summary><code>DiscountResolver.resolve(1500, nil)</code>（<code>app/models/discount_resolver.rb</code>）</summary>

      会員割引の判定は、今回の変更で足したもの。

      ```ruby
      def resolve(subtotal, coupon_code)
        if @user.guest?                      # 会員なので通らない
          ...
        end
        if coupon_code.blank?                # nil は blank
          return 0                           # => 割引額は 0
        end
        ...
        # ここより下には来ないので、会員割引の判定には届かない
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
    def earn(total)
      if @user.guest?                        # 会員なので通らない
        return 0
      end
      ...
      (total * POINT_RATE).floor             # => 15（1500 × 0.01）
    end
    ```

    </details>

  </details>

$ARGUMENTS
