import 'package:flutter/material.dart';
import 'package:vtech_coding_challenge/domain/model/todo.model.dart';
import 'package:vtech_coding_challenge/domain/usecase/todo/todo.uc.impl.dart';

// ignore: must_be_immutable
class TodoScreen extends StatelessWidget{

  TodoScreen({super.key});

  final TodoUcImpl todoUcImpl = TodoUcImpl();

  @override
  Widget build(BuildContext context) {
    
    todoUcImpl.context = context;

    todoUcImpl.initTodoState();

    print(todoUcImpl.isInputting.value);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo - Coding Challenge", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
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
                      onChanged: todoUcImpl.onChanged,
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
                            onPressed: todoUcImpl.resetUpdate, 
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
              Expanded(
                child: Stack(
                  children: [
                    
                    Container(
                      color: Colors.white,
                      child: ValueListenableBuilder(
                        valueListenable: todoUcImpl.isReady,
                        builder: (context, isReady, wg) {
                          
                          if (isReady == false) return const Center(child: CircularProgressIndicator(),);
                          
                          if (todoUcImpl.lstTodo.isEmpty) return const Center(child: Text("Empty"),);
                          
                          return ListView.builder(
                            itemCount: todoUcImpl.lstTodo.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return TodoItem(
                                index: index, 
                                todo: todoUcImpl.lstTodo[index],
                                checkItem: todoUcImpl.checkItem,
                                clickUpdate: todoUcImpl.clickUpdate,
                                deleteItem: todoUcImpl.deleteItem,
                              );
                            }
                          );
                          
                        }
                      ),
                    ),
                    
                    // Show Match Items When Input
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: ValueListenableBuilder(
                        valueListenable: todoUcImpl.isInputting,
                        builder: (context, isInputting, wg) {
                          
                          if (isInputting == true) return const Center(child: CircularProgressIndicator(),);
                          
                          if (todoUcImpl.filterTodo == null) return const SizedBox();
                          
                          if (todoUcImpl.filterTodo!.isEmpty) {
                            return Container(
                              color: Colors.white,
                              child: const Center(child: Text("No result"),)
                            );
                          }
                          
                          return Container(
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                          
                                Text("Item found (${todoUcImpl.filterTodo!.length})"),
                          
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: todoUcImpl.filterTodo!.length,
                                  itemBuilder: (context, index) {
                                    return TodoItem(index: index, todo: todoUcImpl.filterTodo![index]);
                                  }
                                )
                              ],
                            ),
                          );
                          
                        }
                      ),
                    )
                    
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}

class TodoItem extends StatelessWidget {

  final int? index;

  final Todo? todo;

  final Function? checkItem;

  final Function? deleteItem;

  final Function? clickUpdate;

  const TodoItem({super.key, required this.index, required this.todo, this.deleteItem, this.checkItem, this.clickUpdate});
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        if(checkItem != null) ValueListenableBuilder(
          valueListenable: todo!.isCheck!,
          builder: (context, isCheck, wg) {
            return Checkbox(
              value: isCheck, 

              onChanged: (bool? value){
                checkItem!(value, index!);
              }
            );
          }
        ),

        Expanded(
          child: ValueListenableBuilder(
            valueListenable: todo!.title!,
            builder: (context, title, wg){

              return Text(
                title, 
                style: TextStyle(
                  decoration: (todo!.isCheck!.value) == true ? TextDecoration.lineThrough : TextDecoration.none,
                  fontSize: 20
                )
              );

            },
          ),
        ),

        ValueListenableBuilder(
          valueListenable: todo!.isEdited!, 
          builder: (context, isEdited, wg){
            if (isEdited == false) return const SizedBox();

            return const Text("Edited", style: TextStyle(color: Colors.green),);

          }
        ),

        // This ValueListenableBuilder Use For Show/Hide Whenever Item Mark Checked/Un-Check
        if (clickUpdate != null) ValueListenableBuilder(
          valueListenable: todo!.isCheck!, 
          builder: (context, isCheck, wg){

            if (isCheck == true) return const SizedBox();

            return IconButton(
              onPressed: (){
                clickUpdate!(index!);
              },
              icon: const Icon(Icons.edit)
            );

          }
        ),

        // Show Delete Btn After Click Edit On Item
        if (deleteItem != null) ValueListenableBuilder(
          valueListenable: todo!.isUpdate!, 
          builder: (context, isUpdate, wg){

            if (isUpdate == false) return const SizedBox();

            return IconButton(
              onPressed: () {
                deleteItem!(index!);
              },
              icon: const Icon(Icons.delete, color: Colors.red,)
            );

          }
        )

      ],
    );  
  }

}

