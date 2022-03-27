import 'package:flutter_chatapp_nullsafety/components/tab_all_media.dart';
import '../components/tab_all_file.dart';
import '../theme/colour.dart';
import '../data/server.dart';
import 'package:flutter/material.dart';
import '../components/people_card.dart';

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
  Server server = Server();

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
            title: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(server.address+'/rooms/'+mmessages_data['Id']+'/media'+mmessages_data['room_avatar']),
                ),
                SizedBox(width: kDefaultPadding * 0.75),
                Text(mmessages_data['room_name']),
              ],
            ),
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
              TabPeople(),
              TabMedia(),
              TabFile(),
            ],
          ),
        ),
    );
  }

  Widget TabPeople(){
    return ListView.builder(
      itemCount: mmessages_data!['people'].length,
      itemBuilder: (context, index) => PeopleCard(
        people_data: mmessages_data!['people'][index],
        // press: () => Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => MessagesScreen(
        //       messages_data: chatData![index],
        //       userId: '6124d969ec6a70a004662dc1',
        //     ),
        //   ),
        // ),
      ),
    );
  }

  Widget TabMedia(){
    return GridAllMedia(
      messenger_data: mmessages_data,
    );
  }

  Widget TabFile(){
    return GridAllFile(
      messenger_data: mmessages_data,
    );
  }

}

