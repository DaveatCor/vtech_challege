import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:vtech_coding_challenge/domain/model/todo.model.dart';
import 'package:vtech_coding_challenge/domain/usecase/todo/todo.uc.dart';
import 'package:vtech_coding_challenge/presentation/widgets/dialog.custom.dart';

List<Map<String, dynamic>> sampleData = [
  {
    'id': 1, 
    'title': 'ab',
    'is_check': false
  },
  {
    'id': 2, 
    'title': 'abc',
    'is_check': false
  },
  {
    'id': 3, 
    'title': 'abcd',
    'is_check': false
  }

];

class TodoUcImpl implements TodoUsecase {

  List<Todo> lstTodo = [];

  // This member use to handle data loading
  ValueNotifier<bool> isReady = ValueNotifier(false);
  ValueNotifier<int> editItemIndex = ValueNotifier(-1);
  
  BuildContext? context;

  Response? response;

  TextEditingController controller = TextEditingController();

  set setBuildContext(BuildContext ctx){
    context = ctx;
  }

  void initTodoState() async {
    
    await Future.delayed(const Duration(seconds: 1), () async {

      response = Response(jsonEncode(sampleData), 200);

      lstTodo = List.from(jsonDecode(response!.body)).map((e) => Todo.fromJson(e)).toList();

      isReady.value = true;
      
    });
  }

  @override
  void deleteItem(int index) async {

    await DialogCustom().deleteItem(context!, lstTodo[index].title!.value).then((value) {

      print("deleteItem $value");
      if (value != null){

        lstTodo.removeAt(index);

        // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
        isReady.notifyListeners();

      }
    });
  }

  void onSubmit(String? value){
    
    if (value!.isNotEmpty){
      print("isAvailableItem(value) ${isAvailableItem(value)}");
      // Show Warning
      if (isAvailableItem(value)){
        ScaffoldMessenger.of(context!).showSnackBar( const SnackBar(content: Text('Item already exist')));
      } else {
        addItem();
      }
    }
  }

  bool isAvailableItem(String? value){
    return lstTodo.where((element) {
      if (element.title == value) return true;
      return false;
    }).isNotEmpty;
  }

  void addItem(){
    
    lstTodo.add(
      Todo(id: lstTodo.length, title: ValueNotifier(controller.text), isCheck: ValueNotifier(false))
    );

    controller.clear();

    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    isReady.notifyListeners();
  }

  void clickUpdate() {
    controller.text = lstTodo[editItemIndex.value].title!.value;
  }

  void update(){
    
    lstTodo[editItemIndex.value].title!.value = controller.text;
    reset();
  }

  void reset() {
    controller.clear();
    editItemIndex.value = -1;
  }
}