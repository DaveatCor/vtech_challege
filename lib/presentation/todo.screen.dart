import 'package:flutter/material.dart';
import 'package:vtech_coding_challenge/domain/usecase/todo/todo.uc.impl.dart';

// ignore: must_be_immutable
class TodoScreen extends StatelessWidget{

  TodoScreen({super.key});

  final TodoUcImpl todoUcImpl = TodoUcImpl();

  @override
  Widget build(BuildContext context) {
    
    todoUcImpl.context = context;

    todoUcImpl.initTodoState();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo - Coding Challenge", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
      
            Row(
              children: [
                
                Expanded(
                  child: TextFormField(
                    controller: todoUcImpl.controller,
                    onFieldSubmitted: todoUcImpl.onSubmit,
                    decoration: const InputDecoration(
                      hintText: "Input item"
                    ),
                  ),
                ),
                
                ValueListenableBuilder(
                  valueListenable: todoUcImpl.editItemIndex, 
                  builder: (context, editItemIndex, wg){
                    
                    if (editItemIndex.isNegative) return const SizedBox();
                    
                    return Row(
                      children: [

                        TextButton(
                          onPressed: todoUcImpl.update, 
                          child: const Text("Update", style: TextStyle(fontWeight: FontWeight.bold),)
                        ),

                        IconButton(
                          onPressed: todoUcImpl.reset, 
                          icon: const Icon(Icons.clear)
                        )
                      ],
                    );
                  }
                ),
              ],
            ),
            const SizedBox(height: 20,),
      
            const Text("Items", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),),
            
            const SizedBox(height: 20,),
            Flexible(
              child: ValueListenableBuilder(
                valueListenable: todoUcImpl.isReady,
                builder: (context, isReady, wg) {
                  
                  if (isReady == false) return const Center(child: CircularProgressIndicator(),);
      
                  if (todoUcImpl.lstTodo.isEmpty) return const Center(child: Text("Empty"),);
      
                  return ListView.builder(
                    itemCount: todoUcImpl.lstTodo.length,
                    itemBuilder: (context, index) {
                      return TodoItem(index: index, todoUcImpl: todoUcImpl);
                    }
                  );
                  
                }
              ),
            )
          ],
        ),
      ),
    );
  }

}

class TodoItem extends StatelessWidget {

  final int? index;

  final TodoUcImpl? todoUcImpl;

  const TodoItem({super.key, required this.index, required this.todoUcImpl});
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        ValueListenableBuilder(
          valueListenable: todoUcImpl!.lstTodo[index!].isCheck!,
          builder: (context, isCheck, wg) {
            return Checkbox(
              value: isCheck, 
              onChanged: (bool? value){
                todoUcImpl?.lstTodo[index!].isCheck?.value = value!;
                // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                todoUcImpl!.lstTodo[index!].title!.notifyListeners();
              }
            );
          }
        ),

        Expanded(
          child: ValueListenableBuilder(
            valueListenable: todoUcImpl!.lstTodo[index!].title!,
            builder: (context, title, wg){

              return Text(
                title, 
                style: TextStyle(
                  decoration: (todoUcImpl!.lstTodo[index!].isCheck!.value) == true ? TextDecoration.lineThrough : TextDecoration.none,
                  fontSize: 20
                )
              );

            },
          ),
        ),

        // This ValueListenableBuilder Use For Show/Hide Whenever Item Mark Checked/Un-Check
        ValueListenableBuilder(
          valueListenable: todoUcImpl!.lstTodo[index!].isCheck!, 
          builder: (context, isCheck, wg){

            if (isCheck == true) return const SizedBox();
            
            return IconButton(
              onPressed: (){
                todoUcImpl?.editItemIndex.value = index!;
                todoUcImpl!.clickUpdate();
              },
              icon: const Icon(Icons.edit)
            );

          }
        )

      ],
    );
  }

}