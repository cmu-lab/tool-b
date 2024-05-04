# Processingによる情報可視化　ステップ2
## 描画方法の工夫　その１


前のプログラムでは、米国の各州ごとに、マルを同じ大きさで描画してゆきましたが、もう少し工夫してみましょう。具体的には、「<span style="color: blue;">random.tsv</span>」というファイルに各州のマルの大きさを、ランダムに書き込んだものを準備し、それに従い描画します。これを実行するために、初期化部、メインループを修正し、さらに、<span style="color: blue;">drawData()</span>という関数を新たに追加します。 詳細な変更については、プログラム内にコメントとして書き込んでありますので、 そちらを参考にしてください。

それでは、まず、以下のリンクを開き、プログラム「<span style="color: blue;">Table2.pde</span>」をコピーアンドペーストして保存してください。<span style="color: red;">※ダウンロードして、エディタで開くと文字化けしてしまう可能性があります。 これ以降は、コピーアンドペーストでゆきましょう！</span>


<p align="center"><a target="_blank" href="Table2.pde">Table2.pdeのプログラム</a></p>



これをProcessingで開き保存すると、<span style="color: blue;">Table2</span> というフォルダができることを確認しましょう。

次に、「<span style="color: blue;">random.tsv</span>」というファイルを、以下のリンクからダウンロードして、Table2 のフォルダに入れましょう。<span style="color: red;">また、「map.png」と「location.tsv」のファイルも、それぞれ一緒のフォルダに入れましょう。 これらのファイルがないと、プログラムは動きませんので、十分に注意してください。</span>

<p align="center"><a href="random.tsv" target="_blank">random.tsvのダウンロード</a>

<span style="color: blue;">random.tsv</span> ファイルの中身は、以下のようになっております。


<p align="center"><img src="rondom_TSV" alt="" border="1" />



以上で、準備は完了です。Table2.pde を実行させてみましょう。以下のような画面が出てくれば、成功です。

<p align="center"><img src="talbe2_result_1" alt="" border="1" />


Table2.pde 内に書かれているコメント、そして、新しく出てきた<span style="color: blue;">map関数</span>についてのリファレンスも参考にしてください。

<p align="center"><a href="http://processing.org/reference/map_.html" target="_blank">map関数の説明</a>





以上の手順、うまくこなせましたか？


#### 練習問題




- マルの大きさの最大値、最小値がそれぞれ 40　と 2 に設定されていましたが、これを変更してみましょう。どうなりますか？

- 赤いマルで塗りつぶすのは、あまりセンスがないので、すこし透明にするには、どうしたらよいでしょうか？



以下の図は、大きさを変更して、透明にしたところです。ちょっと印象が変わりましたね。

<p align="center"><img src="ex_1" alt="" border="1" /></p>



さて、Processing にも慣れて、どんどん色々なことができるようになってきましたね。

<p align="right">次は、色の取扱いに着目してプログラミングしてみましょう。<a href="../mapping_3/mapping_3.html">次にすすむ→</a></p>

<p align="left"><a href="../mapping/mapping_1.html">←前にもどる</a>


<p align="right"><a href="../index.html">トップにもどる↑</a>
