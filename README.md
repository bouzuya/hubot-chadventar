# hubot-chadventar

A Hubot adapter for The Chadventar.

Chadventar のための Hubot アダプターです。

## Chadventar

Chadventar は Hubot Advent Calendar 2014 のための実在しないチャットシステムです。

Chadventar は独自の Web Hook を持っており、メッセージが投稿されたタイミングで、
指定した URL にリクエストを発行します。以下にその仕様を示します。

項目         | 値
-------------|------------
メソッド     | POST
パス         | 指定された URL
パラメーター | name: ユーザー名, text: 投稿されたメッセージ

また Chadventar は独自の API を持っており、HTTP リクエストによりチャットへメッセージを送信することができます。

項目         | 値
-------------|------------
メソッド     | POST
パス         | /messages
パラメーター | name: ユーザー名, text: 投稿されたメッセージ

## hubot-chadventar API

hubot-chadventar は上記 Web Hook をサポートするための API を持ちます。

詳細はソースコードを参照。

## License

MIT

## Author

bouzuya <m@bouzuya.net> (http://bouzuya.net)
