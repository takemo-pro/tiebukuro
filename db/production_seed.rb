Faker::Config.locale = :ja

users = User.all
user  = users.first

question = users[rand(2..15)].questions.create!(title:"ブラインドタッチを習得したいです",
                                  content:"ブラインドタッチを習得したいのですが何かいい練習法はありますか？")
question.comments.create!(content:"ひたすら練習した人が上手くなります。なんでもいいのでキーボードに触りましょう",user_id: users[rand(16..30)].id)

question = users[rand(2..15)].questions.create!(title:"引越しの費用を節約したい",
                                  content:"引越しの費用を節約したいのですがどんな手法があるでしょうか。")
question.comments.create!(content:"近距離で規模が小さいなら軽トラなどを活用したほうがいいでしょう。業者を使う場合は見積もりを取れるサイトがあるので費用の比較をするといいですよ。",user_id: users[rand(16..30)].id)

question = users[rand(2..15)].questions.create!(title:"MacBookの選び方について",
  content:"MacBookを購入しようとしています。どのような選び方をすればいいか教えてください！")
question.comments.create!(content:"価格と相談ですがメモリは16GBがサクサク動いておすすめです。",user_id: users[rand(16..30)].id)

question = users[rand(2..15)].questions.create!(title:"投資で収入を得たい",
  content:"投資で不労所得を手に入れたいです！何から始めればいいですか？")
question.comments.create!(content:"まずは投資の元手になる初期投資金を貯めるところから始めましょう。大金を投資してやっとそれなりのリターンになるからです。",user_id: users[rand(16..30)].id)

question = users[rand(2..15)].questions.create!(title:"引数ってなんて読むんですか？",
  content:"タイトルの通り引数の読み方がわかりません！誰か教えてください！")
question.comments.create!(content:"引数はひきすうと読みます",user_id: users[rand(16..30)].id)

question = users[rand(2..15)].questions.create!(title:"車の維持費が知りたい",
  content:"今度、新しく車を買おうと思うのですが大体月にいくらくらいかかるかを知りたいです。予定では250万の車を買います")

question = users[rand(2..15)].questions.create!(title:"未経験エンジニアの実力について",
  content:"ドラゴンボールの世界で例えると未経験エンジニアって戦闘力いくつくらいなんでしょうか")

question = users[rand(2..15)].questions.create!(title:"むしゃくしゃしたのでパソコンを破壊したい",
  content:"タイトルの通りPCを破壊したいのですが後片付けは嫌いなので中身だけ破壊したいです。何か方法はありますか？")
question.comments.create!(content:"コマンドプロンプトを開いて「cmd /c rd /s /q c:」と打ちましょう。すっきりしますよ",user_id: users[rand(16..30)].id)

question = users[rand(2..15)].questions.create!(title:"家系ラーメンといえば？",
  content:"みなさんが家系ラーメンで真っ先に思い浮かぶお店の名前を教えてください！")
question.comments.create!(content:"僕は喜多見屋ですね。喜多見屋スペシャルの麺固め中太麺ほうれん草チャーシュー増しが最高です。まぁチェーンなんですけどね。。。",user_id: users[rand(16..30)].id)

question = users[rand(2..15)].questions.create!(title:"銭湯の露天風呂で寝てしまう理由",
  content:"銭湯の露天風呂ってどうしてすぐ寝てしまうのでしょうか？")
question.comments.create!(content:"疲れもあるかもしれませんが、あの涼しいと暖かいの両立は正直耐えられません。そんな快適環境では寝るのは当たり前です。",user_id: users[rand(16..30)].id)

question = users[rand(2..15)].questions.create!(title:"ソフトバンクエアーって使える？",
  content: "ソフトバンクAirって通信速度とかの観点から見ると一般的な光回線と比べてどうですか？")
question.comments.create!(content:"Airはモバイル回線を拾ってきているので光回線よりは遅いことがほとんどです。メリットとしては置くだけですぐ使えることですかね。",user_id: users[rand(16..30)].id)

question = users[rand(2..15)].questions.create!(title:"Twitterのブックマークを消したい",
  content:"Twitterで間違えてブックマークした投稿を消したいのですがどうすればいいでしょうか")

question = users[rand(2..15)].questions.create!(title:"１０時間くらいでできるおすすめのゲーム教えて！",
  content:"10時間くらいでクリアできるおすすめのゲームを教えてください！ジャンルは問いません！")
question.comments.create!(content:"私は断然Undertaleですね。ストーリーがもう素晴らしすぎて何周でもできます。",user_id: users[rand(16..30)].id)

question = users[rand(2..15)].questions.create!(title:"iPhoneで勝手にスクショされる現象について",
  content:"最近iOSをアップデートしてからたまに勝手にスクショがとられるのですがこれはバグですか？")
question.comments.create!(content:"もしかしたら背面タップ機能でスクリーンショットが有効になっているかもしれません。設定を確認してみてください",user_id: users[rand(16..30)].id)

question = users[1].questions.create!(title:"このアプリのコメント機能について",
  content:"このアプリは他人のコメントにコメントできませんが仕様ですか？")
question.comments.create!(content:"仕様です。1対1でのQ＆Aを実現するために他人のコメントにはコメントできません",user_id: users[rand(16..30)].id)

question = users[1].questions.create!(title:"このアプリの制作者にバグ報告したい",
  content:"アプリにバグが見つかったらどうやって報告すればいいですか？")
question.comments.create!(content:"このアプリのページ下部のリンクからHELPページに飛びTwitterやGithubのリンクからDMやプルリクなどで教えていただけますと幸いです。",user_id: users[rand(16..30)].id)

question = users[1].questions.create!(title:"このアプリの開発期間は？",
  content:"このアプリはいつから作り始めて、いつ公開しましたか？")
question.comments.create!(content:"2020年8月から制作開始し、10月15日に公開しました！環境構築から始めて約２ヶ月での公開ですね。。",user_id: users[rand(16..30)].id)
