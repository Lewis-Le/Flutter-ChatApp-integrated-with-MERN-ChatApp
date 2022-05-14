import '../theme/colour.dart';
import '../data/message_data.dart';
import '../components/message.dart';
import '../components/chat_input_field.dart';
import 'package:flutter/material.dart';
import '../ui/room_details_screen.dart';
import '../data/server.dart';


class MessagesScreen extends StatefulWidget {
  static const route = '/chat_message_screen';

  const MessagesScreen({
    Key? key,
    this.messages_data,
    this.userId,
  }) : super(key: key);

  final dynamic messages_data; //data dạng obj của cả group chat
  final String? userId;

  @override
  State<StatefulWidget> createState() {
    return MessagesScreenState(
      mmessages_data: messages_data,
      uuserId: userId,
    );
  }
}

class MessagesScreenState extends State<StatefulWidget> {

  final dynamic mmessages_data;
  final String? uuserId;

  MessagesScreenState({
    this.mmessages_data,
    this.uuserId,
  });

  ScrollController _scrollController = new ScrollController();  //scroll controller cho listView các tin nhắn
  List? _newest_message_data; //khởi tạo từ data sẵn trong database là demeChatMessage; đây là list sẽ dc setState mỗi khi có tin nhắn mới pass qua
  Server server = Server();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(),
      body: Body(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white.withOpacity(0.4),
      title: Row(
        children: [
          BackButton(),
          CircleAvatar(
            backgroundImage: NetworkImage(server.address+'/rooms/'+mmessages_data['Id']+'/media'+mmessages_data['room_avatar']),
          ),
          SizedBox(width: kDefaultPadding * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mmessages_data['room_name'],
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "Active 3m ago",
                style: TextStyle(fontSize: 12),
              )
            ],
          )
        ],
      ),
      actions: [
        // IconButton(
        //   icon: Icon(Icons.mediation),
        //   onPressed: () {},
        // ),
        IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: () {
            print('you press info button');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MessagesDetailsScreen(
                  messages_data: mmessages_data, //truyền data dạng obj của cả group chat này vào screen room details khi nhấn vào button info
                  userId: uuserId,
                ),
              ),
            );
          },
        ),
        SizedBox(width: kDefaultPadding / 2),
      ],
    );
  }


  Widget Body(){
    // print(mmessages_data);
    _newest_message_data = mmessages_data['message'];
    return Column(
      children: [
        Expanded(
          child: Container(
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     image: NetworkImage('https://www.teahub.io/photos/full/301-3012547_ios-blur-background-dark.jpg'),
            //     fit: BoxFit.cover,
            //   ),
            // ),
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: ListView.builder(
                controller: _scrollController,  //để scroll to bottom
                itemCount: _newest_message_data!.length,
                itemBuilder: (context, index) =>
                    Message(
                      message: _newest_message_data![index],
                      userId: uuserId,
                      messId: mmessages_data['Id'],
                    ),
              ),
            ),
          ),
        ),
        ChatInputField(user_id: uuserId, messenger_id: mmessages_data['Id'], callback: (val) => {
          if(mounted) setState(() => {
            _newest_message_data!.addAll(val),   //mỗi khi có tin nhắn mới thì sẽ set state lại list _newest_message_data từ dữ liệu pass qua từ component ChatInputField sang cho parent là chat_message_screen; cái này là nối 2 list lại với nhau nên dùng addAll()
            _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.easeOut),    //auto scroll to bottom khi có tin nhắn mới
            }
          )
        }),
      ],
    );
  }

}