import 'package:flutter/material.dart';
import 'todo_list_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// エントリーポイント
void main() {
  runApp(const TodoListApp());
}

/// Todoリストアプリのクラス
///
/// 以下の責務を持つ
/// ・Todoリスト画面を生成する
class TodoListApp extends StatelessWidget {
  /// コンストラクタ
  const TodoListApp({Key? key}) : super(key: key);

  /// 画面を作成する
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todoリスト',
      theme: ThemeData(),
      home: const TodoListPage(),
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('ja', '')
      ],
    );
  }
}