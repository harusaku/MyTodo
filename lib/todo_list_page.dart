import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'todo_input_page.dart';
import 'completed_task_page.dart';
import 'todo_list_store.dart';
import 'todo.dart';

/// Todoリスト画面のクラス
///
/// 以下の責務を持つ
/// ・Todoリスト画面の状態を生成する
class TodoListPage extends StatefulWidget {
  /// コンストラクタ
  const TodoListPage({Key? key}) : super(key: key);

  /// Todoリスト画面の状態を生成する
  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

/// Todoリスト画面の状態クラス
///
/// 以下の責務を持つ
/// ・Todoリストを表示する
/// ・Todoの追加/編集画面へ遷移する
/// ・Todoの削除を行う
class _TodoListPageState extends State<TodoListPage> {
  /// ストア
  final TodoListStore _store = TodoListStore();

  /// Todoリスト入力画面に遷移する
  void _pushTodoInputPage([Todo? todo]) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return TodoInputPage(todo: todo);
        },
      ),
    );

    // Todoの追加/更新を行う場合があるため、画面を更新する
    setState(() {});
  }

  /// 初期処理を行う
  @override
  void initState() {
    super.initState();

    setState(() {
      _store.load();
    });
  }

  /// 画面を作成する
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // アプリケーションバーに表示するタイトル
        title: const Text('Todoリスト'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () async {
              setState(() {});
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CompletedTasks(),
                ),
              );
              setState(() {});
            },
          )
        ],
      ),
      body: ListView.builder(
        // Todoの件数をリストの件数とする
        itemCount: _store.count(),
        itemBuilder: (context, index) {
          // インデックスに対応するTodoを取得する
          var item = _store.findByIndex(index);
          return Slidable(
            // 右方向にリストアイテムをスライドした場合のアクション
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              extentRatio: 0.25,
              children: [
                SlidableAction(
                  onPressed: (context) {
                    // Todo編集画面に遷移する
                    _pushTodoInputPage(item);
                  },
                  backgroundColor: Colors.yellow,
                  icon: Icons.edit,
                  label: '編集',
                ),
              ],
            ),
            // 左方向にリストアイテムをスライドした場合のアクション
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              extentRatio: 0.25,
              children: [
                SlidableAction(
                  onPressed: (context) {
                    // Todoを削除し、画面を更新する
                    setState(() => {_store.delete(item)});
                  },
                  backgroundColor: Colors.red,
                  icon: Icons.edit,
                  label: '削除',
                ),
              ],
            ),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey),
                ),
              ),
              child: ListTile(
                // タイトル
                leading: Checkbox(
                  // チェックボックスの状態
                  value: item.done,
                  onChanged: (bool? value){
                    showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                        content: const Text("完了としてマークしますか"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context, "OK");
                              setState(() => _store.update(item, value!));
                            },
                            child: const Text('OK')
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, "Cancel"),
                            child: const Text("Cancel")
                          ),
                        ],
                      ),
                    );
                  }
                ),
                title: Text(item.title),
                subtitle: Text(item.limitDate=="" ? "期限なし" :item.limitDate+"まで"),
                // 完了か
                trailing: IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () => showDialog<String>(
                    context: context, 
                    builder: (BuildContext context) => AlertDialog(
                      title: Text(item.title),
                      content: Text(item.detail),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () async {
                              Navigator.pop(context, "編集");
                              _pushTodoInputPage(item);
                            },
                          child: const Text('編集')
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, "閉じる"), 
                          child: const Text("閉じる")
                        ),
                      ],
                    )
                  ),
                ),
              ),
            ),
          );
        },
      ),
      // Todo追加画面に遷移するボタン
      floatingActionButton: FloatingActionButton(
        // Todo追加画面に遷移する
        onPressed: _pushTodoInputPage,
        child: const Icon(Icons.add),
      ),
    );
  }
}