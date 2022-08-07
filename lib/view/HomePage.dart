import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_app/CustomClasses/ALL_COLORS.dart';
import 'package:user_app/view_model/MedicineViewModel.dart';
import 'BottomTabs/Categories.dart';
import 'BottomTabs/MyAccountPage.dart';
import 'BottomTabs/MyCartPage.dart';
import 'BottomTabs/MyWishListPage.dart';
import 'BottomTabs/MedicineHomePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final medicineViewModel = Get.put(MedicineViewModel());

  int _selectedPage = 2;
  onPageSelected(int index){
   setState(() {
     _selectedPage = index;
   });
  }
  List<Widget> _pages = [MyAccountPage(),Categories(),
    ProductsHomePage(),MyWishListPage(),MyCartPage()];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: _pages[_selectedPage],
            bottomNavigationBar: Obx(()=>ConvexAppBar.badge(
              {3: medicineViewModel.wishlistCount.toString(),4: medicineViewModel.cartCount.toString(),},
              initialActiveIndex: _selectedPage,
              backgroundColor: greenColor,
              items: [
                TabItem(icon: Icons.person, title: 'Account'),
                TabItem(icon: Icons.category_outlined, title: 'Categories'),
                TabItem(icon: Icons.map, title: 'Home'),
                TabItem(icon: Icons.favorite_border, title: 'Wishlist'),
                TabItem(icon: Icons.shopping_bag_outlined, title: 'Cart'),
              ],
              onTap: (i) {
                onPageSelected(i);
              },
            ))
        )
    );
  }
}
