import 'dart:convert';
import 'dart:io';


import 'package:barterit_application/model/item.dart';
import 'package:barterit_application/model/myconfig.dart';
import 'package:barterit_application/model/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class EditItemScreen extends StatefulWidget {
  final Item product;
  final User user;
  const EditItemScreen({super.key, required this.user, required this.product});


  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {

  late double screenHeight, screenWidth, resWidth;
  List<Item> itemList = <Item>[];
  var pathAsset = "assets/camera.png";
  final _formKey = GlobalKey<FormState>();
  bool editForm = false;
  final TextEditingController _itemnameEditingController = TextEditingController();
  final TextEditingController _itemdescEditingController = TextEditingController();
  final TextEditingController _itemqtyEditingController = TextEditingController();
  final TextEditingController _itemconEditingController = TextEditingController();
  final TextEditingController _itemtradeEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _itemnameEditingController.text = widget.product.itemName.toString();
    _itemdescEditingController.text = widget.product.itemDesc.toString();
    _itemqtyEditingController.text = widget.product.itemQty.toString();
    _itemconEditingController.text = widget.product.itemCondition.toString();
    _itemtradeEditingController.text = widget.product.itemPrefer.toString();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Update Item'),
          backgroundColor: Colors.amber,
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_back,
              color: Colors.white,
              ),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),]
        ),
        body: Column(children: [
          Flexible(
            flex: 4,
            child: SizedBox(
              width: screenWidth,              
                  child: CachedNetworkImage(
                    width: screenWidth,
                    fit: BoxFit.fill,
                    imageUrl:
                        "${MyConfig().SERVER}/barterit_application/assets/items/${widget.product.itemId}_1.png",
                    placeholder: (context, url) =>
                        const LinearProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),                  
                ),              
            )),
            Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                          width: 16,
                        ),
                        TextFormField(
                       textInputAction: TextInputAction.next,
                       validator: (val) =>
                       val!.isEmpty || (val.length < 3)
                         ? "Item name must be longer than 3"
                          : null,
                       onFieldSubmitted: (v) {},
                        controller: _itemnameEditingController,
                       keyboardType: TextInputType.text,
                       decoration: const InputDecoration(
                       labelText: 'Item Name',
                       labelStyle: TextStyle(),
                       icon: Icon(Icons.abc),
                       focusedBorder: OutlineInputBorder(
                       borderSide: BorderSide(width: 2.0),))),
                    TextFormField(
                       textInputAction: TextInputAction.next,
                       validator: (val) => val!.isEmpty || (val.length < 3)
                           ? "Item description must be longer than 3"
                          : null,
                       onFieldSubmitted: (v) {},
                        maxLines: 4,
                       controller: _itemdescEditingController,
                       keyboardType: TextInputType.text,
                       decoration: const InputDecoration(
                       labelText: 'Item Description',
                       alignLabelWithHint: true,
                       labelStyle: TextStyle(),
                       icon: Icon(
                              Icons.description,
                            ),
                         focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2.0),))
                    ),
                    TextFormField(
                       textInputAction: TextInputAction.next,
                       validator: (val) => val!.isEmpty
                            ? "Quantity should be more than 0"
                                 : null,
                          onFieldSubmitted: (v) {},
                          controller: _itemqtyEditingController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                          labelText: 'Product Quantity',
                          labelStyle: TextStyle(),
                          icon: Icon(Icons.ad_units,),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                                 ))
                    ),
                    TextFormField(
                       textInputAction: TextInputAction.next,
                       validator: (val) =>
                                  val!.isEmpty || (val.length < 3)
                                      ? "Item condition must be longer than 3"
                                      : null,
                              onFieldSubmitted: (v) {}, //?
                              controller: _itemconEditingController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText: 'Item Condition',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.question_mark_rounded),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))
                    ),
                    TextFormField(
                       textInputAction: TextInputAction.next,
                       validator: (val) =>
                                  val!.isEmpty || (val.length < 3)
                                      ? "Item Name must be longer than 3"
                                      : null,
                              onFieldSubmitted: (v) {}, 
                              controller: _itemtradeEditingController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText: 'Preferred Item',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.abc),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          minWidth: screenWidth / 2,
                          height: 50,
                          elevation: 10,
                          onPressed: _updateItemDialog,
                          color: Colors.amber,
                          textColor: Theme.of(context).colorScheme.onError,
                          child: const Text(
                            'Update',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),        
                    const SizedBox(
                            height: 15,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        ]
        ),
      ),
    );
  }

  void _updateItemDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Update this item",
            style: TextStyle(),
 ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _updateItem();
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
  
  void _updateItem() {
    String itemname = _itemnameEditingController.text;
    String itemdesc = _itemdescEditingController.text;
    String itemqty = _itemqtyEditingController.text;
    String itemcon = _itemconEditingController.text;
    String itemtrade = _itemtradeEditingController.text;

    http.post(Uri.parse("${MyConfig().SERVER}/barterit_application/php/update_item.php"),
          body: {
            "itemid": widget.product.itemId,
            "itemname": itemname,
            "itemdesc": itemdesc,
            "itemqty": itemqty,
            "itemcon": itemcon,
            "itemtrade": itemtrade,
          }).then((response) {
        print(response.body);
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Success")));
              Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Failed")));
        }
        
      });
    
  }
  
}