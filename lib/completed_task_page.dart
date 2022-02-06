import 'todo.dart';
import 'todo_list_store.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';


class CompletedTasks extends StatefulWidget {
  const CompletedTasks({Key? key}) : super(key: key);

  @override
  State<CompletedTasks> createState() => _CompletedTasksState();
}

class _CompletedTasksState extends State<CompletedTasks> {
  final TodoListStore _store = TodoListStore();

  @override
  void initState() {
    super.initState();

    setState(() {
      _store.load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('完了済みタスク'),
        actions: [
          IconButton(onPressed: (){
            setState(() => _store.deleteAllCompleted());
          }, 
          icon: const Icon(Icons.delete))
        ],
      ),
      body: ListView.builder(
        itemCount: _store.countCompleted(),
        itemBuilder: (context, index) {
          var item = _store.findByIndexCompleted(index);
          return Slidable(
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              extentRatio: 0.25,
              children: [
                SlidableAction(
                  onPressed: (context) {
                    // Todoを削除し、画面を更新する
                    setState(() => {_store.deleteCompleted(item)});
                  },
                  backgroundColor: Colors.red,
                  icon: Icons.delete,
                  label: '削除',
                ),
              ],
            ),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey)),
              ),
              child: ListTile(
                title: Text(item.title),
                trailing: Checkbox(
                  value: item.done,
                  onChanged: (bool? value) {
                    showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                        content: const Text("ToDoリストに戻しますか"),
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
              ),
            ),
          );
        },
      ),
    );
  }
}