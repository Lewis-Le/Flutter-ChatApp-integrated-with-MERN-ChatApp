import 'package:flutter/material.dart';
import '../data/server.dart';
import '../theme/colour.dart';
import '../ui/viewer_screen.dart';

class GridAllFile extends StatelessWidget {
  GridAllFile({
    Key? key,
    this.messenger_data,
    this.press,
  }) : super(key: key);

  // final Chat? chat;
  final VoidCallback? press;
  final messenger_data;
  Server server = Server();
  List? all_file = [];

  Widget DisplayFile(String url, BuildContext context){
    if(url.contains('.mp3')){  //nếu file mp3
      return GestureDetector(
        onTap: () { //Sự kiện khi nhấn vào media này thì mở screen viewer lên
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewerScreen(
                url: url,
                messId: messenger_data['Id'],
              ),
            ),
          );
        }, // Image tapped
        child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Row(
              children: [
                Icon(Icons.audio_file),
                Text(url),
              ],
            )
          ),
        );
      } else {
        return GestureDetector(   //các file khác
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewerScreen(
                  url: url,
                  messId: messenger_data['Id'],
                ),
              ),
            );
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

  Widget DisplayFlieGrid(){
    all_file = [];
    for(int i=0; i<messenger_data['message'].length; i++){
      all_file!.addAll(messenger_data['message'][i]['files']);
    }
    if(all_file!.length == 0){
      return Center(child: Text('Danh sách tất cả media trong group chat này'));
    }
    return ListView.builder(
      // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
      itemCount: all_file!.length,
      itemBuilder: (context, index) =>
          DisplayFile(
              all_file![index],
              context
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DisplayFlieGrid();
  }
}