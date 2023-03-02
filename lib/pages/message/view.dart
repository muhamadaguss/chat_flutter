import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:chat_flutter/common/values/values.dart';
import 'package:chat_flutter/pages/message/index.dart';
import 'package:chat_flutter/pages/message/widgets/message_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MessagePage extends GetView<MessageController> {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppBar _buildAppBar() {
      return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 176, 106, 231),
                Color.fromARGB(255, 166, 112, 231),
                Color.fromARGB(255, 131, 123, 231),
                Color.fromARGB(255, 104, 132, 231),
              ],
              transform: GradientRotation(
                90,
              ),
            ),
          ),
        ),
        title: Container(
          padding: EdgeInsets.only(
            top: 0.w,
            bottom: 0.w,
            right: 0.w,
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: 0.w,
                  bottom: 0.w,
                  right: 0.w,
                ),
                child: InkWell(
                  onTap: () {},
                  child: SizedBox(
                    width: 44.w,
                    height: 44.w,
                    child: CachedNetworkImage(
                      imageUrl: controller.state.toAvatar.value,
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          height: 44.w,
                          width: 44.w,
                          margin: null,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(44.w),
                            ),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                      errorWidget: (context, url, error) => Image(
                        image: AssetImage(
                          'assets/images/feature-1.png',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 15.w,
              ),
              Container(
                width: 180.w,
                padding: EdgeInsets.only(
                  top: 0.w,
                  bottom: 0.w,
                  right: 0.w,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 180.w,
                      height: 44.w,
                      child: GestureDetector(
                        onTap: () {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.state.toName.value,
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryBackground,
                              ),
                            ),
                            Text(
                              controller.state.toLocation.value,
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.normal,
                                color: AppColors.primaryBackground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        leading: InkWell(
          onTap: () {
            Get.back(
              result: 'back',
            );
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.primaryBackground,
          ),
        ),
      );
    }

    void _showPicker(BuildContext context) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Photo Library'),
                  onTap: () {
                    controller.imagePicker(
                      ImageSource.gallery,
                    );
                    Get.back();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Camera'),
                  onTap: () {
                    controller.imagePicker(
                      ImageSource.camera,
                    );
                    Get.back();
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: Stack(
            children: [
              MessageList(),
              MessageBar(
                onSend: (_) => controller.sendMessage(_),
                actions: [
                  InkWell(
                    child: Icon(
                      Icons.add,
                      color: Colors.black,
                      size: 24,
                    ),
                    onTap: () {
                      _showPicker(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: InkWell(
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.green,
                        size: 24,
                      ),
                      onTap: () {
                        controller.imagePicker(
                          ImageSource.camera,
                        );
                        // Get.back();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
