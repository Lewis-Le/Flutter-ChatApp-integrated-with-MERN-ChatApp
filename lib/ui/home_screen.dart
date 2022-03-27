import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../stream/socket.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:convert';
import '../theme/colour.dart';
import '../data/server.dart';
import '../theme/outline_button.dart';
import '../components/chat_card.dart';
import '../data/chat_data.dart';
import '../ui/chat_messages_screen.dart';


// Future<List<Chat>> fetchMessengersData() async {
//   String user_id = '6124d969ec6a70a004662dc1';
//   Uri url = Uri.http('localhost:8000', '/process/messengers/$user_id');  //lấy data các group chat từ api
//   final res = await http.get(Uri.parse('http://10.0.2.2:8000/process/messengers/$user_id'));
//   if (res.statusCode == 200) {
//     print(res.body);
//     // List jsonRes = jsonDecode(res.body);
//     return jsonDecode(res.body);
//   } else {
//     throw Exception('failed to fetch data');
//   }
// }

class HomeScreen extends StatefulWidget {
  static const route = '/home';
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}


class HomeScreenState extends State<StatefulWidget> {
  final formKey = GlobalKey<FormState>();
  ServiceSocket? socket = ServiceSocket();  //khai báo socket chung
  int _selectedIndex = 1;
  // Future<Chat> futureChat;
  List? chatData = [
    // Chat(
    //   room_name: '',
    //   room_avatar: '',
    //   create_by: '',
    //   Id: '',
    //   created: '',
    //   people: [],
    //   message: [],
    //   admin: [],
    //   isActive: true,
    //   time: '5m ago',
    // )
  ];
  dynamic userData;
  Server server = Server();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // futureChat = fetchMessengersData();
    String user_id = '6124d969ec6a70a004662dc1';
    Uri url = Uri.http('10.0.2.2:8000', '/process/messengers/$user_id');  //lấy data các group chat từ api
    http.get(Uri.http('10.0.2.2:8000', '/process/users/$user_id')).then(
            (result) {
          // print(result.body);
          var jsonData = result.body;
          var jsonObj = json.decode(jsonData);  //chuyển từ json raw string sang json obj dể dùng (tương tự body parser)
          setState(() {
            userData = jsonObj;   //nối 2 list dùng addAll
            // print(userData);
          });
          // get data messenger của user vừa mới login
          http.get(url).then(
                  (result2) {
                // print(result.body);
                var jsonData2 = result2.body;
                var jsonObj2 = json.decode(jsonData2);  //chuyển từ json raw string sang json obj dể dùng (tương tự body parser)
                //_imgUrl = jsonObj['url'];
                socket!.socket!.emit('send-user-messenger', {userData[0]['message']});  //phải thêm dấu {} để gửi data dạng obj
                socket!.socket!.emit('send-user-id', user_id);   //emit gửi user_id đến cho server thêm vào array khi kết nối
                //socket!.connectAndListen(user_id, userData[0]['message']); //kết nối socket để join room
                setState(() {
                  chatData!.addAll(jsonObj2);   //nối 2 list dùng addAll
                });
                // return jsonData;
              }
          ).catchError((Object error) {
            print(error);
          });
        }
    ).catchError((Object error) {
      print(error);
    });

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: _Home_screen(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Navigator.of(context).pushReplacementNamed('/stopwatch');
          print('you press create new message!');
        },
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }


  Widget _Home_screen() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(
              kDefaultPadding, 0, kDefaultPadding, kDefaultPadding
          ),
          color: kPrimaryColor,
          // child: Row(
          //   children: [
          //     FillOutlineButton(press: () {}, text: "Recent Message"),
          //     SizedBox(width: kDefaultPadding),
          //     FillOutlineButton(
          //       press: () {},
          //       text: "Active",
          //       isFilled: false,
          //     ),
          //   ],
          // ),
        ),
        Expanded(
          // child: FutureBuilder<Chat>(
          //   future: futureChat,
          //   builder: (context, snapshot) {
          //     if(snapshot.hasData) {
          //       return  Text(snapshot.data.name);
          //     } else if(snapshot.hasError) {
          //       return Text(snapshot.error.toString());
          //     }
          //     return const CircularProgressIndicator();
          //   }
          //   ),
          child: ListView.builder(
            itemCount: chatData!.length,
            itemBuilder: (context, index) => ChatCard(
              chat: chatData![index],
              press: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessagesScreen(
                    messages_data: chatData![index], //truyền data dạng obj của cả group chat này vào component MessageScreen khi nhấn vào chatCard
                    userId: '6124d969ec6a70a004662dc1',
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: kPrimaryColor,
      shadowColor: kPrimaryColor,
      title: Text("Chats"),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
      ],
    );
  }


  Widget buildBottomNavigationBar(){
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (value) {
        setState(() {
          _selectedIndex = value;
        });
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.messenger), label: "Chats"),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: "People"),
        BottomNavigationBarItem(
          icon: CircleAvatar(
            radius: 14,
            backgroundImage: NetworkImage(server.address+'/'+userData[0]['avatar']),
          ),
          label: userData[0]['name'],
        ),
      ],
    );
  }


}