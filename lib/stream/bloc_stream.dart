import 'dart:async';


class Bloc {
  final _emailStreamController = StreamController();
  final _passStreamController = StreamController();

  final _textMessageStreamController = StreamController();

  // StreamController getEmailStreamController() {
  //   return _emailStreamController;
  // }

  // get emailStreamController => _emailStreamController;
  get changeEmail => _emailStreamController.sink.add;
  get changePass => _passStreamController.sink.add;

  get changeTextMessage => _textMessageStreamController.sink.add;   //stream cho input text message


  Bloc() {
    _emailStreamController.stream.listen(
            (event) {
          print('Listening email...: $event');
        }
    );
    _passStreamController.stream.listen(
            (event) {
          print('Listening pass...: $event');
        }
    );
    _textMessageStreamController.stream.listen((event) {
      print('text message in stream: $event');
    });

  }


}