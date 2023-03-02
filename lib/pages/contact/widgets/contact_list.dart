import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_flutter/common/entities/entities.dart';
import 'package:chat_flutter/common/values/values.dart';
import 'package:chat_flutter/pages/contact/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ContactList extends GetView<ContactController> {
  const ContactList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget BuildListItem(UserData item) {
      return Container(
        padding: EdgeInsets.only(
          top: 15.w,
          left: 15.w,
          right: 15.w,
        ),
        child: InkWell(
          onTap: () {
            if (item.id != null) {
              controller.goChat(item);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: 0.w,
                  left: 0.w,
                  right: 15.w,
                ),
                child: SizedBox(
                  width: 54.w,
                  height: 54.w,
                  child: CachedNetworkImage(
                    imageUrl: '${item.photourl}',
                  ),
                ),
              ),
              Container(
                width: 250.w,
                padding: EdgeInsets.only(
                  top: 15.w,
                  left: 0.w,
                  right: 0.w,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 200.w,
                      height: 42.w,
                      child: Text(
                        item.name ?? '',
                        style: TextStyle(
                          fontFamily: 'Avenir',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.thirdElement,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }

    return Obx(
      () => CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(
              vertical: 0.w,
              horizontal: 0.w,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  var item = controller.state.contactList[index];
                  return BuildListItem(item);
                },
                childCount: controller.state.contactList.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
