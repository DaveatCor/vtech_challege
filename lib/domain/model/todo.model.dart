class Todo {

  int? id;
  String? title;
  bool? isCheck;

  Todo({
    this.id,
    this.title,
    this.isCheck
  });

  factory Todo.fromJson(Map<String, dynamic> map) => Todo(id: map['id'], title: map['title'], isCheck: map['is_check']);

  Map<String, dynamic> toJson(Todo todo){
    return {
      'id': id,
      'title': title,
      'is_check': isCheck,
    };
  }

}