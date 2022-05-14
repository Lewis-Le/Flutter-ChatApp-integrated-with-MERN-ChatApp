// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatapp_nullsafety/components/chat_input_field.dart';
import 'dart:async';
// import 'package:http/http.dart' as http;
import './login_screen.dart';

class NewsFeedScreen extends StatefulWidget {
  static const route= '/newsfeed';
  @override
  State<StatefulWidget> createState() {
    return NewsFeedScreenState();
  }

}

class NewsFeedScreenState extends State<StatefulWidget> {

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var heigth = MediaQuery.of(context).size.height;
    return Scaffold(
      // appBar: _appbar(),
      body: Column(
        children: [
          SizedBox(height: 60),
          // Expanded(child: _content()),
          SizedBox(height: 10),
          Container(
            width: width,
            height: heigth*0.80,
            child: _contentArti(),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.logout),
      //   onPressed: () {
      //     Navigator.of(context).pushReplacementNamed(LoginScreen.route);
      //   },
      // ),
    );
  }



  AppBar _appbar(){
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Tin tức - ",
            style:
            TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
          ),
          Text(
            "News",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
          )
        ],
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }


  Widget HomeBody(){
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            ]
        ),
      ),
    );
  }



  Widget _card(){
    return GestureDetector(
      // onTap: (){
      //   Navigator.push(context, MaterialPageRoute(
      //       builder: (context) => CategoryNews(
      //         newsCategory: Text('Tin hot'),
      //       )
      //   ));
      // },
      child: Container(
        margin: EdgeInsets.only(right: 14),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                'https://images.unsplash.com/photo-1507679799987-c73779587ccf?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1502&q=80',
                height: 60,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 60,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black26
              ),
              child: Text(
                'Tin tức mới',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _cardArti(){
    return GestureDetector(
      // onTap: (){
      //   Navigator.of(context).pushReplacementNamed('/details');
      //   //   Navigator.push(context, MaterialPageRoute(
      //   //       builder: (context) => ArticleView(
      //   //         postUrl: posturl,
      //   //       )
      //   //   ));
      // },
      child: Container(
          margin: EdgeInsets.only(bottom: 10),
          width: MediaQuery.of(context).size.width,
          child: Container(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(6), bottomLeft: Radius.circular(6)),
                color: Colors.white38,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundImage: NetworkImage('https://cdn.dribbble.com/users/3734064/screenshots/14413405/media/6744f33319119e4db7637ba5b49e5d78.png?compress=1&resize=400x300&vertical=top'),
                            ),
                            if (true)   //kiểm tra trạng thái user có đang active hay không(do model trong database chưa có trường isActive nên tạm thời cho true)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  height: 16,
                                  width: 16,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Theme.of(context).scaffoldBackgroundColor,
                                        width: 3),
                                  ),
                                ),
                              )
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Lewis Lê',
                                  style:
                                  TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: Colors.black),
                                ),
                                SizedBox(height: 1),
                                Opacity(
                                  opacity: 0.44,
                                  child: Text(
                                    'Hôm qua lúc 12h45',   //time create
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                    TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: 0.64,
                          child: Icon(Icons.more),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 6),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1554475901-4538ddfbccc2?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1504&q=80',
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      )
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Viết chương trình gồm ít nhất một luồng các màn hình để trình bày layout các loại màn hình khác nhau của một ứng dụng. Ví dụ làm theo các layout trong tài liệu sau:',
                    maxLines: 2,
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                  Container(
                    child: Row(
                      children: [
                        ElevatedButton(onPressed: () => {}, child: Row( children: [ Icon(Icons.monitor_heart), SizedBox(width: 5), Text('120')]) ),
                        SizedBox(width: 12),
                        ElevatedButton(onPressed: () => {}, child: Row( children: [ Icon(Icons.comment), SizedBox(width: 5), Text('12')]) ),
                        SizedBox(width: 12),
                        ElevatedButton(onPressed: () => {}, child: Row( children: [ Icon(Icons.save) ]) ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }

  Widget _content(){  //listview của card phân loại nhỏ trên cùng
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 21,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 12,
          itemBuilder: (context, index) {
            return _card();
          }),
    );
  }

  Widget _contentArti(){
    return Container(
      margin: EdgeInsets.only(top: 2),
      child: ListView.builder(
          itemCount: 12,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            return _cardArti();
          }),
    );
  }

}


