import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:chat_bubbles/bubbles/bubble_normal_image.dart';
import 'package:chat_flutter/common/entities/entities.dart';
import 'package:chat_flutter/common/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

Widget MessageLeftItem(Msgcontent item, int index,
    {String? toAvatar, String? toName}) {
  // String readTimestamp(Timestamp timestamp) {
  //   var now = DateTime.now();
  //   var format = DateFormat('HH:mm a');
  //   var date =
  //       DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
  //   // var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  //   var diff = now.difference(date);
  //   var time = '';
  //
  //   if (diff.inSeconds <= 0 ||
  //       diff.inSeconds > 0 && diff.inMinutes == 0 ||
  //       diff.inMinutes > 0 && diff.inHours == 0 ||
  //       diff.inHours > 0 && diff.inDays == 0) {
  //     time = format.format(date);
  //   } else if (diff.inDays > 0 && diff.inDays < 7) {
  //     if (diff.inDays == 1) {
  //       time = diff.inDays.toString() + ' DAY AGO';
  //     } else {
  //       time = diff.inDays.toString() + ' DAYS AGO';
  //     }
  //   } else {
  //     if (diff.inDays == 7) {
  //       time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
  //     } else {
  //       time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
  //     }
  //   }
  //
  //   return time;
  // }

  Widget _image(String? url) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 20.0,
        minWidth: 20.0,
      ),
      child: CachedNetworkImage(
        imageUrl: url ?? "",
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  return Container(
    padding: EdgeInsets.only(
      top: 10.w,
      bottom: 10.w,
      right: 15.w,
      left: 15.w,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: 30.w,
              height: 30.w,
              child: CachedNetworkImage(
                imageUrl: toAvatar ?? "",
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
            item.type == 'text'
                ? Expanded(
                    child: BubbleNormal(
                      text: item.content ?? "",
                      isSender: false,
                      color: Color(0xFFE6E6E6),
                      tail: true,
                      textStyle: TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF000000),
                      ),
                    ),
                  )
                : Expanded(
                    child: BubbleNormalImage(
                      id: 'chat_left_item $index',
                      image: _image(item.content),
                      color: Color(0xFFE6E6E6),
                      tail: true,
                      isSender: false,
                    ),
                  ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 45.w,
          ),
          child: Text(
            duTimeLineFormat(
              (item.addtime as Timestamp).toDate(),
            ),
            style: TextStyle(
              fontFamily: 'Avenir',
              fontSize: 10.sp,
              fontWeight: FontWeight.normal,
              color: Color(0xFF9B9B9B),
            ),
          ),
        ),
      ],
    ),
  );
}
