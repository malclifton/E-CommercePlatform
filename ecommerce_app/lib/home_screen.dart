//homepage will show....
// Recommended items, trending items (based on # of likes), last items viewed.
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  Widget _buildCategoryProduct(String image) {
    return CircleAvatar(
      maxRadius: 38,
      backgroundColor: Color(0xff669bbc),
      child: Container(
        height: 40,
        child: Image(
          color: Colors.white,
          image: AssetImage("assets/images/$image"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: 120,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: "Search",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30))),
                      ),
                      Container(
                        height: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Featured",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800]),
                                  ),
                                  Text(
                                    "See all",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800]),
                                  )
                                ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
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
                  ],
                ),
              ],
            ),
            Container(
              height: 70,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Categories",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "See All",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
                height: 60,
                child: Row(
                  children: <Widget>[
                    _buildCategoryProduct("tshirtIcon.png"),
                    _buildCategoryProduct("jeansIcon.png"),
                    _buildCategoryProduct("shoesIcon.png"),
                    _buildCategoryProduct("accessoriesIcon.png"),
                    _buildCategoryProduct("gamesIcon.png"),
                  ],
                )),
            Container(
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "New Items",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800]),
                        ),
                        Text(
                          "See all",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800]),
                        )
                      ]),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        _buildFeaturedProduct(
                            image: "colorful purse.jpg",
                            price: 68.00,
                            name: "Colorful Beaded Purse"),
                        _buildFeaturedProduct(
                            image: "brown flower shoes.jpg",
                            price: 130.00,
                            name: "Brown Sandles"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
