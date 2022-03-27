import 'package:flutter/material.dart';
import '../data/server.dart';
import '../theme/colour.dart';
import '../ui/viewer_screen.dart';

class GridAllMedia extends StatelessWidget {
  GridAllMedia({
    Key? key,
    this.messenger_data,
    this.press,
  }) : super(key: key);

  // final Chat? chat;
  final VoidCallback? press;
  final messenger_data;
  Server server = Server();
  List? all_media = [];

  Widget DisplayMedia(String url, BuildContext context){
    if(!url.contains('.mp4')){   //nếu không phải video
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
        child: Image(
          image: NetworkImage(server.address+'/rooms/'+messenger_data['Id']+'/media'+url),
        ),
      );
    } else {
      return GestureDetector(   //nếu là video mp4
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
          child: Image(
            image: NetworkImage('https://thumbs.dreamstime.com/b/print-164210362.jpg'),
          )
      );
    }
  }

  Widget DisplayGrid(){
    all_media = [];
    for(int i=0; i<messenger_data['message'].length; i++){
      all_media!.addAll(messenger_data['message'][i]['media']);
    }
    if(all_media!.length == 0){
      return Center(child: Text('Danh sách tất cả media trong group chat này'));
    }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
      itemCount: all_media!.length,
      itemBuilder: (context, index) =>
          DisplayMedia(
              all_media![index],
              context
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DisplayGrid();
  }
}