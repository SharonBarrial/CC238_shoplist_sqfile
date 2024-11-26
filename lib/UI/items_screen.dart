import 'package:flutter/material.dart';
import 'package:shoplistofficial/utils/dbhelper.dart';
import 'package:shoplistofficial/models/shopping_list.dart';
import 'package:shoplistofficial/models/list_items.dart';
import 'package:shoplistofficial/UI/shopping_list_dialog.dart';
import 'package:shoplistofficial/UI/list_item_dialog.dart';

class ItemsScreen extends StatefulWidget {
  //Al hacer clic solo se va a hacer el cambio a ese elemento
  final ShoppingList shoppingList;
  ItemsScreen(this.shoppingList);

  @override
  State<ItemsScreen> createState() => _ItemsScreenState(this.shoppingList);
}

class _ItemsScreenState extends State<ItemsScreen> {
  final ShoppingList shoppingList;
  _ItemsScreenState(this.shoppingList);

  DbHelper? helper;
  List<ListItems> items = [];

  @override
  Widget build(BuildContext context) {
    ListItemDialog dialog = ListItemDialog();

    helper = DbHelper();
    //showData(shoppingList.id!);
    showData(this.shoppingList.id!);
    return Scaffold(
      appBar:AppBar(
        title: Text(shoppingList.name.toString()),
      ) ,
      body: ListView.builder(
        //Si items es diferente de null, entonces items.length, de lo contrario 0, es decir no muetsra nada
        itemCount: (items != null)? items.length : 0,
        itemBuilder: (BuildContext context, int index){
          return Dismissible(
            key: Key(items[index].name!),
            onDismissed: (direction){
              String strName = items[index].name.toString();
              helper!.deleteItem(items[index]);
              setState(() {
                items.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Item $strName deleted")));
            },
            background: Container(color: Colors.red),
          child: ListTile(
            title: Text(items[index].name.toString()),
            subtitle: Text("Quantity: ${items[index].quantity} | Note: ${items[index].note}"),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              //Al hacer clic se va a abrir el dialogo
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context) => dialog.buildDialog(context, items[index], false),
                );
              },
            ),
          ),
          );
        }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          showDialog(
            context: context,
            builder: (BuildContext context) => dialog.buildDialog(context, ListItems(0, shoppingList.id!, "", "", ""), true),
          );
        },
      ),
    );
  }

  Future showData(int idList) async{
    await helper!.openDb();
    items = await helper!.getItems(idList);

    setState(() {
      items = items;
    });
  }
}
