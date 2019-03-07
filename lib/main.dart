import 'package:flutter/material.dart';
import 'itemModel.dart';
import 'database.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MyDatabase database = new MyDatabase();
  TextEditingController _textEditingController = new TextEditingController();
  List<Item> list = [];

  addItem(String nameItem) async {
    Item item = new Item(nameItem);
    Item itemDatabase = await database.addItem(item);
    item.id = itemDatabase.id;
    setState(() {
      this.list.add(item);
    });
  }

  void getItems() async {
    final newList = await database.getItems();
    this.setState(() {
      this.list = newList;
    });
  }

  void updateItem(Item item) async {
    setState(() {
      item.checked = item.checked == 1 ? 0 : 1;
    });
    await database.updateItem(item);
  }

  void removeItem(Item item, int index) async {
    setState(() {
      this.list.removeAt(index);
    });
    await database.removeItem(item.id);
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
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment(-0.9, 0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (direction) {
                          removeItem(item, index);
                        },
                        direction: DismissDirection.startToEnd,
                        child: ListTile(
                          trailing: Checkbox(
                              value: item.checked == 1,
                              onChanged: (param) {
                                updateItem(item);
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
