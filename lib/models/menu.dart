class Menu {
  String menuId;
  String name;
  String description;
  int price;
  String image;

  Menu();

  Menu.fromMap(Map<String, dynamic> data) {
    menuId = data['menuId'];
    name = data['name'];
    description = data['description'];
    price = data['price'];
    image = data['image'];
  }
}
