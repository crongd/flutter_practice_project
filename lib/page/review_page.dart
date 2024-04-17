import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice_project/models/ProductDTO.dart';
import 'package:flutter_practice_project/public/constants.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> with TickerProviderStateMixin {
  TabController? _tabController;
  final _contentController = TextEditingController();

  List<ProductDTO> writeableReview = [];
  List<ProductDTO> writtenReview = [];

  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    get_order_product();
  }

  void get_order_product() async {
    Response response = await Dio().get('http://$connectAddr:8080/order_products?userId=${await storage.read(key: 'login')}');
    List<dynamic> respData = response.data;
    List<ProductDTO> products = respData.map((json) => ProductDTO.fromJson(json: json)).toList();

    setState(() {
      writeableReview = products;
    });
    print(products);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("리뷰 관리", style: TextStyle(fontSize: 20, fontFamily: 'Jalnan'),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: TabBar(
                tabs: [
                  Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text("작성 가능 리뷰", style: TextStyle(fontSize: 16, fontFamily: 'Cafe'),),
                  ),
                  Container(
                    height: 30,
                    alignment: Alignment.center,
                    child: Text("작성한 리뷰", style: TextStyle(fontSize: 16, fontFamily: 'Cafe'),),
                  )
                ],
              indicatorColor: Colors.grey,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black,
              controller: _tabController,
            )
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Container(
                  // color: Colors.yellow[200],
                  alignment: Alignment.center,
                  child: ListView.builder(
                    itemCount: writeableReview.length,
                    itemBuilder: (context, index) {
                      return write_review(
                          orderProductNo: writeableReview[index].orderProductNo,
                          productNo: writeableReview[index].no,
                          mainImg: writeableReview[index].mainImg,
                          title: writeableReview[index].title,
                          price: writeableReview[index].price,
                          amount: writeableReview[index].amount
                      );
                    }
                  ),
                ),
                Container(
                  // color: Colors.yellow[200],
                  alignment: Alignment.center,
                  child: Text('tab2 view', style: TextStyle(fontSize: 30),),
                )
              ],
            )
          )
        ],
      ),
    );
  }

  // 작성 가능 리뷰
  Widget write_review({
    required orderProductNo,
    required productNo,
    required mainImg,
    required title,
    required price,
    required amount
  }) {
    return Container(
      // decoration: BoxDecoration(
      //   border: Border.all(),
      // ),
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                CachedNetworkImage(
                  width: MediaQuery.of(context).size.width * 0.3,
                  fit: BoxFit.cover,
                  imageUrl: mainImg,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  errorWidget: (context, url, error) => const Center(child: Text("오류발생")),
                ),
                Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, overflow: TextOverflow.ellipsis,),
                          Text('${numberFormat.format(price)} 원 . ${amount}개'),
                          TextButton(
                            onPressed: () {
                              print("productNo 들고 리뷰 페이지 이동");
                              bottom_sheet();
                            },
                            child: Text('리뷰 작성하기', style: TextStyle(fontSize: 16, fontFamily: 'Cafe', color: Colors.black))
                          ),
                        ],
                      ),
                    )
                ),
                SizedBox(height: 10,),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //작성한 리뷰
  Widget writed_review() {
    return Container();
  }

  Future bottom_sheet() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
              height: 500, // 모달 높이
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                // padding: EdgeInsets.only(
                //   bottom: MediaQuery.of(context).viewInsets.bottom,
                // ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      // direction: Axis.horizontal,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber,),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                    TextField(
                      maxLines: null, // 무제한 줄 입력 허용
                      // keyboardType: TextInputType.multiline, // 멀티라인 입력 키보드 타입
                      decoration: InputDecoration(
                        hintText: "여기에 글 작성",
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: double.infinity,
                      color: Colors.orange,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextButton(onPressed: () {}, child: Text('전송', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),)),
                      ),
                    )

                  ],
                ),
              )
          );
        }
    );
   }
}
