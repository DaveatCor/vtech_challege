import 'package:vtech_coding_challenge/domain/model/todo.model.dart';
import 'package:vtech_coding_challenge/domain/usecase/todo/todo.uc.dart';

class TodoUcImpl implements TodoUsecase {

  List<Todo> lstTodo = [
    Todo(
      id: 1,
      title: "Todo 1",
      isCheck: false
    ),
    Todo(
      id: 1,
      title: "Todo 1",
      isCheck: false
    ),
    Todo(
      id: 1,
      title: "Todo 1",
      isCheck: false
    )
  ];
}