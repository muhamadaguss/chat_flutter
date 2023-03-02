import 'package:chat_flutter/common/entities/entities.dart';
import 'package:chat_flutter/common/values/values.dart';
import 'package:chat_flutter/common/widgets/widgets.dart';
import 'package:chat_flutter/pages/me/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MePage extends GetView<MeController> {
  const MePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppBar _buildAppBar() {
      return transparentAppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            color: AppColors.primaryBackground,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    Widget meItem(MeListItem item) {
      return Container(
        height: 56.w,
        color: AppColors.primaryBackground,
        margin: EdgeInsets.only(bottom: 1.w),
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
        ),
        child: InkWell(
          onTap: () {
            if (item.route == '/logout') {
              controller.onLogout();
            } else {
              // Get.toNamed(item.route!);
              toastInfo(
                msg: 'Menu item ${item.name} is not implemented yet',
                backgroundColor: AppColors.primaryElement,
                textColor: AppColors.primaryBackground,
              );
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    margin: EdgeInsets.only(right: 16.w),
                    child: Image.asset(
                      item.icon ?? '',
                      // fit: BoxFit.none,
                    ),
                  ),
                  Text(
                    item.name ?? '',
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontFamily: 'Avenir',
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      height: 1,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    child: Image.asset(
                      'assets/icons/ang.png',
                      width: 15.w,
                      height: 15.w,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(() => CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.only(
                  bottom: 20.w,
                ),
                sliver: SliverToBoxAdapter(
                  child: controller.state.headDetail.value == null
                      ? Container()
                      : Container(
                          height: 160.w,
                          // color: AppColors.primaryBackground,
                          decoration: BoxDecoration(
                            color: AppColors.primaryBackground,
                            boxShadow: [
                              Shadows.primaryShadow,
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 60.w,
                                height: 60.w,
                                margin: EdgeInsets.only(bottom: 16.w),
                                child: ClipRRect(
                                  borderRadius: Radii.k6pxRadius,
                                  child: Image.network(
                                    controller
                                            .state.headDetail.value!.photoUrl ??
                                        '',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(
                                controller
                                        .state.headDetail.value!.displayName ??
                                    '',
                                style: TextStyle(
                                  color: AppColors.primaryText,
                                  fontFamily: 'Avenir',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.sp,
                                  height: 1,
                                ),
                              ),
                              SizedBox(
                                height: 10.w,
                              ),
                              Text(
                                controller.state.headDetail.value!.email ?? '',
                                style: TextStyle(
                                  color: AppColors.thirdElementText,
                                  fontFamily: 'Avenir',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14.sp,
                                  height: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: 0.w,
                  vertical: 0.w,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => meItem(controller.state.meList[index]),
                    childCount: controller.state.meList.length,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
