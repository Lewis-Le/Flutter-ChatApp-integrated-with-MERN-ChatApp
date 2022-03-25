import '../theme/colour.dart';
import 'package:flutter/material.dart';

class MessagesDetailsScreen extends StatefulWidget {
  static const route = '/chat_message_details_screen';

  const MessagesDetailsScreen({
    Key? key,
    this.messages_data,
    this.userId,
  }) : super(key: key);

  final dynamic messages_data; //data dạng obj của cả group chat
  final String? userId;

  @override
  State<StatefulWidget> createState() {
    return MessagesDetailsScreenState(
      mmessages_data: messages_data,
      uuserId: userId,
    );
  }
}

class MessagesDetailsScreenState extends State<StatefulWidget> {

  final dynamic mmessages_data;
  final String? uuserId;

  MessagesDetailsScreenState({
    this.mmessages_data,
    this.uuserId,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(mmessages_data['room_name']),
            centerTitle: true,
            bottom: TabBar(
              tabs: [
                Tab(text: 'Thành viên', icon: Icon(Icons.people_alt_outlined)),
                Tab(text: 'Media', icon: Icon(Icons.photo_album_outlined)),
                Tab(text: 'Files', icon: Icon(Icons.file_copy_outlined)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Center(child: Text('Danh sách các thành viên trong group chat này')),
              Center(child: Text('Danh sách tất cả media trong group chat này')),
              Center(child: Text('Danh sách tất cả file trong group chat này')),
            ],
          ),
        ),
    );
  }

}

