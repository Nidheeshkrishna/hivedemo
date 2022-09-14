import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:hive_demo/Model/DataModel.dart';
import 'package:hive_demo/Model/ItemModel.dart';
import 'package:hive_demo/ProductList.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String dataBoxName = "data1";

class CartScreen extends StatefulWidget {
  const CartScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<bool> tapped = [];
  Box<DataModel>? dataBox;
  @override
  void initState() {
    super.initState();
    dataBox = Hive.box<DataModel>(dataBoxName);
  }

  List products = [
    Item(
        Id: '1',
        name: 'Apple',
        unit: 'Kg',
        price: 20,
        image:
            'https://raw.githubusercontent.com/timelessfusionapps/shopping_cart_app/main/assets/images/apple.png'),
    Item(
        Id: '2',
        name: 'Mango',
        unit: 'Doz',
        price: 30,
        image:
            'https://raw.githubusercontent.com/timelessfusionapps/shopping_cart_app/main/assets/images/mango.png'),
    Item(
        Id: '3',
        name: 'Banana',
        unit: 'Doz',
        price: 10,
        image:
            'https://raw.githubusercontent.com/timelessfusionapps/shopping_cart_app/main/assets/images/banana.png'),
    Item(
        Id: '4',
        name: 'Grapes',
        unit: 'Kg',
        price: 8,
        image:
            'https://raw.githubusercontent.com/timelessfusionapps/shopping_cart_app/main/assets/images/grapes.png'),
    Item(
        Id: '5',
        name: 'Water Melon',
        unit: 'Kg',
        price: 25,
        image:
            'https://raw.githubusercontent.com/timelessfusionapps/shopping_cart_app/main/assets/images/watermelon.png'),
    Item(
        Id: '6',
        name: 'Kiwi',
        unit: 'Pc',
        price: 40,
        image:
            'https://raw.githubusercontent.com/timelessfusionapps/shopping_cart_app/main/assets/images/kiwi.png'),
    Item(
        Id: '7',
        name: 'Orange',
        unit: 'Doz',
        price: 15,
        image:
            'https://raw.githubusercontent.com/timelessfusionapps/shopping_cart_app/main/assets/images/orange.png'),
    Item(
        Id: '8',
        name: 'Peach',
        unit: 'Pc',
        price: 8,
        image:
            'https://raw.githubusercontent.com/timelessfusionapps/shopping_cart_app/main/assets/images/peach.png'),
    Item(
        Id: '9',
        name: 'Strawberry',
        unit: 'Box',
        price: 12,
        image:
            'https://raw.githubusercontent.com/timelessfusionapps/shopping_cart_app/main/assets/images/strawberry.png'),
  ];

  @override
  Widget build(BuildContext context) {
    double srcwidth = MediaQuery.of(context).size.width;
    double srcHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: const Text("Flutter Hive Demo"),
        actions: <Widget>[
          ValueListenableBuilder(
              valueListenable: dataBox!.listenable(),
              builder: (context, Box<DataModel> items, _) {
                return Badge(
                    position: BadgePosition.topEnd(top: 10, end: 10),
                    badgeContent: Text(
                      items.length.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    child: IconButton(
                        icon: const Icon(Icons.shopping_cart),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProductList()),
                          );
                        }));
              }),
        ],
      ),
      body: Column(children: [
        Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.blueGrey.shade200,
                    elevation: 5.0,
                    child: SizedBox(
                      width: srcwidth,
                      height: srcHeight * .20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Image(
                              height: 80,
                              width: 80,
                              image: NetworkImage(products[index].image),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              width: srcwidth * .30,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    text: TextSpan(
                                        text: 'Name: ',
                                        style: TextStyle(
                                            color: Colors.blueGrey.shade800,
                                            fontSize: 16.0),
                                        children: [
                                          TextSpan(
                                              text: '${products[index].name}\n',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ]),
                                  ),
                                  RichText(
                                    maxLines: 1,
                                    text: TextSpan(
                                        text: 'Unit: ',
                                        style: TextStyle(
                                            color: Colors.blueGrey.shade800,
                                            fontSize: 16.0),
                                        children: [
                                          TextSpan(
                                              text: '${products[index].unit}\n',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ]),
                                  ),
                                  RichText(
                                    maxLines: 1,
                                    text: TextSpan(
                                        text: 'Price: ' r"$",
                                        style: TextStyle(
                                            color: Colors.blueGrey.shade800,
                                            fontSize: 16.0),
                                        children: [
                                          TextSpan(
                                              text:
                                                  '${products[index].price}\n',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ]),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            removefromcart(products[index].Id);
                                          },
                                          icon: const Icon(Icons.remove)),
                                      Text(products[index].Id),
                                      IconButton(
                                          onPressed: () {
                                            addtocart(
                                                products[index].Id, index);
                                          },
                                          icon: const Icon(Icons.add)),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                })),
      ]),
      bottomNavigationBar: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Payment Successful'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        child: Container(
          color: Colors.yellow.shade600,
          alignment: Alignment.center,
          height: 50.0,
          child: const Text(
            'Proceed to Pay',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  deleteItem(int id) {
    final Map<dynamic, DataModel> deliveriesMap = dataBox!.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.qty == id) desiredKey = key;
    });
    dataBox!.delete(desiredKey);
  }

  addtocart(String id, int index) {
    if (dataBox!.isEmpty) {
      adddata(id, index);
    } else {
      if (dataBox!.isNotEmpty) {}
      updatecart(id, index);
    }
  }

  updatecart(String id, int index) {
    final Map<dynamic, DataModel> deliveriesMap = dataBox!.toMap();
    DataModel? datanew;
    dynamic desiredKey;

    deliveriesMap.forEach((key, value) {
      if (value.id == id) {
        desiredKey = key;

        datanew = DataModel(
            title: value.title,
            description: value.description,
            complete: false,
            qty: value.qty + 1,
            id: id.toString());
        dataBox!.putAt(desiredKey, datanew!);
      }
    });
  }

  adddata(String id, int index) {
    DataModel? datanew;
    datanew = DataModel(
        title: products[index].name,
        description: products[index].name,
        complete: false,
        qty: 1,
        id: id.toString());
    dataBox!.add(datanew);
  }

  removefromcart(String id) {
    DataModel? data;
    final Map<dynamic, DataModel> deliveriesMap = dataBox!.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.id == id) {
        desiredKey = key;
        if (value.qty == 0) {
          dataBox!.deleteAt(desiredKey);
        } else {
          data = DataModel(
              title: "",
              description: "",
              complete: false,
              qty: value.qty - 1,
              id: id);
          dataBox!.putAt(desiredKey, data!);
        }
      }
    });
  }

  String getCount(id) {
    final Map<dynamic, DataModel> deliveriesMap = dataBox!.toMap();
    dynamic desiredKey;
    String qty = "";
    deliveriesMap.forEach((key, value) {
      if (value.qty == id) {
        desiredKey = key;
        qty = dataBox!.getAt(desiredKey)!.qty.toString();
      }
    });
    return qty;
  }
}

class PlusMinusButtons extends StatelessWidget {
  final VoidCallback deleteQuantity;
  final VoidCallback addQuantity;
  final String text;
  const PlusMinusButtons(
      {Key? key,
      required this.addQuantity,
      required this.deleteQuantity,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: deleteQuantity, icon: const Icon(Icons.remove)),
        Text(text),
        IconButton(onPressed: addQuantity, icon: const Icon(Icons.add)),
      ],
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget({Key? key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ],
      ),
    );
  }
}
