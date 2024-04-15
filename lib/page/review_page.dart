import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice_project/models/ProductDTO.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> with TickerProviderStateMixin {
  TabController? _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
                  color: Colors.yellow[200],
                  alignment: Alignment.center,
                  child: write_review(),
                ),
                Container(
                  color: Colors.yellow[200],
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


  Widget write_review(
    // required ProductDTO product
) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
      ),
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
                  imageUrl: "https://cdn.hkbs.co.kr/news/photo/202104/628798_374207_2710.png",
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  errorWidget: (context, url, error) => const Center(child: Text("오류발생")),
                ),
                Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('제목qwdqdwqqwwqdwqwqdwqwqdwqd', overflow: TextOverflow.ellipsis,),
                          Text('20000원 . 3개'),
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

  Widget writed_review() {
    return Container();
  }

  Future bottom_sheet() {
    return showModalBottomSheet(
        context: context,
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
            child: Text('ㅂㅈㅇㅂㅈㅇㅂㅇㅈㅂㅇㅂ모달 시트'),
          );
        }
    );
   }
}
