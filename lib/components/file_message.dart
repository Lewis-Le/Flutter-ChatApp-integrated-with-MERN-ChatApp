import '../data/message_data.dart';
import 'package:flutter/material.dart';
import '../theme/colour.dart';

class FileMessage extends StatelessWidget {   //message truyền vào là dạng obj của 1 tin nhắn
  const FileMessage({
    Key? key,
    this.message,
    this.isSender,
  }) : super(key: key);

  // final ChatMessage? message;
  final message;
  final bool? isSender;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: double.infinity, maxWidth: MediaQuery.of(context).size.width * 0.7),
      // width: MediaQuery.of(context).size.width * 0.45, // 45% of total width
      child: AspectRatio(
        aspectRatio: 2.6,
        child: Container(
          // width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height,
          // padding: EdgeInsets.symmetric(horizontal: 19.0, vertical: 7.0),
          decoration: BoxDecoration(
            // color: kPrimaryColor,
            // shape: BoxShape.circle,
            border: Border.all(
              color: kPrimaryColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: ListView.builder(
            itemCount: message['files'].length,
            itemBuilder: (context, index) =>
                DisplayListFile(message['files'][index]),
          ),
        ),
      ),
    );
  }


  Widget DisplayListFile(String url){
    return GestureDetector(
      onTap: () {
        print('tap file');
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ViewerScreen(
        //       url: url,
        //       messId: message['Id'],
        //     ),
        //   ),
        // );
      }, // Image tapped
        child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Row(
              children: [
                Icon(Icons.file_copy),
                Text(url),
              ],
            )
        )
    );
  }

}