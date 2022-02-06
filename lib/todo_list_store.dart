import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'todo.dart';

/// Todoストアのクラス
///
/// ※当クラスはシングルトンとなる
///
/// 以下の責務を持つ
/// ・Todoを取得/追加/更新/削除/保存/読込する
class TodoListStore {
  /// 保存時のキー
  final String _saveKeyIncompleted = "Todo";

  final String _saveKeyCompleted = "completed";

  /// Todoリスト(未完了)
  List<Todo> _listIncompleted = [];
  /// 完了済みタスクのリスト
  List<Todo> _listCompleted = [];

  /// ストアのインスタンス
  static final TodoListStore _instance = TodoListStore._internal();

  /// プライベートコンストラクタ
  TodoListStore._internal();

  /// ファクトリーコンストラクタ
  /// (インスタンスを生成しないコンストラクタのため、自分でインスタンスを生成する)
  factory TodoListStore() {
    return _instance;
  }

  /// Todoの件数を取得する
  int count() {
    return _listIncompleted.length;
  }

  int countCompleted() {
    return _listCompleted.length;
  }

  /// 指定したインデックスのTodoを取得する
  Todo findByIndex(int index) {
    return _listIncompleted[index];
  }

  Todo findByIndexCompleted(int index) {
    return _listCompleted[index];
  }

  /// "yyyy/MM/dd HH:mm"形式で日時を取得する
  String getDateTime() {
    var format = DateFormat("yyyy/MM/dd HH:mm");
    var dateTime = format.format(DateTime.now());
    return dateTime;
  }

  /// Todoを追加する
  void add(bool done, String title, String detail, String limitDate) {
    var dateTime = getDateTime();
    var todo = Todo(title, detail, done, limitDate, dateTime, dateTime);
    _listIncompleted.add(todo);
    save();
  }

  /// 完了ステータスの更新
  void changeToCompleted(Todo todo){
    if(todo.done){
      print("完了済みに変えました");
      _listIncompleted.remove(todo);
      _listCompleted.add(todo);
    }else{
      _listCompleted.remove(todo);
      _listIncompleted.add(todo);
      print("未完了に変えました");
    }
  }

  /// Todoを更新する
  void update(Todo todo, bool done, [String? title, String? detail, String? limitDate]) {
    todo.done = done;
    if (title != null) {
      todo.title = title;
    }
    if (detail != null) {
      todo.detail = detail;
    }
    todo.updateDate = getDateTime();
    changeToCompleted(todo);
    save();
  }

  /// Todoを削除する
  void delete(Todo todo) {
    _listIncompleted.remove(todo);
    save();
  }

  void deleteCompleted(Todo todo) {
    _listCompleted.remove(todo);
    save();
  }

  void deleteAllCompleted() {
    _listCompleted = [];
    save();
    print(_listCompleted);
  }

  /// Todoを保存する
  void save() async {
    var prefs = await SharedPreferences.getInstance();
    // SharedPreferencesはプリミティブ型とString型リストしか扱えないため、以下の変換を行っている
    // TodoList形式 → Map形式 → JSON形式 → StrigList形式
    var saveTargetListIncompleted = _listIncompleted.map((a) => json.encode(a.toJson())).toList();
    prefs.setStringList(_saveKeyIncompleted, saveTargetListIncompleted);
    var saveTargetListCompleted = _listCompleted.map((a) => json.encode(a.toJson())).toList();
    prefs.setStringList(_saveKeyCompleted, saveTargetListCompleted);
  }

  /// Todoを読込する
  void load() async {
    var prefs = await SharedPreferences.getInstance();
    // SharedPreferencesはプリミティブ型とString型リストしか扱えないため、以下の変換を行っている
    // StrigList形式 → JSON形式 → Map形式 → TodoList形式
    var loadTargetListIncompleted = prefs.getStringList(_saveKeyIncompleted) ?? [];
    _listIncompleted = loadTargetListIncompleted.map((a) => Todo.fromJson(json.decode(a))).toList();

    var loadTargeListCompleted = prefs.getStringList(_saveKeyCompleted) ?? [];
    _listCompleted = loadTargeListCompleted.map((a) => Todo.fromJson(json.decode(a))).toList(); 
  }

}