import 'package:flutter/material.dart';
import 'package:hive_demo/Model/DataModel.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String dataBoxName = "data1";

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  late Box<DataModel> dataBox;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataBox = Hive.box<DataModel>(dataBoxName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            ValueListenableBuilder(
              valueListenable: dataBox.listenable(),
              builder: (context, Box<DataModel> items, _) {
                List<int> keys;

                keys = items.keys.cast<int>().toList();

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

                        // trailing: SizedBox(
                        //   width: 150,
                        //   height: 20,
                        //   child: Row(
                        //     children: <Widget>[
                        //       IconButton(
                        //         icon: const Icon(Icons.remove),
                        //         onPressed: () => setState(() => _itemCount--),
                        //       ),
                        //       Text(data.qty.toString()),
                        //       IconButton(
                        //           icon: const Icon(Icons.add),
                        //           onPressed: () => setState(() => _itemCount++))
                        //     ],
                        //   ),
                        // ),

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
    );
  }
}
