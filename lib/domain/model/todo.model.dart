import 'package:flutter/material.dart';

class Todo {

  int? id;
  ValueNotifier<String>? title;
  ValueNotifier<bool>? isCheck;
  ValueNotifier<bool>? isUpdate = ValueNotifier(false);
  ValueNotifier<bool>? isEdited = ValueNotifier(false);

  Todo({
    this.id,
    this.title,
    this.isCheck,
    this.isEdited
  });

  factory Todo.fromJson(Map<String, dynamic> map) => Todo(isEdited: ValueNotifier(map['is_edited']), id: map['id'], title: ValueNotifier(map['title']), isCheck: ValueNotifier(map['is_check']));

  Map<String, dynamic> toJson(Todo todo){
    return {
      'id': id,
      'title': title,
      'is_check': isCheck,
      'is_edited': isEdited,
    };
  }

}