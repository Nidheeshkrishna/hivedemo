import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:hive_demo/Model/DataModel.dart';
import 'package:hive_demo/Model/ItemModel.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'CartPage.dart';

const String dataBoxName = "data1";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(DataModelAdapter());
  await Hive.openBox<DataModel>(dataBoxName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CartScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum DataFilter { ALL, COMPLETED, PROGRESS }

class _MyHomePageState extends State<HomePage> {
  late Box<DataModel> dataBox;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DataFilter filter = DataFilter.ALL;

  var _itemCount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataBox = Hive.box<DataModel>(dataBoxName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: const Text("Flutter Hive Demo"),
        actions: <Widget>[
          ValueListenableBuilder(
              valueListenable: dataBox.listenable(),
              builder: (context, Box<DataModel> items, _) {
                return Badge(
                    position: BadgePosition.topEnd(top: 10, end: 10),
                    badgeContent: Text(
                      items.length.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    child: IconButton(
                        icon: const Icon(Icons.shopping_cart),
                        onPressed: () {}));
              }),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value.compareTo("All") == 0) {
                setState(() {
                  filter = DataFilter.ALL;
                });
              } else if (value.compareTo("Compeleted") == 0) {
                setState(() {
                  filter = DataFilter.COMPLETED;
                });
              } else {
                setState(() {
                  filter = DataFilter.PROGRESS;
                });
              }
            },
            itemBuilder: (BuildContext context) {
              return ["All", "Compeleted", "Progress"].map((option) {
                return PopupMenuItem(
                  value: option,
                  child: Text(option),
                );
              }).toList();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ValueListenableBuilder(
              valueListenable: dataBox.listenable(),
              builder: (context, Box<DataModel> items, _) {
                List<int> keys;

                if (filter == DataFilter.ALL) {
                  keys = items.keys.cast<int>().toList();
                } else if (filter == DataFilter.COMPLETED) {
                  keys = items.keys
                      .cast<int>()
                      .where((key) => items.get(key)!.complete)
                      .toList();
                } else {
                  keys = items.keys
                      .cast<int>()
                      .where((key) => !items.get(key)!.complete)
                      .toList();
                }

                return ListView.separated(
                  separatorBuilder: (_, index) => const Divider(),
                  itemCount: keys.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index) {
                    final int key = keys[index];
                    final DataModel? data = items.get(key);
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.blueGrey[200],
                      child: ListTile(
                        title: Text(
                          data!.title,
                          style: const TextStyle(
                              fontSize: 22, color: Colors.black),
                        ),
                        subtitle: Text(data.description,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.black38)),
                        leading: Text(
                          "$key",
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black),
                        ),

                        trailing: SizedBox(
                          width: 150,
                          height: 20,
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () => setState(() => _itemCount--),
                              ),
                              Text(data.qty.toString()),
                              IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () => setState(() => _itemCount++))
                            ],
                          ),
                        ),

                        // trailing: Icon(
                        //   Icons.check,
                        //   color: data.complete
                        //       ? Colors.deepPurpleAccent
                        //       : Colors.red,
                        // ),
                        onTap: () {
                          // showDialog(
                          //   context: context,
                          //   builder: (BuildContext context) {
                          //     return Dialog(
                          //         backgroundColor: Colors.white,
                          //         child: Container(
                          //           padding: const EdgeInsets.all(16),
                          //           child: Column(
                          //             mainAxisSize: MainAxisSize.min,
                          //             children: <Widget>[
                          //               FlatButton(
                          //                 shape: RoundedRectangleBorder(
                          //                   borderRadius:
                          //                       BorderRadius.circular(10.0),
                          //                 ),
                          //                 color: Colors.blueAccent[100],
                          //                 child: const Text(
                          //                   "Mark as complete",
                          //                   style: TextStyle(
                          //                       color: Colors.black87),
                          //                 ),
                          //                 onPressed: () {
                          //                   DataModel mData = DataModel(
                          //                       title: data.title,
                          //                       description: data.description,
                          //                       complete: true);
                          //                   dataBox.put(key, mData);
                          //                   Navigator.pop(context);
                          //                 },
                          //               )
                          //             ],
                          //           ),
                          //         ));
                          //   },
                          // );
                        },
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                  backgroundColor: Colors.blueGrey[100],
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          decoration: const InputDecoration(hintText: "Title"),
                          controller: titleController,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextField(
                          decoration:
                              const InputDecoration(hintText: "Description"),
                          controller: descriptionController,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Colors.red,
                          child: const Text(
                            "Add Data",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            final String title = titleController.text;
                            final String description =
                                descriptionController.text;
                            titleController.clear();
                            descriptionController.clear();
                            DataModel data = DataModel(
                                title: title,
                                description: description,
                                complete: false,
                                qty: 0,
                                id: '');
                            dataBox.add(data);
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  ));
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
