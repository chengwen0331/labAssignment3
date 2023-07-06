import 'dart:convert';
import 'dart:developer';

import 'package:barterit_application/model/item.dart';
import 'package:barterit_application/model/myconfig.dart';
import 'package:barterit_application/model/user.dart';
import 'package:barterit_application/itemdetailsscreen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

class ExploreScreen extends StatefulWidget {
  final User user;
  const ExploreScreen({super.key, required this.user});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late List<Widget> tabchildren;
  String maintitle = "Browse Trades";
  bool isSearchBarVisible = false;
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  List<Item> itemList = <Item>[];
  TextEditingController searchController = TextEditingController();
  int numofpage = 1;
  int curpage = 1;
  int numberofresult = 0;
  var color;
  List<String> itemlist = [
    "Electronics",
    "Home & Furniture",
    "Fashion & Accessories",
    "Books & Media",
    "Sports & Fitness",
    "Toys & Games",
    "Automotive",
    "Beauty & Personal Care",
    "Other",
  ];

  List<String> imageList = [
    "assets/electronic.png",
    "assets/furniture.png",
    "assets/fashion.png",
    "assets/book.png",
    "assets/sports.png",
    "assets/games.png",
    "assets/automotive.png",
    "assets/beauty.png",
    "assets/other.png"
  ];
  
  @override
    void initState() {
      super.initState();
      _loadExploreItems(1);
      print("Explore");
    }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
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
    return Scaffold(
      appBar: AppBar(
        title: Text(maintitle),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSearchBarVisible = !isSearchBarVisible;
                if (!isSearchBarVisible) {
                  searchController.text = "";
                }
              });
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: showCategory,
            icon: const Icon(Icons.filter_list),
          ),
        ],
        bottom: isSearchBarVisible
      ? PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: AnimatedOpacity(
              opacity: isSearchBarVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Visibility(
                visible: isSearchBarVisible,
                child: TextField(
                  controller: searchController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    String search = searchController.text;
                    searchItem(search);
                    searchController.text = "";
                    setState(() {
                      isSearchBarVisible = false;
                      curpage = 1; 
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(width: 0.8),
                    ),
                    hintText: "Search...",
                    prefixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isSearchBarVisible = false;
                          searchController.text = "";
                        });
                      },
                      icon: const Icon(Icons.clear),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(width: 0.8, color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(width: 0.8, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      : null,
      ),

      body: itemList.isEmpty
          ? const Center(
              child: Text("No Data", style:TextStyle(fontSize: 15)),
            )
          : Column(
              children: [
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 18.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Results",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                          setState(() {
                            curpage = 1; // Update curpage to 1
                            _loadExploreItems(1);
                          });
                        },
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: axiscount,
                    children: List.generate(
                      itemList.length,
                      (index) {
                        return Card(
                          child: InkWell(
                            onTap: () async{
                              Item useritem = Item.fromJson(itemList[index].toJson());
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (content) => ItemDetailsScreen(
                                    user: widget.user,
                                    useritem: useritem,
                                  ),
                                ),
                              );
                              _loadExploreItems(1);
                            },
                            child: Column(
                              children: [
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
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${itemList[index].itemQty} available",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: numofpage,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      //build the list for textbutton with scroll
                      if ((curpage - 1) == index) {
                        //set current page number active
                        color = Colors.red;
                        
                      } else {
                        color = Colors.black;
                      }
                      return Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2), 
                              blurRadius: 5, 
                              spreadRadius: 2, 
                              offset: const Offset(0, 2),
                            ),
                          ],
                          shape: BoxShape.circle, 
                        ),
                        child: TextButton(
                          onPressed: () {
                            curpage = index + 1;
                            _loadExploreItems(index + 1);
                          },
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(
                              color: color,
                              fontSize: 18,
                              fontWeight: FontWeight.bold 
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),     
              ]
            ),
     );
  }
  
  void _loadExploreItems(int pg) {
    /*if (widget.user.id == "na") {
      setState(() {

      });
      return;
    }*/

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Please Wait"),
          content: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
          //content: Text("Registration..."),
        );
      },
    );

    http.post(Uri.parse("${MyConfig().SERVER}/barterit_application/php/load_items.php"),
        body: {
          //"userid": widget.user.id,
          "pageno": pg.toString()
        }).then((response) {
      log(response.body);
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          numofpage = int.parse(jsondata['numofpage']);
          numberofresult = int.parse(jsondata['numberofresult']);
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
  
  void showCategory() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Material(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  top: 16.0,
                  left: 16.0,
                  bottom: 8.0,
                ),
                child: Text(
                  "Category",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    GridView.count(
                      crossAxisCount: axiscount,
                      children: List.generate(
                        imageList.length,
                        (index) {
                          return Card(
                            child: InkWell(
                              onTap: () {
                                String selectedCategory = itemlist[index];
                                searchCategory(selectedCategory);
                                Navigator.pop(context);
                                setState(() {
                                  curpage = 1; 
                                });
                              },
                              child: Column(
                                children: [
                                  Image.asset(imageList[index]),
                                  Text(
                                    itemlist[index].toString(),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: FloatingActionButton(
                        backgroundColor: Colors.amber,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.close,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

  void searchItem(search) {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit_application/php/load_items.php"),
        body: {"search": search}).then((response) {
      log(response.body);
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemList.add(Item.fromJson(v));
          });
          numofpage = int.parse(jsondata['numofpage']);
          print(itemList[0].itemName);
        }
        setState(() {});
      }
      print(response.statusCode);
    });
  }

  void searchCategory(type) {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit_application/php/load_items.php"),
        body: {"type": type}).then((response) {
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemList.add(Item.fromJson(v));
          });
          numofpage = int.parse(jsondata['numofpage']);
          print(itemList[0].itemName);
        }
        setState(() {});
      }
    });
  } 
}
