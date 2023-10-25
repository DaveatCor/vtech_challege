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
    'title': 'dog',
    'is_check': false,
    'is_edited': false 
  },
  {
    'id': 2, 
    'title': 'cat',
    'is_check': false,
    'is_edited': false
  },
  {
    'id': 3, 
    'title': 'donky',
    'is_check': false,
    'is_edited': false
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

        sortAtoZ();

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
        
        filterTodo = filterMatchInput(value!.replaceAll(" ", "")).map((e) => e).toList();

        isInputting.value = false;
        
        if (value.isEmpty) filterTodo = null;
      }
    );

    return value!;
  }

  @override
  void onSubmit(String? value){

    // Update item
    if (editItemIndex.value != -1){
      controller.text = value!.replaceAll(" ", "");
      update();
    }
    // Add new item 
    else {
      if (value!.isNotEmpty){

        // Show Warning
        if (isAvailableItem(value.replaceAll(" ", ""))){
          ScaffoldMessenger.of(context!).showSnackBar( const SnackBar(content: Text('Item already exist')));
        } else {

          print("value $value");

          controller.text = value.replaceAll(" ", "");

          addItem();
        }
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

    sortAtoZ();

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

    print("lstTodo.isEmpty) ${lstTodo.isEmpty}");
    if (filterTodo!.isEmpty) {

      lstTodo[editItemIndex.value].title!.value = controller.text;

      if(lstTodo[editItemIndex.value].isEdited!.value == false) {
        lstTodo[editItemIndex.value].isEdited!.value = true;
      }
      
      print("lstTodo[editItemIndex.value].title!.value ${lstTodo[editItemIndex.value].title!.value}");

      resetUpdate();

      resetFilter();

      sortAtoZ();
    }
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

    sortAtoZ();

  }
  
  List<Todo> filterMatchInput(String value){
    return lstTodo.where((e) {
      if (e.title?.value == value) return true;
      return false;
    }).toList();
  }

  void resetFilter() {

    filterTodo = null;
    controller.clear();
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    isInputting.notifyListeners();
  }

  @override
  void resetUpdate() {
    lstTodo[editItemIndex.value].isUpdate!.value = false;
    controller.clear();
    editItemIndex.value = -1;
    resetFilter();
  }

  @override
  void afterDelete(){
    editItemIndex.value = -1;
    controller.clear();
  }
  
  void sortAtoZ() {
    lstTodo.sort((a, b){
      return a.title!.value.compareTo(b.title!.value);
    });
  }
  
  // void sortByChecked() {
  //   print(lstTodo.map((e) {
  //     if (e.isCheck!.value == true) return e;
  //   }));

  // }
}