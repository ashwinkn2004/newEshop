import 'package:eshop/screens/cart_screen.dart';
import 'package:eshop/screens/home_screen_drawer.dart';
import 'package:eshop/screens/product_type_box.dart';
import 'package:eshop/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../constants.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SizeConfig().init(context); // ✅ Add this line
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(LucideIcons.menu, color: Colors.black),
          ),
        ),
        title: Container(
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            onSubmitted: (value) {
              print("Search: $value");
            },
            decoration: InputDecoration(
              hintText: "Search products...",
              hintStyle: TextStyle(
                color: kSecondaryColor,
                fontFamily: 'Poppins',
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(LucideIcons.search, color: kSecondaryColor),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
            icon: const Icon(LucideIcons.shoppingCart, color: Colors.black),
          ),
        ],
      ),
      backgroundColor: Colors.white,

      //DRAWER


      drawer: HomeScreenDrawer(),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),

            /// 🔸 Category Scroll Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                height: SizeConfig.screenHeight * 0.1,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    ProductTypeBox(
                      icon: "assets/icons/Electronics.svg",
                      title: "Electronics",
                      onPress: _dummyPress,
                    ),
                    ProductTypeBox(
                      icon: "assets/icons/Books.svg",
                      title: "Books",
                      onPress: _dummyPress,
                    ),
                    ProductTypeBox(
                      icon: "assets/icons/Fashion.svg",
                      title: "Fashion",
                      onPress: _dummyPress,
                    ),
                    ProductTypeBox(
                      icon: "assets/icons/Groceries.svg",
                      title: "Groceries",
                      onPress: _dummyPress,
                    ),
                    ProductTypeBox(
                      icon: "assets/icons/Art.svg",
                      title: "Art",
                      onPress: _dummyPress,
                    ),
                    ProductTypeBox(
                      icon: "assets/icons/Others.svg",
                      title: "Others",
                      onPress: _dummyPress,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 🟦 Section: Products you like
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height:
                    SizeConfig.screenHeight * 0.4, // Adjusted for grid scroll
                decoration: _containerDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Products you like",
                        style: TextStyle(
                          fontSize: SizeConfig.screenWidth * 0.07,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount:
                              6, // number of liked products (hardcoded for now)
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.75,
                              ),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.all(12),
                              height: SizeConfig.screenHeight * 0.1,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Image(
                                        image: AssetImage(
                                          "assets/images/ps4_console_white_4.png",
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Product ${index + 1}",
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "\$${(index + 1) * 20}",
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// 🟦 Section: Explore All Products
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: SizeConfig.screenHeight * 0.5,
                decoration: _containerDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Explore all products",
                        style: TextStyle(
                          fontSize: SizeConfig.screenWidth * 0.07,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: 8, // you can increase or fetch dynamically
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.75,
                              ),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Image(
                                        image: AssetImage(
                                          "assets/images/ps4_console_white_3.png",
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Product ${index + 1}",
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "\$${(index + 1) * 25}",
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _dummyPress() {}

  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
      ],
    );
  }
}
