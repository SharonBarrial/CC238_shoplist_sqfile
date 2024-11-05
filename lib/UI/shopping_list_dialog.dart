import 'package:flutter/material.dart';
import 'package:shoplistofficial/utils/dbhelper.dart';
import 'package:shoplistofficial/models/shopping_list.dart';

class ShoppingListDialog{
  final txtName = TextEditingController();
  final txtPriority = TextEditingController();

  Widget buildDialog(BuildContext context, ShoppingList list, bool isNew){
    DbHelper helper = DbHelper();

    if (!isNew){
      txtName.text = list.name.toString();
      txtPriority.text = list.priority.toString();
    }
    else{
      txtName.text = "";
      txtPriority.text = "";
    }

    return AlertDialog(
      title: Text((isNew)? "New shopping List" : "Edit shopping List"),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: txtName,
              decoration: InputDecoration(
                  hintText: "Shopping list Name"
              ),
            ),
            TextField(
              controller: txtPriority,
              decoration: InputDecoration(
                  hintText: "Shopping list priority (1..3)"
              ),
            ),
            ElevatedButton(
              onPressed: (){
                list.name = txtName.text;
                list.priority = int.parse(txtPriority.text);

                helper.insertList(list);
                Navigator.pop(context);
              },
              child: Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}