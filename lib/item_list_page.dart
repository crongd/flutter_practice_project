import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_practice_project/item_details_page.dart';
import 'package:flutter_practice_project/models/product.dart';
import 'package:intl/intl.dart';

import 'constants.dart';

class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {

  List<Product> productList = [
    Product(
      productNo: 1,
      productName: "맥북",
      productImageUrl: "https://img.danawa.com/prod_img/500000/534/217/img/11217534_1.jpg?_v=20211026161925",
      price: 1600000),
    Product(
        productNo: 2,
        productName: "삼성 노트북",
        productImageUrl: "data:image/jpeg;base64,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",
        price: 700000),
    Product(
        productNo: 3,
        productName: "키보드",
        productImageUrl: "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAoHCBUVFRUWFhUYGBgWHBwcGBwZHBoaHB4aGiQaHB8dHxkcIS4lHB4rHxwaJz4oKy8xNTU1ISQ7QDs0Py40NTEBDAwMDw8PEQ8PETEdGB0/PzExMTE/NDExMTExND8xMTExMTE0MTExMTExMTExMTExMTExMTExMTExMTExMTExMf/AABEIAOEA4QMBIgACEQEDEQH/xAAbAAEAAwEBAQEAAAAAAAAAAAAAAwQFAgEGB//EAEMQAAEDAQUDBwkECgIDAAAAAAEAAhEDBAUSITEiQVETMkJhkbHSFVJTcXKBkqGyFBYjMwYkYoKiwcLR0+E08UOz8P/EABUBAQEAAAAAAAAAAAAAAAAAAAAB/8QAFhEBAQEAAAAAAAAAAAAAAAAAABEB/9oADAMBAAIRAxEAPwD9mREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAWbar3pMMOd1bgJ4SSJ9yuWgwxxGoB7lmXNTAZijacXSd8Nc5oE8AAMvXxQe/eKh53zb4l6y/qLpgkxrBaY7HK/J4rKvv/xe2B7iQrES/eKh53zb4l6L+oxMmOMtjtxK64ukQct6zK3/ACmewO6qkVL94qHnfNniXrr+ogAmQDoSWAH1bWauAuk55buMrNuz820esfVUSCUfpFQ875s8S6qX/RaYJIPAlgPzcrDMUEPIOW7+ao3CTyIg5nvgJBK2/wCiTAJJ4AsJ+peH9IKAyJ062eJe3rPImdZZ242KWyYuSp4Y5jNdIgT8kgjbf1IzEmNYLDHr2slx946HnfxM8Sjvjn0PbH1sWk4ukQct6QU/L1KMWcaTLI7cS8+8VDzvmzxKN3/KHseIdy0QXSZIjdrKRFN1/URBMgHSSwT6trNeD9IaHnfNniUV0/mWj2v66qu2jFyb8RB2Haeo8Uggff8ARBgkg8CWA/UjL/okwCSeALCfqXl0zyIjXE/63fyXl8TyJk54mfUEivT+kVDzvmzxL1t/UTJEkDWCwx69rJT2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PpcVtKg65pgmq8kaEkkjQ5EnLMDTgOC78ku9PU+J3iQXEVPyS709T4neJPJLvT1Pid4kouIqfkl3p6nxO8SeSXenqfE7xJRcRU/JLvT1Pid4k8ku9PU+J3iSi4sy8vzbP63fVSU/kl3p6nxO8S4dc0kE1XkjQkuJG/Il2WYGnAJRPTcxshs5mTk45qre9QOoujizcRq5vFTeSXenqfE7xLl9zk61XkcCXEdhdCCShUaGsmZwN46QD6lVvJ0vs5Hnerp0+KnbdBAAFaoANAHO8S5dc0wTVeSNCSSRociXZGQNOASi8QZGkb8s+2clj1mPNpOBwacGrm4hGzlEhXfJLvT1Pid4lx5GznlX4uMnFw50zCUeNo1pMVWTlP4R92ePNRXIDirYjJxOkgQCcdSTG5WfJLvT1Pid4lG25YmKrxOsEidTnDszJOZ4lKJrcYpVJInA7QRqCAIk55gKe6xFJnqPzJVYXQCRiqPcBnBcSPmStNogQNyK6REUBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREBERAREQEREH/2Q==",
        price: 300000),
    Product(
        productNo: 4,
        productName: "스마트폰",
        productImageUrl: "https://img.danawa.com/prod_img/500000/055/346/img/18346055_1.jpg?_v=20240201104911",
        price: 2000000),
    Product(
        productNo: 5,
        productName: "포도",
        productImageUrl: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.segye.com%2FnewsView%2F20170830003315&psig=AOvVaw1yJs4VorUDv3uUjvMpIyRI&ust=1710852107131000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCMCq9PLq_YQDFQAAAAAdAAAAABAD",
        price: 1110000),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("제품 리스트"),
        centerTitle: true,
      ),
      body: GridView.builder(
        itemCount: productList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.9,
          crossAxisCount: 2),
        itemBuilder: (context, index) {
          return productContainer(
            productNo: productList[index].productNo ?? 0,
            productName: productList[index].productName ?? "",
            productImageUrl: productList[index].productImageUrl ?? "",
            price: productList[index].price ?? 0,
          );
        },
      ),
    );
  }

  Widget productContainer({
    required int productNo,
    required String productName,
    required String productImageUrl,
    required double price
}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ItemDetailsPage(productNo: productNo, productName: productName, productImageUrl: productImageUrl, price: price);
        }));
      },
      child: Column(
        children: [
          CachedNetworkImage(
              height: 150,
              fit: BoxFit.cover,
              imageUrl: productImageUrl,
          placeholder: (context, url) {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                );
          },
          errorWidget: (context, url, error) {
                return const Center(
                  child: Text(("오류발생")),
                );
          },
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              productName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Text("${numberFormat.format(price)}원"),
          ),
        ],
      ),
    );
  }
}

