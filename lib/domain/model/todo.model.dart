import 'package:flutter/material.dart';

class Todo {

  int? id;
  ValueNotifier<String>? title;
  ValueNotifier<bool>? isCheck;

  Todo({
    this.id,
    this.title,
    this.isCheck
  });

  factory Todo.fromJson(Map<String, dynamic> map) => Todo(id: map['id'], title: ValueNotifier(map['title']), isCheck: ValueNotifier(map['is_check']));

  Map<String, dynamic> toJson(Todo todo){
    return {
      'id': id,
      'title': title,
      'is_check': isCheck,
    };
  }

}