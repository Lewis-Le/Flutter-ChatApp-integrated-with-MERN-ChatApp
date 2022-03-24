import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';

class ServiceSocket {

  IO.Socket? socket;
  final StreamController<List<dynamic>> _emitEventSocket = StreamController<List<dynamic>>();
  Stream<List<dynamic>> get createNewEmit => _emitEventSocket.stream;
  final StreamController<List<dynamic>> _listenEventSocket = StreamController<List<dynamic>>();
  Stream<List<dynamic>> get listenNewEmit => _listenEventSocket.stream;

  ServiceSocket(){
    socket = IO.io('http://10.0.2.2:8000',
        IO.OptionBuilder()
            .setTransports(['websocket']).build());
    socket!.connect();
    socket!.onConnect((_) {
      print('connect');
      socket!.emit('msg', 'test');
      // socket!.emit('send-user-messenger', {messenger});  //phải thêm dấu {} để gửi data dạng obj
      // socket!.emit('send-user-id', id);   //emit gửi user_id đến cho server thêm vào array khi kết nối
    });

    // socket!.on('event', (data) => print('data from server: $data'));
    // socket!.on('broad-new-message', (data) => {
    //   print(data),
    //   _listenEventSocket.sink.add(data),
    // });
    socket!.onDisconnect((_) => print('disconnect'));

    createNewEmit.listen((event) {  //lắng nghe sự kiện của các screen bằng stream, sau đó emit sự kiện đó bằng socket (data emit lấy từ stream)
      // print(event);
      socket!.emit(event[0].toString(), event[1]);
    });
  }

  getSocket(){
    return socket;
  }

  connectToSocket() {
    if(socket != null){ return socket; }
    socket = IO.io('http://10.0.2.2:8000');
    socket!.connect();
    socket!.onConnect((data) => print('Conneted'));
  }

  //kết nối socket tới server
  void connectAndListen(String id, List<dynamic> messenger){
    socket = IO.io('http://10.0.2.2:8000',
        IO.OptionBuilder()
            .setTransports(['websocket']).build());
    socket!.connect();
    socket!.onConnect((_) {
      print('connect');
      socket!.emit('msg', 'test');
      socket!.emit('send-user-messenger', {messenger});  //phải thêm dấu {} để gửi data dạng obj
      socket!.emit('send-user-id', id);   //emit gửi user_id đến cho server thêm vào array khi kết nối
    });
    //When an event recieved from server, data is added to the stream
    socket!.on('event', (data) => streamSocket.addResponse);
    // socket!.on('broad-new-message', (data) => {
    //   print(data),
    //   _listenEventSocket.sink.add(data),
    // });
    socket!.onDisconnect((_) => print('disconnect'));
  }

  void addSink(List<dynamic> emit_data){
    _emitEventSocket.sink.add(emit_data);
  }

  void dispose(){
    _emitEventSocket.close();
  }

}
// IO.Socket socket = IO.io('http://10.0.2.2:8000');


class StreamSocket{
  final _socketResponse= StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose(){
    _socketResponse.close();
  }

}

StreamSocket streamSocket = StreamSocket();