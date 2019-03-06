class Item {
  int id;
  String name;
  bool checked;

  Item(String name) {
    this.name = name;
    this.checked = false;
  }

  Item.fromJson(Map item) {
    this.id = item['id'];
    this.name = item['name'];
    this.checked = item['checked'];
  }

  Map toMap() {
    return {id: this.id, name: this.name, checked: this.checked};
  }
}
