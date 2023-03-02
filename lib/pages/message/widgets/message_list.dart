import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/bubbles/bubble_special_two.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:chat_flutter/common/values/values.dart';
import 'package:chat_flutter/pages/message/index.dart';
import 'package:chat_flutter/pages/message/widgets/message_left_item.dart';
import 'package:chat_flutter/pages/message/widgets/message_right_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MessageList extends GetView<MessageController> {
  const MessageList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = new DateTime.now();
    Widget _image(String url) {
      return Container(
        constraints: BoxConstraints(
          minHeight: 20.0,
          minWidth: 20.0,
        ),
        child: CachedNetworkImage(
          imageUrl: url,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(value: downloadProgress.progress),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      );
    }

    return Obx(
      () => Container(
        color: AppColors.chatbg,
        padding: EdgeInsets.only(
          bottom: 50.h,
        ),
        child: CustomScrollView(
          reverse: true,
          controller: controller.msgController,
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(
                vertical: 0.w,
                horizontal: 0.w,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return controller.state.msgContentList[index].uid !=
                            controller.user_id
                        ? MessageLeftItem(
                            controller.state.msgContentList[index],
                            index,
                            toAvatar: controller.state.toAvatar.value,
                            toName: controller.state.toName.value,
                          )
                        : MessageRightItem(
                            controller.state.msgContentList[index],
                            index,
                            fromAvatar: controller.state.fromAvatar.value,
                            fromName: controller.state.fromName.value,
                          );
                  },
                  childCount: controller.state.msgContentList.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
