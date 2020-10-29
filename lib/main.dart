import 'package:flutter/material.dart';
import 'package:to_do_list/database/todolist_item.dart';
import 'database/db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DB.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDoList',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(100,100,100, 1.0),
        accentColor: Color.fromRGBO(255, 150, 66,1.0)
      ),
      home: MyHomePage(title: 'TODOLIST'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ToDoItem> _todolist= [];
  String _name;

  var text;
  List<Widget> get _item => _todolist.map((item) => format(item)).toList();

  Widget format(ToDoItem item)
  {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Dismissible(
        key: Key(item.id.toString()),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).accentColor,
            shape: BoxShape.rectangle,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black,
                blurRadius: 5,
                offset: Offset(0.0,5)
              )
            ]
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(item.name,
                  style: TextStyle(color: Colors.black,
                      fontSize: 16),
                ),
              ),

            ],



          )
        ),
        onDismissed: (DismissDirection d){
          DB.delete(ToDoItem.table, item);
          refresh();
        },

      ),

    );
  }

  void _create(BuildContext context)
  {
    showDialog(
        context: context,
      builder: (BuildContext context){
          return AlertDialog(
            backgroundColor: Theme.of(context).accentColor,
            title: Text('ADD TASK',
              style: TextStyle(color: Theme.of(context).primaryColor,),
            ),
            content: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'item name'
                    ),
                    onChanged: (name){
                      _name = name;
                    },
                  )
                ],
              ),
            ),
            actions: [
              FlatButton(
                color: Theme.of(context).accentColor,
                onPressed: () => _save(),
                child: Text('save',
                style: TextStyle(color: Theme.of(context).primaryColor,),
              )
              )
            ],
          );
      }

    );

  }

  void _save() async{
    Navigator.of(context).pop();
    ToDoItem item = ToDoItem(
      name: _name
    );
    await DB.insert(ToDoItem.table, item);
    setState(() {
    });
    refresh();

}

  void initState()
  {
    refresh();
    super.initState();
  }

  void refresh() async{
    List<Map<String,dynamic>> _results = await DB.query(ToDoItem.table);
    _todolist = _results.map((item) => ToDoItem.fromMap(item)).toList();
    setState(() => _name = '');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        child: ListView(
          children: <Widget> [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
              child: Text("Keep track of stuff.",
                style: TextStyle(color: Theme.of(context).accentColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ) ,),
            ),
            ListView(
              children: _item,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            )

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(context),
        tooltip: 'Add new task',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
