import '../data/message_data.dart';
import 'package:flutter/material.dart';

import '../theme/colour.dart';

class TextMessage extends StatelessWidget {   //message truyền vào là dạng obj của 1 tin nhắn
  const TextMessage({
    Key? key,
    this.message,
    this.isSender,
  }) : super(key: key);

  // final ChatMessage? message;
  final message;
  final bool? isSender;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: MediaQuery.of(context).platformBrightness == Brightness.dark
      //     ? Colors.white
      //     : Colors.black,
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding * 0.75,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(isSender! ? 1 : 0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Wrap(
        children: [
          Text(
            message['content']==null ? '--' : message['content'],
            style: TextStyle(
              color: isSender!
                  ? Colors.white
                  : Theme.of(context).textTheme.bodyText1!.color,
            ),
          ),
        ],
      )
    );
  }
}

