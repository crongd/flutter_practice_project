import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/OrderDTO.dart';
import '../models/ProductDTO.dart';
import '../public/constants.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  final storage = const FlutterSecureStorage();


  List<OrderDTO> orderList = [];


  @override
  void initState() {
    super.initState();
    order_update();
  }

  void order_update() async {
    print(await storage.read(key: 'login'));
    Response respOrder = await Dio().get("http://$connectAddr:8080/get_orders?userId=${storage.read(key: 'login')}");
    // print(response);
    List<dynamic> productData = respOrder.data;
    List<OrderDTO> orders = productData.map((json) => OrderDTO.fromJson(json: json)).toList();

    setState(() {
      orderList = orders;
    });
    print(orderList);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 40,
        title: const Text("주문 목록",
        style: TextStyle(
        fontFamily: 'Jalnan',
        // fontWeight: FontWeight.bold
        fontWeight: FontWeight.w500
        ))
      ),
      body: ListView.builder(
          itemCount: orderList.length,
          itemBuilder: (context, index) {
            return orderContainer(products: orderList[index].products!);
          }),
    );
  }


  Widget orderContainer({
    required List<ProductDTO> products,
  }) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      '2024. 3. 26',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: products.map((product) {
                      return Row(
                        children: <Widget>[
                          CachedNetworkImage(
                            width: MediaQuery.of(context).size.width * 0.3,
                            fit: BoxFit.cover,
                            imageUrl: product.mainImg ?? "",
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                            errorWidget: (context, url, error) => const Center(child: Text("오류발생")),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    product.title ?? "",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text("${numberFormat.format(product.price ?? 0)}원"),
                                      Text(' ㆍ '),
                                      Text("${numberFormat.format(product.amount ?? 0)}개")
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
