/// Todoモデルのクラス
///
/// 以下の責務を持つ
/// ・Todoのプロパティを持つ
class Todo {

  /// タイトル
  late String title;

  /// 詳細
  late String detail;

  /// 完了か
  late bool done;

  /// ToDo期日
  late String limitDate;

  /// 作成日時
  late String createDate;

  /// 更新日時
  late String updateDate;

  /// コンストラクタ
  Todo(
    this.title,
    this.detail,
    this.done,
    this.limitDate,
    this.createDate,
    this.updateDate,
  );

  /// TodoモデルをMapに変換する(保存時に使用)
  Map toJson() {
    return {
      'title': title,
      'detail': detail,
      'done': done,
      'limitDate': limitDate,
      'createDate': createDate,
      'updateDate': updateDate
    };
  }

  /// MapをTodoモデルに変換する(読込時に使用)
  Todo.fromJson(Map json) {
    title = json['title'];
    detail = json['detail'];
    done = json['done'];
    limitDate = json['limitDate'];
    createDate = json['createDate'];
    updateDate = json['updateDate'];
  }
}