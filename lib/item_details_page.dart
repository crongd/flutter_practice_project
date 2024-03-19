import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_practice_project/models/ProductDTO.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';

import 'constants.dart';

class ItemDetailsPage extends StatefulWidget {
  int no;
  String title;
  String mainImg;
  int price;

  ItemDetailsPage({super.key,
    required this.no,
    required this.title,
    required this.mainImg,
    required this.price
  });

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPage();
}

class _ItemDetailsPage extends State<ItemDetailsPage> {

  late ProductDTO productDTO;
  int no = 0;
  List<Widget> images = [];

  @override
  void initState() {
    super.initState();
    no = widget.no;
    test2();

  }

  Widget image(imageUrl) {
    return CachedNetworkImage(
      width: MediaQuery.of(context).size.width * 0.9,
      // height: MediaQuery.of(context).size.height * 0.5,
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) {
        return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            )
        );
      },
      errorWidget: (context, url, error) {
        return const Center(
          child: Text("오류 발생"),
        );
      },
    );
  }

  void test2() async {
    // print(no);
    Response response = await Dio().get('http://localhost:8080/test2?no=$no');
    dynamic responseData = response.data;
    // print(responseData);
    ProductDTO resultData = ProductDTO.fromJson(json: responseData);
    print(resultData);

    resultData.images?.forEach((img) {
      setState(() {
        images.add(image(img));
      });
    });
    print(images);

  }

   Future<void> _basket() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("가나다"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('alert dialog'),
                  Text('ok를 눌러'),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () {
                Navigator.of(context).pop();
              }, child: Text('ok')
              ),
              TextButton(onPressed: () {
                Navigator.of(context).pop();
              }, child: Text('취소')
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("제품 상세 페이지"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(15),
              child: CachedNetworkImage(
                width: MediaQuery.of(context).size.width * 0.8,
                // height: MediaQuery.of(context).size.height * 0.5,
                imageUrl: widget.mainImg,
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    )
                  );
                },
                errorWidget: (context, url, error) {
                  return const Center(
                    child: Text("오류 발생"),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                widget.title,
                textScaleFactor: 1.5,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "${numberFormat.format(widget.price)}원",
                textScaleFactor: 1.3,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: images,
              ),
            )
          ],
        )
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: FilledButton(
          onPressed: _basket,
          child: const Text("장바구니 담기"),
        ),
      ),
    );
  }

}

