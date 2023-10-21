import 'package:flutter/material.dart';

class DialogCustom {

  Future<dynamic> deleteItem(BuildContext context, String item) async {
    return await showDialog(
      context: context, 
      builder: (context){
        
        return AlertDialog(
          title: Text("Wanna delete $item"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: const Text("CANCEL")
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true), 
              child: const Text("DELETE")
            )
          ],
        );
      }
    );
  }
}