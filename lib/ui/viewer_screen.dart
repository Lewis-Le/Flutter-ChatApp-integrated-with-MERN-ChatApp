import '../theme/colour.dart';
import 'package:flutter/material.dart';
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
                'tên file',
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
    if(url!.contains('.jpg')){
      return Image(
        image: NetworkImage(server.address+'/rooms/$messId/media$url'),
      );
    } else {
      return Center(
        child: Text('Không thể xem file này!'),
      );
    }
  }

}