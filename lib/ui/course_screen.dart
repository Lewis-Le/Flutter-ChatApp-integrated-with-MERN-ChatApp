import 'package:flutter/material.dart';
import 'dart:async';
// import 'package:http/http.dart' as http;

import '../theme/constants.dart';

class CourseScreen extends StatefulWidget {
  static const route= '/my_course';
  @override
  State<StatefulWidget> createState() {
    return CourseScreenState();
  }

}

class CourseScreenState extends State<StatefulWidget> {

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var heigth = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: width,
        height: heigth,
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: NetworkImage('https://i.pinimg.com/736x/4c/7a/b1/4c7ab1da89e96e9051005526164af8ed.jpg'),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Column(
        children: [
          SizedBox(height: 60),
          Center(
            child: Text(
              'Khóa học của tôi',
              style: kSubheadingextStyle,
            ),
          ),
          Container(
            width: width,
            height: heigth*0.73,
            padding: EdgeInsets.only(left: 20, right: 20),
            child: _grid_view_course(),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.logout),
      //   onPressed: () {
      //     Navigator.of(context).pushReplacementNamed(LoginScreen.route);
      //   },
      // ),
    ),
    );
  }


  Widget Course_card( index ){
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => DetailsScreen(),
        //   ),
        // );
      },
      child: Container(
        padding: EdgeInsets.all(20),
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage('https://media.istockphoto.com/vectors/illustration-of-person-working-in-tidy-modern-office-vector-id1295850292?b=1&k=20&m=1295850292&s=612x612&w=0&h=JlKf4rZ8P6jjmuXawfpOuRhEFBfIXVd2ZoNubBXP5js='),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Mobile app nâng cao',
              style: kTitleTextStyle,
            ),
            Text(
              '12 lessons',
              style: TextStyle(
                color: kTextColor.withOpacity(.5),
              ),
            )
          ],
        ),
      ),
    );
  }


  Widget _grid_view_course(){
    return Container(
      margin: EdgeInsets.only(top: 2),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              // childAspectRatio: 3 / 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 20
          ),
          itemCount: 12,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            return Course_card(index);
          }),
    );
  }

}


