import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../stream/socket.dart';
import '../data/message_data.dart';
import '../theme/colour.dart';

typedef void DataCallback(List val);  //hàm pass data qua cho parent dưới dạng callback, data là dạng list
ServiceSocket? socket = ServiceSocket();

// class EmitData {
//   String? content;
//   List? media;
//   List? files;
//   List? seen;
//   String? send_by;
//   String? messId;
//   String? type;
//   EmitData(this.content, this.media, this.files, this.seen, this.send_by, this.messId, this.type);
//   // factory EmitData.fromJson(Map<String,dynamic> json) {
//   //   return EmitData(
//   //     content: json['room_name'],
//   //     media: json['message'],
//   //     files: json['room_avatar'],
//   //     seen: [],
//   //     send_by: 'aa',
//   //     messId: 'kk',
//   //     type: 'content',
//   //   );
//   // }
// }

class ChatInputField extends HookWidget {
  final DataCallback? callback;  //pass data qua cho parent dưới dạng callback trong props của class
  final String? messenger_id;
  final String? user_id;
  const ChatInputField({
    Key? key,
    this.callback,
    this.messenger_id,
    this.user_id,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    var _text_input_controller = TextEditingController(); //controller cho text input tin nhắn

    useEffect(() {
      socket!.socket!.on('broad-new-message', (emit_data) => {  //emit_data là dạng obj
        print('data listen in chat input $emit_data'),
        callback!([
          {
            'content': emit_data['content'],
            'media': emit_data['media'],
            'files': emit_data['files'],
            'seen': emit_data['seen'],
            'send_by': user_id,
            'Id': '61b1dcfbca06fa6524948cb7',
            'create': '2021-12-09T10:39:55.099Z'
          }
        ]),
        //callback!(emit_data) //gọi callback để pass data qua cho parent data tin nhắn mới, data pass qua là 1 list chứa 1 phần tử kiểu dữ liệu của class ChatMessage
      });
    },
      [],
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 32,
            color: Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: Container(
        child: Row(
          children: [
            // Icon(Icons.mic, color: kPrimaryColor),
            // SizedBox(width: kDefaultPadding),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 0.5,
                ),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.sentiment_satisfied_alt_outlined,
                          color: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .color!
                              .withOpacity(0.64),
                        ),
                        onPressed: () {
                          print('you press icon button');
                        }
                    ),
                    // SizedBox(width: kDefaultPadding / 4),
                    Expanded(
                      child: TextField(
                        controller: _text_input_controller,
                        onSubmitted: (String value) async {
                          //khi nhấn enter gửi message
                          print('text message: $value');
                          // final emit_data = EmitData(
                          //     value,
                          //     [],
                          //     [],
                          //     [],
                          //     '6124d969ec6a70a004662dc1',
                          //     '61b1dcfbca06fa6524948cb7',
                          //     'content',
                          // );
                          final emit_data = {
                            'content': '$value',
                            'media': [],
                            'files': [],
                            'seen': [],
                            'send_by': user_id,
                            'messId': messenger_id,
                            'type': 'content',
                          };

                          List<dynamic> ed = ['send-new-message', emit_data];
                          // socket!.socket.emit('send-new-message', emit_data);
                          socket!.addSink(ed);
                          // callback!([
                          //   {
                          //     'content': '$value',
                          //     'media': [],
                          //     'files': [],
                          //     'seen': [],
                          //     'send_by': user_id,
                          //     'Id': '61b1dcfbca06fa6524948cb7',
                          //     'create': '2021-12-09T10:39:55.099Z'
                          //   }
                          // ]); //gọi callback để pass data qua cho parent data tin nhắn mới, data pass qua là 1 list chứa 1 phần tử kiểu dữ liệu của class ChatMessage
                        },
                        decoration: InputDecoration(
                          hintText: "Type message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.attach_file_outlined,
                          color: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .color!
                              .withOpacity(0.64),
                        ),
                        onPressed: () {
                          print('you press icon button');
                        }
                    ),
                    // SizedBox(width: kDefaultPadding / 4),
                    IconButton(
                        icon: Icon(
                          Icons.photo_album_outlined,
                          color: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .color!
                              .withOpacity(0.64),
                        ),
                        onPressed: () {
                          print('you press icon button');
                        }
                    ),
                    // SizedBox(width: kDefaultPadding / 4),
                    IconButton(
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          color: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .color!
                              .withOpacity(0.64),
                        ),
                        onPressed: () {
                          print('you press icon button');
                        }
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
                icon: Icon(Icons.send_rounded, color: kPrimaryColor),
                onPressed: () {
                  print('you press icon button');
                }
            ),
          ],
        ),
      ),
    );
  }
}