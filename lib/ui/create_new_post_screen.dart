import 'dart:io';
import 'package:flutter/material.dart';
import '../stream/bloc_stream.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../data/server.dart';

enum ImageSourceType { gallery, camera }

class CreatePostScreen extends StatefulWidget {
  static const route = '/createpost';
  final userName;
  final userAvatar;
  final userId;

  const CreatePostScreen({
    Key? key,
    this.userName,
    this.userAvatar,
    this.userId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CreatePostScreenState(userId: userId, userName: userName, userAvatar: userAvatar);   //tham số userAvatar là users/...
  }
}

class CreatePostScreenState extends State<StatefulWidget> {
  CreatePostScreenState({
    this.userName,
    this.userAvatar,
    this.userId,
  });

  final userName;
  final userAvatar;
  final userId;
  final formKey = GlobalKey<FormState>();
  String? status;
  String message = '';

  final bloc = Bloc();
  String? errorMessage = '';
  String? errorMessagePass = '';

  final imagePicker = new ImagePicker();
  final server = Server();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        body: Container(
          margin: EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                statusField(),
                SizedBox(height: 10),
                ImgUpload(),
                Container(margin: EdgeInsets.only(top: 20.0)),
                Visibility (
                  child: Column(
                    children: [
                      PostButton(),
                      SizedBox(height: 12),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  visible: status!='' && status!=null,
                ),
                // SizedBox(height: 12),
                // PostButton(),
              ],
            ),
          ),
        )
    );
  }


  Widget statusField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        icon: Icon(Icons.text_fields),
        labelText: 'Viết status tại đây',
        errorText: errorMessage,
      ),
      // validator: validateEmail,
      onSaved: (value) {
        status = value as String;
      },
      onChanged: (String value) {
        print('onChanged status: $value');
        message = 'Thông tin post hợp lệ!';  //set lại messsage mỗi lần thay đổi thọng tin (để kk cho hiện chữ Đăng nhập thành công khi chưa bấm login)
        setState(() {
          status = value as String;
          print('Update the state of the screen...');
        });
      },
    );
  }

  Widget ImgUpload() {
    var _image = null;
    return Center(
      child: GestureDetector(
        onTap: () async {
          var image = await imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
          if(image != null) {
            setState(() {
              _image = File(image.path);
            });
          }
        },
        child: Container(
          decoration: BoxDecoration( //cái này của container GestureDetector pick image
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(21),
          ),
          child: _image != null ? Image.file(_image, width: 300, height: 300, fit: BoxFit.fitHeight) : Container(
            decoration: BoxDecoration(  //cái này của Container Image
              color: Colors.red[200],
              borderRadius: BorderRadius.circular(21),
            ),
            width: 200,
            height: 200,
            child: Icon(
              Icons.picture_in_picture_outlined,
              color: Colors.grey[800],
            ),
          ),
        ),
      ),
    );
  }

  Widget PostButton() {
    return GestureDetector(
      onTap: () => {
        _handle_post(),
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 12, left: 30, right: 30, top: 12),
        decoration: BoxDecoration( //cái này của container GestureDetector pick image
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(21),
        ),
        child: Text('Đăng bài'),
      ),
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
            backgroundImage: NetworkImage(server.address_feed+'/'+userAvatar),
          ),
          SizedBox(width: 12),
          Text(userName),
        ],
      ),
    );
  }


  _handle_post() async {
    var post_data = {
      'user_id': userId,
      'user_name': userName,
      'user_avatar': userAvatar,
      'type': 'news',
      'status': status,
      'image': [],
      'video': [],
      'group': [],
      'is_blocked': [],
    };
    final response = await http.post(
      Uri.parse(server.address_feed+'/process/add_news'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(post_data)
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Đăng bài thành công"),
      ));
      Navigator.pop(context);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create post.');
    }
    // List<dynamic> ed = ['send-new-post', post_data];
    // socket!.addSink(ed);
  }

}