
import 'package:barterit_application/model/item.dart';
import 'package:barterit_application/model/myconfig.dart';
import 'package:barterit_application/model/user.dart';
//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Item useritem;
  final User user;
  const ItemDetailsScreen(
      {super.key, required this.useritem, required this.user});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  final df = DateFormat('dd-MM-yyyy hh:mm a');
  late double screenHeight, screenWidth, cardwitdh;
  final CarouselController carouselController = CarouselController();
  int currenIndex = 0;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    List<String?> selectedImages = [
      "${MyConfig().SERVER}/barterit_application/assets/items/${widget.useritem.itemId}_1.png",
      "${MyConfig().SERVER}/barterit_application/assets/items/${widget.useritem.itemId}_2.png",
      "${MyConfig().SERVER}/barterit_application/assets/items/${widget.useritem.itemId}_3.png",
    ];
    var pathAsset = "assets/camera.png";
    List<String> pathAssets = [
      "assets/camera.png",
      "assets/camera.png",
      "assets/camera.png",
    ];
    return Scaffold(
      appBar: AppBar(title: const Text("Item Details"),
      backgroundColor: Colors.amber,
      actions: [
        IconButton(
          onPressed: () {
            // wishlist function
          },
          icon: const Icon(
            Icons.favorite,
            color: Colors.red,
          ),
        ),
        IconButton(
          onPressed: () {
            // Handle messenger action
          },
          icon: const Icon(Icons.chat, color: Colors.black,),
        ),  
      ],),
      body: Column(children: [
          Flexible(
            //flex: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                child: ListView(
                  shrinkWrap: true,
                  //physics: NeverScrollableScrollPhysics(),
                children: [
                  Stack(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          scrollPhysics: const BouncingScrollPhysics(),
                          autoPlay: true,
                          viewportFraction: 1.0,
                          onPageChanged: (index, reason) {
                            setState(() {
                              currenIndex = index;
                            });
                          },
                        ),
                        carouselController: carouselController,
                        items: [
                          for (var i = 0; i < selectedImages.length; i++)
                            
                              SizedBox(
                                width: double.infinity,
                              child: AspectRatio(
                                aspectRatio: screenWidth / screenHeight,
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: selectedImages[i] != null
                                        ? NetworkImage(selectedImages[i]!) as ImageProvider<Object>
                                        : AssetImage(pathAssets[i]) as ImageProvider<Object>,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),)
                            
                        ],
                      ),
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: selectedImages.asMap().entries.map((entry) {
                            return GestureDetector(
                              onTap: () => carouselController.animateToPage(entry.key),
                              child: Container(
                                width: currenIndex == entry.key ? 17 : 7,
                                height: 7.0,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 3.0,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: currenIndex == entry.key
                                      ? Colors.red
                                      : Colors.teal,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ],              
            ),
          )
        ),
        Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              widget.useritem.itemName.toString(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )),
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(5),
                1: FlexColumnWidth(5),
              },
              children: [
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Description",
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      widget.useritem.itemDesc.toString(),
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Item Category",
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      widget.useritem.itemType.toString(),
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Quantity",
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      widget.useritem.itemQty.toString(),
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Original Price",
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      "RM ${double.parse(widget.useritem.itemPrice.toString()).toStringAsFixed(2)}",
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Item Condition",
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      widget.useritem.itemCondition.toString(),
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Preferred Item",
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      widget.useritem.itemPrefer.toString(),
                    ),
                  )
                ]),
                TableRow(children: [
                  const TableCell(
                    child: Text(
                      "Location",
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                  TableCell(
                    child: Text(
                      "${widget.useritem.itemLocality}/${widget.useritem.itemState}",
                    ),
                  )
                ]),
              ],
            ),
          ),
        )
      ]),
    );
  }
}