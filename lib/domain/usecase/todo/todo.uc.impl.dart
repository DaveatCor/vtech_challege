import 'dart:convert';
import 'package:easy_debounce/easy_debounce.dart';
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
  List<Todo>? filterTodo;

  // This member use to handle data loading
  ValueNotifier<bool> isReady = ValueNotifier(false);
  ValueNotifier<int> editItemIndex = ValueNotifier(-1);
  ValueNotifier<bool> isInputting = ValueNotifier(false);
  
  BuildContext? context;

  Response? response;

  TextEditingController controller = TextEditingController();

  set setBuildContext(BuildContext ctx){
    context = ctx;
  }

  @override
  void initTodoState() async {

    // Prevent Rebuild By TextFormField
    if (isReady.value == false){
      await Future.delayed(const Duration(seconds: 1), () async {

        response = Response(jsonEncode(sampleData), 200);

        lstTodo = List.from(jsonDecode(response!.body)).map((e) => Todo.fromJson(e)).toList();

        isReady.value = true;
        
      });
    }
  }

  @override
  String onChanged(String? value){
    
    if (isInputting.value == false){
      isInputting.value = true;
    }
    filterTodo = [];

    EasyDebounce.debounce(
      'onChange', const Duration(seconds: 1), () {
        filterTodo = filterMatchInput(value!).map((e) => e).toList();

        isInputting.value = false;
        
        if (value.isEmpty) filterTodo = null;
      }
    );

    return value!;
  }

  @override
  void onSubmit(String? value){
    
    if (value!.isNotEmpty){
      // Show Warning
      if (isAvailableItem(value)){
        ScaffoldMessenger.of(context!).showSnackBar( const SnackBar(content: Text('Item already exist')));
      } else {
        addItem();
      }
    }
  }

  @override
  bool isAvailableItem(String? value){
    return lstTodo.where((element) {
      if (element.title!.value == value) return true;
      return false;
    }).isNotEmpty;
  }

  @override
  void addItem(){
    
    lstTodo.add(
      Todo(id: lstTodo.length, title: ValueNotifier(controller.text), isCheck: ValueNotifier(false))
    );

    resetFilter();

    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    isReady.notifyListeners();
  }

  @override
  void clickUpdate(int index) {

    editItemIndex.value = index;

    lstTodo[editItemIndex.value].isUpdate!.value = true;
    controller.text = lstTodo[editItemIndex.value].title!.value;
    
  }

  @override
  void update(){
    
    lstTodo[editItemIndex.value].title!.value = controller.text;
    resetUpdate();
    resetFilter();
  }

  @override
  void deleteItem(int index) async {

    await DialogCustom().deleteItem(context!, lstTodo[index].title!.value).then((value) {

      if (value != null){

        lstTodo.removeAt(index);
        
        afterDelete();

        // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
        isReady.notifyListeners();

      }
    });
  }

  @override
  void checkItem(bool? value, int index) {

    lstTodo[index].isCheck?.value = value!;

    // This below is to noify Text to LineThrough / None
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    lstTodo[index].title!.notifyListeners();

  }
  
  List<Todo> filterMatchInput(String value){
    print("filterMatchInput");
    return lstTodo.where((e) {
      print("e.title?.value ${e.title?.value}");
      print("value $value");
      print(e.title?.value == value);
      if (e.title?.value == value) return true;
      return false;
    }).toList();
  }

  void resetFilter() {

    filterTodo = null;
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    isInputting.notifyListeners();
  }

  @override
  void resetUpdate() {
    lstTodo[editItemIndex.value].isUpdate!.value = false;
    controller.clear();
    editItemIndex.value = -1;
    
  }

  @override
  void afterDelete(){
    editItemIndex.value = -1;
    controller.clear();
  }
  
}