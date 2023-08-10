import 'package:courier_app/src/components/custom_divider.dart';
import 'package:courier_app/src/core/constants/assets.dart';
import 'package:courier_app/src/core/constants/dimensions.dart';
import 'package:courier_app/src/features/features/add_order/add_order1_screen.dart';
import 'package:courier_app/src/features/features/all_item/all_item_screen.dart';
import 'package:courier_app/src/features/features/home/home_screen.dart';
import 'package:courier_app/src/features/features/profile/edit_profile.dart';
import 'package:courier_app/src/features/features/profile/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../constants/palette.dart';


class CustomNavBar extends StatefulWidget {
  const CustomNavBar({Key? key}) : super(key: key);

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  int _selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool click = false;
  bool click2 = false;
  bool click3 = false;
  bool click4 = false;

  static List<Widget> navigationWidgets = [
    HomeScreen(),
    ProfileScreen(),
    EditProfileScreen(),
    AllItemScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(onPressed: (){
        Get.to(AddOrderOneScreen());
        print('object');
      },
        backgroundColor: AppColors.white,
      child: CircleAvatar(
        backgroundColor: AppColors.orange,
        child: Icon(Icons.add),
      ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    click = !click;
                    if (click2 =false) {
                      click = true;
                    } else if (click3 = false) {
                      click = true;
                    } else if (click4 = false) {
                      click = true;
                    }
                  });
                  Get.to(AllItemScreen());
                  print('object');
                },
                icon: Image.asset(
                  ImgAssets.homeNav,
                  color: AppColors.orange,
                  colorBlendMode:
                  click == false ? BlendMode.modulate : BlendMode.srcIn,
                )),
            IconButton(
                onPressed: () {
                  setState(() {
                    click2 = !click2;
                    if (click = false) {
                      click2 = true;
                    } else if (click3 = false) {
                      click2 = true;
                    } else if (click4 = false) {
                      click2 = true;
                    }
                  });
                  Get.to(AllItemScreen());
                  print('object');
                },
                icon: Image.asset(
                  ImgAssets.boxTimeNav,
                  color: AppColors.orange,
                  colorBlendMode:
                  click2 == false ? BlendMode.modulate : BlendMode.srcIn,
                )),

            SizedBox(
              width: width_14,
            ),


            IconButton(
                onPressed: () {
                  setState(() {
                    click3 = !click3;
                    if (click = false) {
                      click3 = true;
                    } else if (click2 = false) {
                      click3 = true;
                    } else if (click4 = false) {
                      click3 = true;
                    }
                  });
                  Get.to(AllItemScreen());
                  print('object');
                },
                icon: Image.asset(
                  ImgAssets.itemNav,
                  color: AppColors.orange,
                  colorBlendMode:
                  click3 == false ? BlendMode.modulate : BlendMode.srcIn,
                )),
            IconButton(
                onPressed: () {
                  setState(() {
                    click4 = !click4;
                    if (click = false) {
                      click4 = true;
                    } else if (click2 = false) {
                      click4 = true;
                    } else if (click3 = false) {
                      click4 = true;
                    }
                  });
                  Get.to(AllItemScreen());
                  print('object');
                },
                icon: Image.asset(
                  ImgAssets.userNav,
                  color: AppColors.orange,
                  colorBlendMode:
                  click4 == false ? BlendMode.modulate : BlendMode.srcIn,
                )),
          ],
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: navigationWidgets),
    );
  }
}

// CustomDivider(
// width: width_50,
// ),

// IconButton(onPressed: (){
// setState(() {
// click4 =! click4;
// if(click=false){
// click2=true;
// }else if(click2=false){
// click2=true;
// } else if(click3=false){
// click2=true;
// }
// });
// Get.to(ProfileScreen());
// print('object');
// }, icon:
// Image.asset( ImgAssets.userNav,color: AppColors.orange, colorBlendMode:click4==false? BlendMode.modulate: BlendMode.srcIn,)),
//
