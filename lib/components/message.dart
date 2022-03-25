//đây là component 1 message cụ thể để hiển thị bao gồm text, audio, hình ảnh.

import '../data/message_data.dart';
import 'package:flutter/material.dart';
import '../theme/colour.dart';
import '../data/server.dart';
import 'audio_message.dart';
import 'text_message.dart';
import 'video_message.dart';

class Message extends StatelessWidget {
  Message({
    Key? key,
    this.message,
    this.messId,
    this.userId
  }) : super(key: key);

  // final ChatMessage? message; //dùng theo class model, message!.content
  final message; //dùng kiểu dynamic không cần class model, message['content]
  final String? userId;
  final String? messId;
  Server server = Server();

  @override
  Widget build(BuildContext context) {
    Widget messageContaint(dynamic message, bool isSender) {  //vì tham số message là obj nên khai báo là dynamic
      // switch (message.messageType) {
      //   case ChatMessageType.text:
      //     return TextMessage(message: message);
      //   case ChatMessageType.audio:
      //     return AudioMessage(message: message);
      //   case ChatMessageType.video:
      //     return VideoMessage();
      //   default:
      //     return SizedBox();
      // }
      if (message['content'] == '') {
        if(message['media'].length > 0){
          return VideoMessage(media: message['media'], messId: messId);
        }
        if(message['files'].length > 0){
          return Image(
            height: 45,
            width: 45,
            image: NetworkImage('https://findicons.com/files/icons/2813/flat_jewels/512/file.png'),
          );;
        }
      }
      return TextMessage(
        message: message,
        isSender: isSender,
      ); //cố định message là dạng text vì trong database chưa có trường này
    }

    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding),
      child: Row(
        mainAxisAlignment:
        message['send_by']==userId ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!(message['send_by'] == userId)) ...[
            CircleAvatar(
              radius: 12,
              // backgroundImage: NetworkImage(server.address+"/"+message['people']['']),
            ),
            SizedBox(width: kDefaultPadding / 2),
          ],
          messageContaint(message!, message['send_by']==userId ? true : false),  //truyền vào data của message và tham số bool isSender cho biết có phải người gửi hay không
          // if (message['send_by']==userId) MessageStatusDot(status: message!.messageStatus!)  //trạng thái của tin nhắn
        ],
      ),
    );
  }
}

class MessageStatusDot extends StatelessWidget {
  final MessageStatus? status;

  const MessageStatusDot({Key? key, this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color dotColor(MessageStatus status) {
      switch (status) {
        case MessageStatus.not_sent:
          return kErrorColor;
        case MessageStatus.not_view:
          return Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.1);
        case MessageStatus.viewed:
          return kPrimaryColor;
        default:
          return Colors.transparent;
      }
    }

    return Container(
      margin: EdgeInsets.only(left: kDefaultPadding / 2),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: dotColor(status!),
        shape: BoxShape.circle,
      ),
      child: Icon(
        status == MessageStatus.not_sent ? Icons.close : Icons.done,
        size: 8,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}