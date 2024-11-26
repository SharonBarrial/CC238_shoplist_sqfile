import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoplistofficial/utils/dbhelper.dart';
import 'package:shoplistofficial/models/list_items.dart';

class ListItemDialog{
  //Todos los campos necesarios
  final txtName = TextEditingController();
  final txtQuantity = TextEditingController();
  final txtNote = TextEditingController();

  Widget buildDialog(BuildContext context, ListItems item, bool isNew){
    DbHelper helper = DbHelper();

    if (!isNew){
      txtName.text = item.name.toString();
      txtQuantity.text = item.quantity.toString();
      txtNote.text = item.note.toString();
    }
    else{
      txtName.text = "";
      txtQuantity.text = "";
      txtNote.text = "";
      /**txtName.clear();
      txtQuantity.clear();
      txtNote.clear();**/
    }

    return AlertDialog(
      title: Text((isNew)? "New item List" : "Edit item List"),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: txtName,
              decoration: InputDecoration(
                  hintText: "Shopping item Name"
              ),
            ),
            TextField(
              controller: txtQuantity,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                  hintText: "Shopping item quantity"
              ),
            ),
            TextField(
              controller: txtNote,
              decoration: InputDecoration(
                  hintText: "Shopping item note"
              ),
            ),
            ElevatedButton(
              onPressed: (){
                item.name = txtName.text;
                item.quantity = txtQuantity.text;
                item.note = txtNote.text;

                helper.insertItem(item);
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