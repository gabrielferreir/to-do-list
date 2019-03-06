import 'package:flutter/material.dart';
import 'itemModel.dart';
import 'database.dart' as database;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController _textEditingController = new TextEditingController();

  List<Item> list = [];

  addItem(String nameItem) {
    Item item = new Item(nameItem);
    database.MyDatabase.addItem(item);
    setState(() {
      this.list.add(item);
    });
  }

  void getItems() async {
    final newList = await database.MyDatabase.getItems();
    this.setState(() {
      this.list = newList;
    });
  }

  @override
  void initState() {
    this.getItems();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To do list',
      home: Scaffold(
        appBar: AppBar(title: Text('To do list')),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      controller: _textEditingController,
                      onSubmitted: (value) {
                        addItem(_textEditingController.value.text);
                        _textEditingController.clear();
                      },
                      decoration: InputDecoration(
                        hintText: 'Insira um novo item na lista',
                        border: OutlineInputBorder(),
                        suffixIcon: GestureDetector(
                          child: Icon(Icons.add),
                          onTap: () {
                            addItem(_textEditingController.value.text);
                            _textEditingController.clear();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView.builder(
                  itemCount: this.list.length,
                  itemBuilder: (BuildContext context, int index) {
                    var item = this.list[index];
                    return Dismissible(
                        key: UniqueKey(),
                        confirmDismiss: (_) {
                          setState(() {
                            this.list.removeAt(index);
                          });
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment(-0.9, 0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (direction) {},
                        direction: DismissDirection.startToEnd,
                        child: ListTile(
                          trailing: Checkbox(
                              value: item.checked == 1,
                              onChanged: (param) {
                                setState(() {
                                  item.checked = item.checked == 1 ? 0 : 1;
                                });
                              }),
                          title: Text(item.name),
                        ));
                  }),
            )
          ],
        ),
      ),
    );
  }
}
