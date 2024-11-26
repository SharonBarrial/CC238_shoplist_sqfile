import 'package:flutter/material.dart';
import 'package:shoplistofficial/utils/dbhelper.dart';
import 'package:shoplistofficial/models/shopping_list.dart';
import 'package:shoplistofficial/models/list_items.dart';
import 'package:shoplistofficial/UI/shopping_list_dialog.dart';
import 'package:shoplistofficial/UI/items_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //helper.testDB();

    return MaterialApp(
        home: ShowList(),
        debugShowCheckedModeBanner: false,
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
            return Dismissible(
                key: Key(shoppingList[index].name.toString()),
                onDismissed: (direction){
                  //capturar el nombre de lo que está borrando
                  String strName = shoppingList[index].name.toString();
                  //borrar el item de la lista
                  helper.deleteList(shoppingList[index]);
                  setState(() {
                    shoppingList.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("The list $strName was deleted!")));
                },
              child: ListTile(
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
                //item de la lista
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)
                      => ItemsScreen(shoppingList[index])));
                      },
              ),
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
