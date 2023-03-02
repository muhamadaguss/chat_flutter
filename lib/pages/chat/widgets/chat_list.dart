import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_flutter/common/entities/entities.dart';
import 'package:chat_flutter/common/routes/routes.dart';
import 'package:chat_flutter/common/utils/utils.dart';
import 'package:chat_flutter/common/values/values.dart';
import 'package:chat_flutter/pages/chat/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChatList extends GetView<ChatController> {
  const ChatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget BuildListItem(QueryDocumentSnapshot<Msg> item) {
      return Container(
        padding: EdgeInsets.only(
          top: 15.w,
          left: 15.w,
          right: 15.w,
        ),
        child: InkWell(
          onTap: () {
            controller.goChat(item);
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
                  width: 40.w,
                  height: 40.w,
                  child: CachedNetworkImage(
                    imageUrl: item.data().from_uid == controller.token
                        ? '${item.data().to_avatar}'
                        : '${item.data().from_avatar}',
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => const Image(
                      image: AssetImage(
                        'assets/images/features-1.png',
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 200.w,
                        height: 21.w,
                        child: Text(
                          item.data().from_uid == controller.token
                              ? '${item.data().to_name}'
                              : '${item.data().from_name}',
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.thirdElement,
                          ),
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(
                        width: 200.w,
                        height: 21.w,
                        child: Text(
                          item.data().last_msg ?? '',
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.fourElementText,
                          ),
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 60.w,
                    height: 54.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          duTimeLineFormat(
                            (item.data().last_time as Timestamp).toDate(),
                          ),
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.fourElementText,
                          ),
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Obx(
      () => SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: controller.onRefresh,
        onLoading: controller.onLoading,
        header: WaterDropHeader(),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: 0.w,
                vertical: 0.w,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return BuildListItem(controller.state.messages[index]);
                },
                childCount: controller.state.messages.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
