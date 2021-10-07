class Menu {
  String menuId;
  String name;
  String description;
  String price;
  String image;
  String categoryFood;
  bool haveMenu;

  Menu();

  Map<String, dynamic> toMap() {
    return {
      'menuId': menuId,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'categoryFood': categoryFood,
      'haveMenu': haveMenu
    };
  }

  Menu.fromMap(Map<String, dynamic> data) {
    menuId = data['menuId'];
    name = data['name'];
    description = data['description'];
    price = data['price'];
    image = data['image'];
    categoryFood = data['categoryFood'];
    haveMenu = data['haveMenu'];
  }
}
