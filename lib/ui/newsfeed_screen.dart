import 'package:flutter/material.dart';
import '../data/server.dart';

class NewsFeedScreen extends StatefulWidget {
  static const route= '/newsfeed';

  const NewsFeedScreen({
    Key? key,
    this.newsfeedData,
    this.userId,
  }) : super(key: key);

  final dynamic newsfeedData; //data dạng obj của các bài viết
  final String? userId;

  @override
  State<StatefulWidget> createState() {
    return NewsFeedScreenState(newsfeedData: newsfeedData, userId: userId);
  }
}


class NewsFeedScreenState extends State<StatefulWidget> {
  final dynamic newsfeedData;
  final String? userId;

  NewsFeedScreenState({
    this.newsfeedData,
    this.userId,
  });

  Server server = Server();
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
            child: _contentArti(),  //listview các bài viết
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

  Widget _cardArti(data){
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
          margin: EdgeInsets.only(bottom: 10, left: 5, right: 5),
          width: MediaQuery.of(context).size.width,
          child: Container(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(6), bottomLeft: Radius.circular(6)),
                color: Colors.black12,
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
                              backgroundImage: NetworkImage(server.address_feed+'/'+data['user_avatar']),
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
                                  data['user_name'],
                                  style:
                                  TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: Colors.black),
                                ),
                                SizedBox(height: 1),
                                Opacity(
                                  opacity: 0.44,
                                  child: Text(
                                    data['created'],   //time create
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
                  data['news_type']['image'].length==0 ? SizedBox(height: 1) : ClipRRect(   //nếu bài viết có hình ảnh thì hiển thị hình ảnh, ngược lại thì ko hiện
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        server.address_feed+'/'+data['news_type']['image'][0],
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      )
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    data['news_type']['status'],
                    maxLines: 2,
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  // Container(
                  //   child: Row(
                  //     children: [
                  //       ElevatedButton(onPressed: () => {}, child: Row( children: [ Icon(Icons.monitor_heart), SizedBox(width: 5), Text('120')]) ),
                  //       SizedBox(width: 12),
                  //       ElevatedButton(onPressed: () => {}, child: Row( children: [ Icon(Icons.comment), SizedBox(width: 5), Text('12')]) ),
                  //       SizedBox(width: 12),
                  //       ElevatedButton(onPressed: () => {}, child: Row( children: [ Icon(Icons.save) ]) ),
                  //     ],
                  //   ),
                  // ),
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
          itemCount: newsfeedData.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            return _cardArti(newsfeedData[index]);
          }),
    );
  }

}


