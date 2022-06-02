import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatapp_nullsafety/theme/constants.dart';
import 'package:http/http.dart' as http;
import '../stream/socket.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:convert';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import '../theme/colour.dart';
import '../data/server.dart';
import '../theme/outline_button.dart';
import '../components/chat_card.dart';
import '../data/chat_data.dart';
import '../ui/course_screen.dart';
import '../ui/chat_messages_screen.dart';
import '../ui/newsfeed_screen.dart';
import '../ui/create_new_post_screen.dart';
import '../ui/profile_screen.dart';


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
  int _selectedIndex = 1; //dùng cho navbar old
  var currentIndex = 0; //dùng cho navbar new
  // List<Widget> screen = [_Home_screen(), ProfileScreen()];
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
  List? newsfeedData = [];
  dynamic userData;
  Server server = Server();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // futureChat = fetchMessengersData();
    String user_id = '6124d969ec6a70a004662dc1';
    Uri url = Uri.http('10.0.2.2:8000', '/process/messengers/$user_id');  //lấy data các group chat từ api Transportation
    http.get(Uri.http('10.0.2.2:8001', '/process/users/$user_id')).then(  //lấy userData từ server Newsfeed
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

    //Get data newsfeed từ server
    http.get(Uri.http('10.0.2.2:8001', '/process/news/all')).then(
            (result3) {
          // print(result.body);
          var jsonData3 = result3.body;
          var jsonObj3 = json.decode(jsonData3);  //chuyển từ json raw string sang json obj dể dùng (tương tự body parser)
          setState(() {
            newsfeedData!.addAll(jsonObj3);   //nối 2 list dùng addAll
          });
          // return jsonData;
        }
    ).catchError((Object error) {
      print(error);
    });
  }


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var heigth = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true, //cho tràn viền nội dung lên phía sau appbar
      appBar: buildAppBar(),
      body: IndexedStack(
        index: currentIndex,
        children: [
          CourseScreen(),
          NewsFeedScreen(newsfeedData: newsfeedData, chatData: chatData, userId: userData==null ? '' : userData[0]['Id'], userAvatar: userData==null ? '' : server.address_feed+'/'+userData[0]['avatar'], userName: userData==null ? '' : userData[0]['name']),
          ChatScreen(width, heigth),
          ProfileScreen(userData: userData[0]),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white.withOpacity(0.4),
        child: Icon(Icons.add),
        onPressed: () {
          // Navigator.of(context).pushReplacementNamed('/createpost');
          if(currentIndex == 1) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreatePostScreen(userId: userData==null ? '' : userData[0]['Id'], userAvatar: userData==null ? '' : userData[0]['avatar'], userName: userData==null ? '' : userData[0]['name'])));
          }
          print('you press floating action button');
        },
      ),
      bottomNavigationBar: BottomNav(),
    );
  }


  Widget ChatScreen(width, height) {
    return Column(
      children: [
        Container(
          width: width,
          height: height*0.9,
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
          padding: EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://i.pinimg.com/736x/4c/7a/b1/4c7ab1da89e96e9051005526164af8ed.jpg'),
                fit: BoxFit.cover,
              ),
          ),
          child: chatData==[] ? Text('Không kết nối được với server!') : ListView.builder(
            itemCount: chatData!.length,
            itemBuilder: (context, index) => ChatCard(
              chat: chatData![index],
              press: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessagesScreen(
                    messages_data: chatData![index], //truyền data dạng obj của cả group chat này vào component MessageScreen khi nhấn vào chatCard
                    userId: userData==null ? '' : userData[0]['Id'],
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
      backgroundColor: Colors.white.withOpacity(0.5),
      // shadowColor: kPrimaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
      ),
      elevation: 0,
      title: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundImage: userData==null ? NetworkImage('data:image/png;base64,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') : NetworkImage(server.address_feed+'/'+userData[0]['avatar']),
          ),
          SizedBox(width: 12,),
          Text(
            userData!=null ? userData[0]['name'] : 'Phúc',
            style: TextStyle(
              fontSize: 18,
              color: kTextColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
      ],
    );
  }


  Widget buildBottomNavigationBar() {  //old
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      backgroundColor: Colors.white.withOpacity(0.4),
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
            backgroundImage: userData==null ? NetworkImage('data:image/png;base64,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') : NetworkImage(server.address+'/'+userData[0]['avatar']),
          ),
          label: userData==null ? '' : userData[0]['name'],
        ),
      ],
    );
  }


  Widget BottomNav(){
    double displayWidth = MediaQuery.of(context).size.width;
    List<IconData> listOfIcons = [
      Icons.class_,
      Icons.feed,
      Icons.messenger,
      Icons.person_rounded,
    ];
    List<String> listOfStrings = [
      'Course',
      'Newsfeed',
      'Chat',
      'Profile',
    ];
    return Container(
      margin: EdgeInsets.only(left: displayWidth*.04, right: displayWidth*.04, bottom: 10),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            blurRadius: 30,
            offset: Offset(0, 10),
          ),
        ],
        borderRadius: BorderRadius.circular(50),
      ),
      child: ListView.builder(
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: displayWidth * .04),
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            setState(() {
              currentIndex = index;
              HapticFeedback.lightImpact();
              // _screen = screen[index];
            });
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Stack(
            children: [
              AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.fastLinearToSlowEaseIn,
                width: index == currentIndex
                    ? displayWidth * .32
                    : displayWidth * .18,
                alignment: Alignment.center,
                child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  curve: Curves.fastLinearToSlowEaseIn,
                  height: index == currentIndex ? displayWidth * .12 : 0,
                  width: index == currentIndex ? displayWidth * .32 : 0,
                  decoration: BoxDecoration(
                    color: index == currentIndex
                        ? Colors.blueAccent.withOpacity(.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.fastLinearToSlowEaseIn,
                width: index == currentIndex
                    ? displayWidth * .31
                    : displayWidth * .18,
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Row(
                      children: [
                        AnimatedContainer(
                          duration: Duration(seconds: 1),
                          curve: Curves.fastLinearToSlowEaseIn,
                          width:
                          index == currentIndex ? displayWidth * .13 : 0,
                        ),
                        AnimatedOpacity(
                          opacity: index == currentIndex ? 1 : 0,
                          duration: Duration(seconds: 1),
                          curve: Curves.fastLinearToSlowEaseIn,
                          child: Text(
                            index == currentIndex
                                ? '${listOfStrings[index]}'
                                : '',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        AnimatedContainer(
                          duration: Duration(seconds: 1),
                          curve: Curves.fastLinearToSlowEaseIn,
                          width:
                          index == currentIndex ? displayWidth * .03 : 20,
                        ),
                        Icon(
                          listOfIcons[index],
                          size: displayWidth * .076,
                          color: index == currentIndex
                              ? Colors.blueAccent
                              : Colors.black26,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}