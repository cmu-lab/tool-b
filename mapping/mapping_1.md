# Processingによる情報可視化 ステップ1


## データファイルを取り込んでマップ上に描画

下準備の段階で、画像map.pngを読み込んで描画できるようになっているはずです。今度は、「<span style="color: blue;">locations.tsv</span>」というTSV形式（タブで区切ってあるデータ形式のこと）を読み込んで、それを画像上に描画します。

<span style="color: red;">ここから、一気にプログラムが長くなるので十分注意してください！</span>

1. まず、<span style="color: blue;">Table1.pde</span> というプログラムを以下のリンクからダウンロードし、これを<span style="color: blue;">Processing_data</span>のフォルダの下に保存してください。これを、Processing のエディタで開くと、<span style="color: blue;">Table1</span>フォルダが作られるはずです。 作られない場合は、mappingのプログラム同様、Processingフォルダの下に保存してください。そうすると自動的にTable1フォルダが作られます。


<span style="color: red;">[注意]計算機の環境によっては、ダウンロードしたプログラムがうまく動かない場合もあります。この場合はプログラムをコピー、そしてProcessingのエディタにペーストするとうまくゆくとおもいます。</span>


<p align="center"><a target="_blank" href="./Table1.pde" download="./Table1.pde">Table1.pdeのプログラム</a></p>

Table1.pdeは、かなり長いプログラムなので、びっくりする人もいるかもしれませんが、後ほど、じっくりその構造について解説しますので、現段階では、こんなもんなんだ、と思って、以下の作業を進めてください。


2. 次に、mappingフォルダにある「map.png」も、Tableフォルダにコピーしましょう。また、以下の「location.tsv」というTSV形式のデータもダウンロードし、Tableフォルダにコピーしましょう。以上の操作から、フォルダの中身は以下のようになっているはずです。



<p align="center"><a target="_blank" href="./Table/locations.tsv">locations.tsv をダウンロード</a>

<p align="center">
  <img src="table_1" alt="" border="1">
</p>


ちなみに、「locations.tsv」の中身は、以下のようなデータが格納されております。
1列目は<span style="color: blue;">米国の各州の略称</span>、2列目は<span style="color: blue;">X座標</span>、3列目は<span style="color: blue;">Y座標</span>を示しています。



<p align="center">
  <img src="./TSV_file" alt="" border="1">
</p>



この状態で、<span style="color: blue;">Table1.pde</span>を実行してみましょう。以下のような画面が出れば成功です。

<p align="center" src="table_2">
  <img src="table_2" alt="" width="553" height="368" border="1">
</p>





## Table.pdeプログラムの解説

さて、ここから「<span style="color: blue;">Table.pde</span>」プログラムの解説を行います。

<span style="color: blue;">Table.pde</span>プログラムでは、これまでのプログラムとは異なり、<span style="color: blue;">構造化プログラミング</span>という技法が導入されています。これはプログラムに



- 初期化部　setup()
- メインループ draw()
- その他の関数・・・




という構造を持たせ、より高度な機能を実現させるためのものです。<span style="color: blue;">Table1.pde</span>を注意深く見てください。上記の構造のように



- 初期化部　setup()
- メインループ draw()
- Tableクラスの定義



といった構造を持っていることがわかると思います。





<span style="color: blue;">初期化部</span>では、ウィンドウサイズの設定や、読みこむ画像、TSVファイルの宣言などを行います。

<span style="color: blue;">メインループdraw()</span>では、文字通り、ここのループがメインになりプログラムを動かしてゆくことになります。最初のうちは、あまり意識しませんが、このメインループは、<span style="color: red;">1秒間に何十回という速さ</span>で、ループ処理を繰り返しています。マウスによるインタラクションの際、このループ処理の意味が理解できるようになると思います。現時点では、「ふーん、そうなの」という具合で、流してもらって結構です。

この<span style="color: blue;">draw()</span>では、その下で定義されている<span style="color: blue;">Table</span>クラスの各種関数を呼び出すことで、高度な機能を実現させることができます。この<span style="color: blue;">Table1.pde</span>プログラムでは、下のTableクラスのごく一部の関数しか使っていないので、プログラムの構造を理解するには、<span style="color: red;">初期化部とメインループだけ重点的に注意すれば十分</span>です。



#### 初期化部の解説

さて、<span style="color: blue;">Table1.pde</span> プログラムでは、初期化部で、画像ファイル「<span style="color: blue;">map.png</span>」、TSV形式のファイル「<span style="color: blue;">locations.tsv</span>」 、そして<span style="color: blue;">locationTable.getRowCount()</span>というコマンドで、<span style="color: blue;">locations.tsv</span>ファイルの行数をカウントし、その結果を<span style="color: blue;">rowCount</span>に格納しています。<span style="color: blue;">locationTable.getRowCount()</span>は、メインループの下の<span style="color: blue;">Table</span>のクラスで定義されており、詳細は、そちらを参照してもらうとよいと思います。もし、詳細が理解できなければ、「まあ、こんなもんだろう」、という感じで流していただいて結構です。



#### メインループの解説

<span style="color: blue;">Table1.pde</span>のメインループ、すなわち<span style="color: blue;">draw()</span>の部分についてですが、まず、背景を255にセット、「<span style="color: blue;">map.png</span>」ファイルを、<span style="color: blue;">座標(0,0)</span>の位置を始点として貼り付けています。この画像の上に、<span style="color: blue;">location.tsv</span>から読み込んだ座標に基づき、マルを描いてゆくのが、メインループの主なお仕事です。

<span style="color: blue;">for</span>文では、初期化部において取得したtsvファイルの行数<span style="color: blue;">rowCount</span>が使われており、0行目からrowCount目まで、順次、数値を読みだし、それらをx,y座標として<span style="color: blue;">ellipse</span>コマンドでマルを描く、という流れになっております。簡単でしょう？

また、目で確認するのが難しいですが、このdraw()のメインループは、1秒間に何十回という速さでループし、描画を繰り返しています。これを実感するために、ちょっと横道にそれますが、以下のプログラムを実行してみてください。





## メインループの繰り返し処理を実感しよう

以下のプログラムを、コピー、ペーストし、ちょっと動かしてみてください。


<p align="center"><a target="_blank" href="./sample.pde">サンプルプログラム</a></p>



どうですか？メインループの中が、ものすごい速さで繰り返し処理され、カラフルな四角形がどんどん描画されているのがわかりましたか？米国の地図を描画するプログラムでは、毎回、同じ処理が行われるため、メインループが繰り返し処理されているのがわかりにくいのですが、実際は、1秒間に何十回という速さで、画像を上書きをしています。



さて、これまでの流れを理解したら、次に進みましょう。

<p align="right"><a href="../mapping_2/mapping_2.html" >次にすすむ→</a></p>
