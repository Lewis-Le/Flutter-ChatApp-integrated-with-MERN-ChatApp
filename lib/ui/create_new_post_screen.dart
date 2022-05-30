import 'dart:io';

import 'package:flutter/material.dart';
import '../stream/bloc_stream.dart';
import 'package:image_picker/image_picker.dart';

enum ImageSourceType { gallery, camera }

class CreatePostScreen extends StatefulWidget {
  static const route = '/createpost';
  @override
  State<StatefulWidget> createState() {
    return CreatePostScreenState();
  }
}

class CreatePostScreenState extends State<StatefulWidget> {
  final formKey = GlobalKey<FormState>();
  String? status;
  String message = '';

  final bloc = Bloc();
  String? errorMessage = '';
  String? errorMessagePass = '';

  final imagePicker = new ImagePicker();

  @override
  Widget build(BuildContext context) {
    var _image = null;
    return Scaffold(
        appBar: buildAppBar(),
        body: Container(
          margin: EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                statusField(),
                SizedBox(height: 10,),
                Center(
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
                ),
                Container(margin: EdgeInsets.only(top: 20.0),),
                Visibility (
                  child: Column(
                    children: [
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      loginButton(),
                    ],
                  ),
                  visible: status=='',
                ),
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
          print('Update the state of the screen...');
        });
      },
    );
  }


  Widget loginButton() {
    return ElevatedButton(
        onPressed: () {
          // if (formKey.currentState.validate()) {
          //   formKey.currentState.save();
          //   print('email=$email');
          //   print('Demo only: password=$password');
          // }
          Navigator.of(context).pop();
          setState(() {
            message = 'Đăng bài thành công!';
          });
          print('Post bài done');
        },
        child: Text('Đăng bài')
    );
  }


  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white.withOpacity(0.4),
      title: Row(
        children: [
          BackButton(),
          // CircleAvatar(
          //   backgroundImage: NetworkImage(server.address+'/rooms/'+mmessages_data['Id']+'/media'+mmessages_data['room_avatar']),
          // ),
        ],
      ),
    );
  }

}