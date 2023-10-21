import 'package:flutter/material.dart';
import 'package:vtech_coding_challenge/domain/model/todo.model.dart';
import 'package:vtech_coding_challenge/domain/usecase/todo/todo.uc.impl.dart';

// ignore: must_be_immutable
class TodoScreen extends StatelessWidget{

  TodoScreen({super.key});

  TodoUcImpl todoUcImpl = TodoUcImpl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo - Coding Challenge", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
      ),
      body: Column(
        children: [
          
          Flexible(
            child: ListView.builder(
              itemCount: todoUcImpl.lstTodo.length,
              itemBuilder: (context, index) {
                return TodoItem(todo: todoUcImpl.lstTodo[index],);
              }
            ),
          )
        ],
      ),
    );
  }

}

class TodoItem extends StatelessWidget {

  final Todo? todo;

  const TodoItem({super.key, this.todo});
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Checkbox(
          value: todo?.isCheck, 
          onChanged: (bool? value){
            
          }
        ),

        Flexible(
          child: TextFormField(
            controller: TextEditingController(text: todo?.title),
          ),
        ),

        IconButton(
          onPressed: (){

          },
          icon: const Icon(Icons.delete, color: Colors.red,)
        )
      ],
    );
  }

}