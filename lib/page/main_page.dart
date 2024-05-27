import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_practice_project/page/item_basket_page.dart';
import 'package:flutter_practice_project/page/item_list_page.dart';
import 'package:flutter_practice_project/public/flutter_local_notification.dart';

import '../public/constants.dart';
import 'item_details_page.dart';
import '../models/ProductDTO.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  List<ProductDTO> recentProducts = [];
  List<ProductDTO> bestSellingProducts = [];
  int _current = 0;
  final CarouselController _controller = CarouselController();
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  List imageList = [];
  String title = "LogoYogo";

  @override
  void initState() {
    super.initState();
    main_products();
  }

  void main_products() async {
    // 가장 최근 상품 조회 (limit 20)
    Response recentProduct = await Dio().get("http://$connectAddr:8080/recent_products");
    // print(respProduct);
    List<dynamic> productData = recentProduct.data;
    List<ProductDTO> products = productData.map((json) => ProductDTO.fromJson(json: json)).toList();

    // 가장 많이 팔린 상품 조회 (limit 20)
    Response bestProduct = await Dio().get("http://$connectAddr:8080/best_selling_products");
    List<dynamic> productData2 = bestProduct.data;
    List<ProductDTO> products2 = productData2.map((json) => ProductDTO.fromJson(json: json)).toList();

    Response mainImage = await Dio().get('http://$connectAddr:8080/main_image');
    List maindata = mainImage.data;
    imageList = maindata;

    setState(() {
      recentProducts = products;
      bestSellingProducts = products2;
    });
    print(recentProducts.length);
    print(bestSellingProducts.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          toolbarHeight: 40,
          title: isSearching
              ? Row( // 검색 모드일 때 검색창과 검색 버튼을 표시
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController, // 검색 컨트롤러 설정
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "검색...",
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                  style: TextStyle(color: Colors.black),
                  onSubmitted: (value) {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ItemListPage(no: 0, search: value,))
                    );
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.search, color: Colors.black),
                onPressed: () {
                  print(_searchController.text);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ItemListPage(no: 0, search: _searchController.text,))
                  );
                },
              )
            ],
          )
              : Text(title, style: TextStyle(fontFamily: 'Jalnan'),), // 기본 모드일 때 타이틀 표시
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    if (isSearching) {
                      // 검색 모드 종료 시 검색어 초기화
                      _searchController.clear();
                    }
                    isSearching = !isSearching; // 검색 모드 상태 변경
                  });
                },
                icon: Icon(isSearching ? Icons.cancel : Icons.search) // 검색 모드에 따라 아이콘 변경
            ),
            if(!isSearching) // 검색 모드가 아닐 때만 장바구니 아이콘 표시
              IconButton(onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ItemBasketPage())
                );
              }, icon: Icon(Icons.shopping_cart))
          ],
        ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // 메인 이미지
            SizedBox( 
              height: 300,
              child: Stack(
                children: [
                  sliderWidget(),
                  sliderIndicator()
                ],
              ),
            ),
            // margin
            SizedBox(
              height: 30,
            ),
            // 하위 카테고리 들?
            Container(),
            // 최신 상품 타이틀
            Container( // 최신 상품 title
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              child: Text(
                "가장 최근에 등록된 상품",
                style: TextStyle(
                  fontFamily: 'Cafe',
                  fontSize: 20,
                  // fontWeight: FontWeight.bold,
                  // letterSpacing: 0.15
                ),
                textAlign: TextAlign.left,
              ),
            ),
            // 최신 상품 ListView
            Container(
              height: 170,
              // padding: const EdgeInsets.all(8),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  //   padding: const EdgeInsets.all(8),
                  itemCount: recentProducts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return productContainer(
                        no: recentProducts[index].no ?? 0,
                        title: recentProducts[index].title ?? "",
                        mainImg: recentProducts[index].mainImg ?? "",
                        price: recentProducts[index].price ?? 0
                    );
                  }
              ),
            ),
            // margin
            SizedBox(
              height: 30,
            ),
            // 가장 많이 판매된 상품 타이틀
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              child: Text(
                "가장 많이 판매된 상품",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Cafe',
                  // fontWeight: FontWeight.bold,
                  // letterSpacing: 0.15
                ),
                textAlign: TextAlign.left,
              ),
            ),
            // 가장 많이 판매된 상품 ListView
            Container(
              height: 170,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  //   padding: const EdgeInsets.all(8),
                  itemCount: bestSellingProducts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return productContainer(
                        no: bestSellingProducts[index].no ?? 0,
                        title: bestSellingProducts[index].title ?? "",
                        mainImg: bestSellingProducts[index].mainImg ?? "",
                        price: bestSellingProducts[index].price ?? 0
                    );
                  }
              ),
            ),
            // margin
            SizedBox(
              height: 30,
            ),
            Center(
              child: TextButton(
                onPressed: () => FlutterLocalNotification.showNotification(),
                child: Text('알림 보내기'),
              ),
            )
          ],
        ),
      )
    );
  }


  Widget sliderWidget() {
    return CarouselSlider(
      carouselController: _controller,
      items: imageList.map((image) {
        return Builder(
          builder: (context) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image(
                fit: BoxFit.fill,
                image: NetworkImage(
                  image
                ),
              )
            );
          },
        );
      }
      ).toList(),
      options: CarouselOptions(
        height: 300,
        viewportFraction: 1.0,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        onPageChanged: (index, reason) {
          setState(() {
            _current = index;
          });
        }
      ),
    );
  }
  
  Widget sliderIndicator() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: imageList.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => _controller.animateToPage(entry.key),
            child: Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(_current == entry.key ? 0.9 : 0.4),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget productContainer({
    required int no,
    required String title,
    required String mainImg,
    required int price
  }) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ItemDetailsPage(no: no))
        );
      },
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: mainImg,
            height: 100,
            fit: BoxFit.fill,
            placeholder: (context, url) {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              );
            },
            errorWidget: (context, url, error) {
              return const Center(
                child: Text("오류발생"),
              );
            },
          ),
          Container(
            width: 200,
            padding: const EdgeInsets.all(8),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(3),
            child: Text("${numberFormat.format(price)}원"),
          )
        ],
      ),
    );
  }

}
