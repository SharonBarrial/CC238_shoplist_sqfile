import 'package:flutter/material.dart';
import 'package:shoplistofficial/utils/dbhelper.dart';
import 'package:shoplistofficial/models/shopping_list.dart';
import 'package:shoplistofficial/models/list_items.dart';
import 'package:shoplistofficial/UI/shopping_list_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //helper.testDB();

    return MaterialApp(
        home: ShowList()
    );
  }
}

class ShowList extends StatefulWidget {
  const ShowList({super.key});

  @override
  State<ShowList> createState() => _ShowListState();
}

class _ShowListState extends State<ShowList> {
  DbHelper helper = DbHelper();
  List<ShoppingList> shoppingList=[]; //List<ShoppingList> shoppingList=[];

  ShoppingListDialog? dialog;
  @override
  void initState(){
    dialog = ShoppingListDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showData();
    return Scaffold(
      appBar: AppBar(
        title: Text ("My shopping List - wx61!"),
      ),
      body: ListView.builder(
          itemCount: (shoppingList != null)? shoppingList.length : 0,
          itemBuilder: (BuildContext context, int index){
            return ListTile(
              title: Text(shoppingList[index].name.toString()
              ),
              leading: CircleAvatar(
                child: Text(shoppingList[index].priority.toString()),
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: (){
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          dialog!.buildDialog(context, shoppingList[index], false));
                },
              ),
              onTap: (){

              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: ()
        {
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                dialog!.buildDialog(context, ShoppingList(0, '', 0), true),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.amberAccent,
      ),
    );
  }

  Future showData() async{
    await helper.openDb();
    shoppingList = await helper.getLists();

    setState(() {
      shoppingList = shoppingList;
    });
  }
}
