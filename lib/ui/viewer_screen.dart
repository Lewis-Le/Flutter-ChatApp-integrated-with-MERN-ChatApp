import '../theme/colour.dart';
import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';
import '../data/server.dart';


class ViewerScreen extends StatefulWidget {
  static const route = '/viewer_screen';

  const ViewerScreen({
    Key? key,
    this.url,
    this.messId,
  }) : super(key: key);

  final String? url;
  final String? messId;

  @override
  State<StatefulWidget> createState() {
    return ViewerScreenState(
      url: url,
      messId: messId,
    );
  }
}


class ViewerScreenState extends State<StatefulWidget> {

  final String? url;
  final String? messId;

  ViewerScreenState({
    this.url,
    this.messId,
  });

  Server server = Server();
  String fileName ='';

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   if(url!.contains('.mp4')) {
  //     _controller = VideoPlayerController.network(
  //         server.address + '/rooms/$messId/media$url')
  //       ..initialize().then((_) {
  //         // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
  //         setState(() {});
  //       });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: InteractiveViewer(
        child: DataViewer(),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          BackButton(),
          SizedBox(width: kDefaultPadding * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fileName,
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "Send by ...",
                style: TextStyle(fontSize: 12),
              )
            ],
          )
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.more_horiz_outlined),
          onPressed: () {
            print('you press more button');
          },
        ),
        SizedBox(width: kDefaultPadding / 2),
      ],
    );
  }

  Widget DataViewer(){
    if(url!.contains('.jpg') || url!.contains('.png') || url!.contains('.jpeg')){
      setState(() {
        fileName = 'Trình xem media';
      });
      return InteractiveViewer(
          child: Image(
            image: NetworkImage(server.address+'/rooms/$messId/media$url'),
          ),
      );
    } else if(url!.contains('.mp4')){
      return  BetterPlayer.network(
          server.address+'/rooms/$messId/media$url',
        betterPlayerConfiguration: BetterPlayerConfiguration(
          aspectRatio: 1,
          looping: false,
          autoPlay: true,
          fit: BoxFit.contain,
          // startAt: Duration(seconds: 0),
        ),
      );
    }
    else {
      setState(() {
        fileName = url!;
      });
      return Center(
        child: IconButton(
          icon: Icon(Icons.download),
          iconSize: 50,
          color: Colors.brown,
          tooltip: 'Download file này về',
          onPressed: () {
            print('Downloading...');
          },
        ),
      );
    }
  }

}