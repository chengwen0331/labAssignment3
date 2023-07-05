import 'dart:convert';

import 'package:barterit_application/edititemscreen.dart';
import 'package:barterit_application/model/item.dart';
import 'package:barterit_application/model/myconfig.dart';
import 'package:barterit_application/model/user.dart';
import 'package:barterit_application/newitemscreen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

class ItemListingScreen extends StatefulWidget {
  const ItemListingScreen({super.key, required this.user});
  final User user;

  @override
  State<ItemListingScreen> createState() => _ItemListingScreenState();
}

class _ItemListingScreenState extends State<ItemListingScreen> {
  late List<Widget> tabchildren;
  String maintitle = "Item Listing";
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  List<Item> itemList = <Item>[];
  late User user;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
    void initState() {
      super.initState();
      loadItems();
      print("Item Listing");
    }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  Future<void> _refresh() async {
    loadItems();
  }

  @override
  Widget build(BuildContext context) {
    
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: Scaffold(
        appBar: AppBar(
          title: Text(maintitle),
          backgroundColor: Colors.amber,
        ),
      body: itemList.isEmpty
          ? const Center(
              child: Text("No Data"),
            )
          : Column(children: [
              Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Container(
                  height: 24,
                  color: Color.fromARGB(255, 247, 227, 168),
                  alignment: Alignment.center,
                  child: Text(
                    "Item(s) Found: ${itemList.length}",
                    style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              Expanded(
                  child: GridView.count(
                      crossAxisCount: axiscount,
                      children: List.generate(
                        itemList.length,
                        (index) { 
                          return Card(
                            child: InkWell(
                              onLongPress: () {
                                onDeleteDialog(index);
                              },
                              onTap: () async{
                                Item singlecatch = Item.fromJson(itemList[index].toJson());
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (content) => EditItemScreen(user: widget.user,
                                    product:singlecatch,)));
                                    loadItems();
                              },
                              child: Column(children: [
                                CachedNetworkImage(
                                  width: screenWidth,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      "${MyConfig().SERVER}/barterit_application/assets/items/${itemList[index].itemId}_1.png",
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                                Text(
                                  itemList[index].itemName.toString(),
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                                Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(5),
                                    1: FlexColumnWidth(5),
                                  },
                                  children: [
                                    TableRow(children: [
                                      const TableCell(
                                        child: Text(
                                          "Quantity:",
                                          style: TextStyle(fontWeight: FontWeight.w900),
                                        ),
                                      ),
                                      TableCell(
                                        child: Text(
                                        "${itemList[index].itemQty} available",
                                    style: const TextStyle(fontSize: 14),
                                          ),
                                        )
                                      ]),
                                      TableRow(children: [
                                      const TableCell(
                                        child: Text( 
                                          "Condition:",
                                          style: TextStyle(fontWeight: FontWeight.w900),
                                        ),
                                      ),
                                      TableCell(
                                        child: Text(
                                        "${itemList[index].itemCondition}",
                                    style: const TextStyle(fontSize: 14),
                                          ),
                                        )
                                      ]),]),
                              ]),
                            ),
                          );
                        },
                      )))
                      
            ]),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.amber,
          onPressed: () async {
            if (widget.user.id != "na") {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => NewItemScreen(
                            user: widget.user,
                          )));
              loadItems();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Please login before adding new catch")));
            }
          },
          child: const Text(
            "+",
            style: TextStyle(fontSize: 32),
          )),
    ));
  }

  void loadItems() {
    if (widget.user.id == "na") {
      setState(() {
        //add scaffoldMessenger(request login)
      });
      return;
    }

    http.post(Uri.parse("${MyConfig().SERVER}/barterit_application/php/load_items.php"),
        body: {
          //"userid": widget.user.id
          }).then((response) {
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemList.add(Item.fromJson(v));
          });
          print(itemList[0].itemName);
        }
        setState(() {});
      }
    });
  }

  void onDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Delete ${itemList[index].itemName}?",
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                deleteItem(index);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void deleteItem(int index) {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit_application/php/delete_item.php"),
        body: {
          "userid": widget.user.id,
          "itemid": itemList[index].itemId
        }).then((response) {
      print(response.body);
      //itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Success")));
          loadItems();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed")));
        }
      }
    });
  }

}
