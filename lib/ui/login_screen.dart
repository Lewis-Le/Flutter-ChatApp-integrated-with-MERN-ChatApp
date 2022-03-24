import 'package:flutter/material.dart';
import '../validation/login_validator.dart';
import '../stream/bloc_stream.dart';
import './home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const route = '/login';
  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}



class LoginScreenState extends State<StatefulWidget> with LoginValidator {
  final formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  String message = 'Thông tin đăng nhập hợp lệ, nhấn Login để đăng nhập';
  bool flagemail = false;
  bool flagpass = false;

  final bloc = Bloc();
  String? errorMessage = '';
  String? errorMessagePass = '';

  //function string reg check password
  // bool validateStructure(String value){
  //   String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[!@#\$&*~]).{8,}$';
  //   RegExp regExp = new RegExp(pattern);
  //   return regExp.hasMatch(value);
  // };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          margin: EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                emailField(),
                Container(margin: EdgeInsets.only(top: 20.0),),
                passwordField(),
                Container(margin: EdgeInsets.only(top: 40.0),),
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
                  visible: flagemail && flagpass,
                ),
              ],
            ),
          ),
        )
    );
  }

  Widget emailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        icon: Icon(Icons.person),
        labelText: 'Email address',
        errorText: errorMessage,
      ),
      // validator: validateEmail,

      onSaved: (value) {
        email = value as String;
      },
      onChanged: (String value) {
        print('onChanged email: $value');
        message = 'Thông tin đăng nhập hợp lệ, nhấn Login để đăng nhập';  //set lại messsage mỗi lần thay đổi thọng tin (để kk cho hiện chữ Đăng nhập thành công khi chưa bấm login)
        // bloc.getEmailStreamController().sink.add(value);
        // bloc.emailStreamController.sink.add(value);
        bloc.changeEmail(value);

        if (!value.contains('@')) {
          errorMessage = '$value đang thiếu dấu @';
          flagemail = false;
        } else {
          if (!value.contains('.')) {
            errorMessage = '$value đang thiếu đấu chấm (.)';
            flagemail = false;
          } else {
            errorMessage = '';
            flagemail = true;
          };
        };

        setState(() {
          print('Update the state of the screen...');
        });

        // Use stream to capture data....
      },

    );
  }

  Widget passwordField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        icon: Icon(Icons.text_fields),
        labelText: 'Password',
        errorText: errorMessagePass,
      ),
      //validator: validatePassword,
      onSaved: (String? value) {
        password = value as String;
      },
      onChanged: (value) {
        print('onChanged pass: $value');
        message = 'Thông tin đăng nhập hợp lệ, nhấn Login để đăng nhập';  //set lại messsage mỗi lần thay đổi thọng tin (để kk cho hiện chữ Đăng nhập thành công khi chưa bấm login)
        bloc.changePass(value);

        if (value.isEmpty || value == null) { //các điều kiện
          errorMessagePass = 'Password không được để trống!';
          flagpass = false;
        } else {
          if (!value.contains(new RegExp(r'[A-Z]'))) {
            errorMessagePass = 'Password phải có ít nhất 1 kí tự in hoa';
            flagpass = false;
          } else {
            if (!value.contains(new RegExp(r'[a-z]'))) {
              errorMessagePass = 'Password phải có ít nhất 1 kí tự thường';
              flagpass = false;
            } else {
              if (!value.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                errorMessagePass = 'Password phải có ít nhất 1 kí tự đặc biệt  !@#\$%^&*(),.?":{}|<>';
                flagpass = false;
              } else {
                if (value.length < 8) {
                  errorMessagePass = 'Password phải ít nhất 8 kí tự';
                  flagpass = false;
                } else {
                  errorMessagePass = '';
                  flagpass = true;
                };
              };
            };
          };
        };
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
          Navigator.of(context).pushReplacementNamed(HomeScreen.route);
          setState(() {
            message = 'Đăng nhập thành công!';
          });
          print('Đăng nhập thành công');
        },
        child: Text('Login')
    );
  }

}