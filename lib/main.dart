

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice_project/item_list_page.dart';

import 'package:flutter_practice_project/main_page.dart';
import 'package:flutter_practice_project/public/my_page.dart';
import 'package:flutter_practice_project/public/nav.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MarketPage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
    );
  }
}

class MarketPage extends StatefulWidget {
  int? no = 0;

  MarketPage({
    super.key,
    this.no
  });

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  int no = 0;
  static int cateNo = 0;
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    Screen(),
    MainPage(),
    MyPage(),
    ItemListPage(no: cateNo)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _selectedIndex = 1;
      if (widget.no != null) {
        no = widget.no!;
      }
    });

  }

  Widget bodyWidget(int no) {
    print(no);
    if (no == 0) {
      return SafeArea(
          child: _widgetOptions.elementAt(_selectedIndex)
      );
    } else {
      return SafeArea(
          child: ItemListPage(no: no)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text("musinsa mall"),
        //   centerTitle: true,
        // ),
        body: bodyWidget(no),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.manage_search_outlined),
                label: '카테고리',
                tooltip: '카테고리'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '홈',
                tooltip: '홈'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined),
                label: '마이',
                tooltip: '마이'
            ),
          ],
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.black,
          onTap: _onItemTapped,
        )
    );
  }
}

