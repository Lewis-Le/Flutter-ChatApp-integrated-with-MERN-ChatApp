import 'package:flutter/material.dart';
import '../theme/colour.dart';
import '../data/server.dart';
import '../ui/viewer_screen.dart';

class VideoMessage extends StatelessWidget {

  final List? media;
  final String? messId;
  ScrollController _scrollController = new ScrollController();
  Server server = Server();

  VideoMessage({
    this.media,
    this.messId,
  });

  Widget DisplayMedia(String url, BuildContext context){
    if(!url.contains('.mp4')){
      return GestureDetector(
        onTap: () { //Sự kiện khi nhấn vào media này thì mở screen viewer lên
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewerScreen(
                url: url,
                messId: messId,
              ),
            ),
          );
        }, // Image tapped
        child: Image(
          image: NetworkImage(server.address+'/rooms/$messId/media$url'),
        ),
      );
    } else {
      return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewerScreen(
                  url: url,
                  messId: messId,
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
    if(media!.length == 1){
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 300),
        itemCount: media!.length,
        itemBuilder: (context, index) =>
            DisplayMedia(
                media![index],
                context
            ),
      );
    } else if(media!.length % 3 == 0){
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 70),
        itemCount: media!.length,
        itemBuilder: (context, index) =>
            DisplayMedia(
                media![index],
                context
            ),
      );
    } else if(media!.length % 2 == 0){
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 100),
        itemCount: media!.length,
        itemBuilder: (context, index) =>
            DisplayMedia(
                media![index],
                context
            ),
      );
    };
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 50),
      itemCount: media!.length,
      itemBuilder: (context, index) =>
          DisplayMedia(
              media![index],
              context
          ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: double.infinity, maxWidth: MediaQuery.of(context).size.width * 0.45),
      // width: MediaQuery.of(context).size.width * 0.45, // 45% of total width
      child: AspectRatio(
        aspectRatio: 1.6,
         child: Container(
           width: 55,
           // height: MediaQuery.of(context).size.height,
           padding: EdgeInsets.symmetric(horizontal: 19.0, vertical: 7.0),
           decoration: BoxDecoration(
             // color: kPrimaryColor,
             // shape: BoxShape.circle,
             border: Border.all(
               color: kPrimaryColor,
               width: 1,
             ),
             borderRadius: BorderRadius.circular(18),
           ),
           child: DisplayGrid(),
         ),
      ),
    );
  }
}


//Stack(
//   alignment: Alignment.center,
//   children: [
//     ClipRRect(
//       borderRadius: BorderRadius.circular(8),
//       child: Image.asset("assets/images/Video Place Here.png"),
//     ),
//   ],
// ),