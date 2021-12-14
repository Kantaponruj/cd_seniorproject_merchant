class Menu {
  String menuId;
  String name;
  String description;
  String price;
  String image;
  String categoryFood;
  bool haveMenu = false;

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

class Topping {
  String toppingId;
  String type;
  String selectedNumberTopping;
  String topic;
  String detail;
  List<dynamic> subTopping;

  Topping({
    this.toppingId,
    this.type,
    this.selectedNumberTopping,
    this.topic,
    this.detail,
    this.subTopping,
  });

  @override
  String toString() {
    return '{ ${this.toppingId}, ${this.type}, ${this.selectedNumberTopping}, ${this.topic}, ${this.detail}, ${this.subTopping} }';
  }

  Map<String, dynamic> toMap() {
    return {
      'toppingId': toppingId,
      'type': type,
      'selectedNumberTopping': selectedNumberTopping,
      'topic': topic,
      'detail': detail,
      'subTopping': subTopping
    };
  }

  Topping.fromMap(Map<String, dynamic> data) {
    toppingId = data['toppingId'];
    type = data['type'];
    selectedNumberTopping = data['selectedNumberTopping'];
    topic = data['topic'];
    detail = data['detail'];
    subTopping = data['subTopping'];
  }
}

// class SubTopping {
//   String subToppingId;
//   String name;
//   String price;
//   bool haveSubTopping;

//   SubTopping({this.name, this.price, this.haveSubTopping});

//   @override
//   String toString() {
//     return '{ ${this.name}, ${this.price}, ${this.haveSubTopping} }';
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'subToppingId': subToppingId,
//       'name': name,
//       'price': price,
//       'haveSubTopping': haveSubTopping
//     };
//   }
// }
