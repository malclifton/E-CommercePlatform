import 'package:flutter/material.dart';

class SellingScreen extends StatefulWidget {
  const SellingScreen({super.key});

  @override
  State<SellingScreen> createState() => _SellingScreenState();
}

class _SellingScreenState extends State<SellingScreen> {
  Widget _buildFeaturedProduct(
      {required String name, required double price, required String image}) {
    return Card(
      child: Container(
        height: 250,
        width: 180,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              height: 190,
              width: 160,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/$image"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              "\$ $price",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.grey[500]),
            ),
            Text(
              name,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.grey[500]),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Browse Items"),
        centerTitle: true,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Colors.black,
              )),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Featured",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800]),
                            ),
                          ]),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: 700,
              child: GridView.count(
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
                crossAxisCount: 2,
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  _buildFeaturedProduct(
                      image: "pink top.jpg",
                      price: 25.00,
                      name: "Pink T-Shirt"),
                  _buildFeaturedProduct(
                      image: "heart earrings.jpg",
                      price: 15.00,
                      name: "Gold Heart Earrings"),
                  _buildFeaturedProduct(
                      image: "pink top.jpg",
                      price: 25.00,
                      name: "Pink T-Shirt"),
                  _buildFeaturedProduct(
                      image: "heart earrings.jpg",
                      price: 15.00,
                      name: "Gold Heart Earrings"),
                  _buildFeaturedProduct(
                      image: "pink top.jpg",
                      price: 25.00,
                      name: "Pink T-Shirt"),
                  _buildFeaturedProduct(
                      image: "heart earrings.jpg",
                      price: 15.00,
                      name: "Gold Heart Earrings"),
                  _buildFeaturedProduct(
                      image: "pink top.jpg",
                      price: 25.00,
                      name: "Pink T-Shirt"),
                  _buildFeaturedProduct(
                      image: "heart earrings.jpg",
                      price: 15.00,
                      name: "Gold Heart Earrings"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
