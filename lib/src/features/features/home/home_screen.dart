import 'package:courier_app/src/components/custom_headcard.dart';
import 'package:courier_app/src/components/custom_items.dart';
import 'package:courier_app/src/components/custom_shipping_chip.dart';
import 'package:courier_app/src/components/custom_text_button.dart';
import 'package:courier_app/src/core/constants/assets.dart';
import 'package:courier_app/src/core/constants/custom_tiles.dart';
import 'package:courier_app/src/core/constants/dimensions.dart';
import 'package:courier_app/src/core/constants/palette.dart';
import 'package:courier_app/src/core/constants/strings.dart';
import 'package:courier_app/src/core/constants/user_constants.dart';
import 'package:courier_app/src/features/auth/auth/preferences_service.dart';
import 'package:courier_app/src/features/features/add_order/add_order1_screen.dart';
import 'package:courier_app/src/features/features/all_item/all_item_screen.dart';
import 'package:courier_app/src/features/features/all_item/all_orders_model.dart';
import 'package:courier_app/src/features/features/home/home_controller.dart';
import 'package:courier_app/src/features/features/item_details/complete_details.dart';
import 'package:courier_app/src/features/features/item_details/delivered%20_details.dart';
import 'package:courier_app/src/features/features/item_details/pending_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../components/custom_text.dart';
import '../../../core/constants/font_weight.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  HomeController homeController = Get.put(HomeController());
  TextEditingController orderSearchController = TextEditingController();
  SharedPreferences prefs = PreferencesService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: margin_10),
            children: [
              // CustomListTile(
              //     colorBackCircle: AppColors.transparent,
              //     border: AppColors.transparent,
              //     icon: ImgAssets.transparent,
              //     image: const AssetImage(ImgAssets.forgotArt),
              //     title: '$strHello Mizan,',
              //     subtitle: strWelcomeBack),
              ListTile(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(radius_15), borderSide: BorderSide(color: AppColors.transparent)),
                leading: prefs.getString(UserContants.userProfilePhoto).toString().isNotEmpty &&
                    prefs.getString(UserContants.userProfilePhoto) != null
                    ? CircleAvatar(
                  backgroundImage:  NetworkImage(prefs.getString(UserContants.userProfilePhoto)!),
                  radius: radius_20,)
                    : CircleAvatar(
                  backgroundImage: const AssetImage(ImgAssets.badge),
                  radius: radius_40,
                ),
                title: CustomText(
                    text: prefs.getString(UserContants.userName) ?? 'Hey!',
                    color1: AppColors.greyColor,
                    fontWeight: fontWeight400,
                    fontSize: font_13),
                subtitle:
                CustomText(text: strWelcomeBack, color1: AppColors.black, fontWeight: fontWeight600, fontSize: font_16),
              ),
              CustomHeadCard(
                controller: orderSearchController,
                onTap: () async {
                  await homeController.searchByOrderToken(orderSearchController.text);
                  orderSearchController.clear();
                },
              ),
              CustomText(text: strService, color1: AppColors.black, fontWeight: fontWeight600, fontSize: font_19),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomItems(
                      image: AssetImage(ImgAssets.boxDrop),
                      text: strAddDrop,
                      onTap: () {
                        Get.to(const AddOrderOneScreen());
                      },
                    ),
                    CustomItems(
                      image: AssetImage(ImgAssets.boxPick),
                      text: strAddPick,
                      onTap: () {
                        Get.to(AllItemScreen(selectedStatus: 'Pickup Pending'));
                      },
                    ),
                    CustomItems(
                      image: const AssetImage(ImgAssets.boxPending),
                      text: strDelPending,
                      onTap: () {
                        Get.to(AllItemScreen(selectedStatus: 'Delivery Pending'));
                      },
                    ),
                    CustomItems(
                      image: const AssetImage(ImgAssets.boxAllItem),
                      text: strAllItem,
                      onTap: () {
                        Get.to(AllItemScreen(
                          selectedStatus: 'All',
                        ));
                      },
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(text: 'Recent Orders', color1: AppColors.black, fontWeight: fontWeight600, fontSize: font_19),
                  CustomTextButton(
                    text: strViewAll,
                    color: AppColors.orange,
                    fontWeight: fontWeight600,
                    font: font_15,
                    onPress: () {
                      Get.to(AllItemScreen(
                        selectedStatus: 'All',
                      ));
                    },
                  ),
                ],
              ),
              FutureBuilder<List<AllOrdersModel>>(
                  future: homeController.fetchRecentOrders(),
                  builder: (BuildContext context, AsyncSnapshot<List<AllOrdersModel>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.30,
                        child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.orange,
                            )),
                      );
                    } else if (snapshot.hasData) {
                      final List<AllOrdersModel> orders = homeController.ordersList;
                      return Column(
                        children: orders.map((order) {
                          // return AllOrdersModel order = orders[index];
                          String orderToken = order.orderToken.toString();
                          String senderName = order.senderName.toString();
                          String receiverName = order.receiverName.toString();
                          String productName = order.itemName.toString();
                          String dateAndTime = order.date.toString();
                          String status = order.status.toString();
                          Color buttonColor;
                          Color bgColor = AppColors.white;

                          if (status.toLowerCase() == 'pickup pending') {
                            buttonColor = AppColors.yellow;
                          } else if (status.toLowerCase() == 'completed') {
                            buttonColor = AppColors.orange;
                          } else {
                            buttonColor = AppColors.blue;
                          }

                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: InkWell(
                              onTap: () {
                                if (status.toLowerCase() == 'completed') {
                                  Get.to(() => CompleteOrdersScreen(
                                    orderToken: orderToken,
                                  ));
                                } else if (status.toLowerCase() == 'delivered') {
                                  Get.to(() => DeliveredOrdersScreen(
                                    orderToken: orderToken,
                                  ));
                                } else if (status.toLowerCase() == 'pickup pending') {
                                  Get.to(() => PendingDetailsScreen(
                                    orderToken: orderToken,
                                  ));
                                } else if (status.toLowerCase() == 'delivery pending') {}
                              },
                              child: ShippingChip(
                                orderUidNo: orderToken,
                                senderName: senderName,
                                recieverName: receiverName,
                                productName: productName,
                                time: dateAndTime,
                                buttonColor: buttonColor,
                                buttonName: status,
                                bgColor: bgColor,
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    } else {
                      return const Center(
                        child: Center(child: Text('No Orders added recently')),
                      );
                    }
                  }),
            ],
          )),
    );
  }
}

/*
 return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      AllOrdersModel order = orders[index];
                      String orderToken = order.orderToken.toString();
                      String senderName = order.senderName.toString();
                      String receiverName = order.receiverName.toString();
                      String productName = order.itemName.toString();
                      String dateAndTime = order.date.toString();
                      String status = order.status.toString();
                      Color buttonColor;
                      Color bgColor = AppColors.white;

                      if (status.toLowerCase() == 'pickup pending') {
                        buttonColor = AppColors.yellow;
                      } else if (status.toLowerCase() == 'completed') {
                        buttonColor = AppColors.orange;
                      } else {
                        buttonColor = AppColors.blue;
                      }

                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: InkWell(
                          onTap: () {
                            if (status.toLowerCase() == 'completed') {
                              Get.to(() => CompleteOrdersScreen(
                                    orderToken: orderToken,
                                  ));
                            } else if (status.toLowerCase() == 'delivered') {
                              Get.to(() => DeliveredOrdersScreen(
                                    orderToken: orderToken,
                                  ));
                            } else if (status.toLowerCase() == 'pickup pending') {
                              Get.to(() => PendingDetailsScreen(
                                    orderToken: orderToken,
                                  ));
                            } else if (status.toLowerCase() == 'delivery pending') {}
                          },
                          child: ShippingChip(
                            orderUidNo: orderToken,
                            senderName: senderName,
                            recieverName: receiverName,
                            productName: productName,
                            time: dateAndTime,
                            buttonColor: buttonColor,
                            buttonName: status,
                            bgColor: bgColor,
                          ),
                        ),
                      );
                    },
                  );
*/