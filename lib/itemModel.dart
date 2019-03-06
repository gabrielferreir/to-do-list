class Item {
  int id;
  String name;
  int checked;

  Item(String name) {
    this.name = name;
    this.checked = 0;
  }

  Item.fromJson(Map item) {
    this.id = item['id'];
    this.name = item['name'];
    this.checked = item['checked'];
  }

  Map<String, dynamic> toMap() {
    return {"id": this.id, "name": this.name, "checked": this.checked};
  }
}
