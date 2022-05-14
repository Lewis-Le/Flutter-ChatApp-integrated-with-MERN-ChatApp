import '../data/message_data.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../theme/colour.dart';
import '../data/server.dart';
import '../ui/viewer_screen.dart';

class FileMessage extends StatefulWidget {
  final message;
  final bool? isSender;

  FileMessage({
    Key? key,
    this.message,
    this.isSender,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FileMessageState(message: message, isSender: isSender);
  }
}

class FileMessageState extends State<StatefulWidget> {   //message truyền vào là dạng obj của 1 tin nhắn
  FileMessageState({
    Key? key,
    this.message,
    this.isSender,
  });

  // final ChatMessage? message;
  final message;
  final bool? isSender;

  final AudioPlayer audioPlayer = AudioPlayer();
  final Server server = Server();
  Duration duration = Duration();
  Duration postion = Duration();
  bool playing = false;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: double.infinity, maxWidth: MediaQuery.of(context).size.width * 0.7),
      // width: MediaQuery.of(context).size.width * 0.45, // 45% of total width
      child: AspectRatio(
        aspectRatio: 2.6,
        child: Container(
          // width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height,
          // padding: EdgeInsets.symmetric(horizontal: 19.0, vertical: 7.0),
          decoration: BoxDecoration(
            // color: kPrimaryColor,
            // shape: BoxShape.circle,
            border: Border.all(
              color: kPrimaryColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: ListView.builder(
            itemCount: message['files'].length,
            itemBuilder: (context, index) =>
                DisplayListFile(message['files'][index], context),
          ),
        ),
      ),
    );
  }


  Widget DisplayListFile(String url, BuildContext context){
    return GestureDetector(
      onTap: () {
      print('tap file');
      if (url.contains('.mp3')) {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.music_note),
                          Expanded(child: Text(url)),
                        ],
                      ),
                      // Center(child: InkWell(
                      //   onTap: () {
                      //     getAudio(),
                      //   },
                      //   child: Icon(
                      //     playing==false ? Icons.play_circle_outlined : Icons.pause_circle_outline,
                      //   ),
                      // ),),
                      SliderMusic(),
                      InkWell(
                        onTap: () => getAudio(url),
                        child: Icon(
                          playing == false ? Icons.play_circle_outline : Icons.pause_circle_outline
                        ),
                      ),
                      Center(
                        child: ElevatedButton(
                          child: Text('Đóng'),
                          onPressed: () =>
                          {
                            Navigator.pop(context),
                          },
                        ),
                      )
                    ],
                  ),
                )
              );
            }
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewerScreen(
              url: url,
              messId: message['Id'],
            ),
          ),
        );
      }
      }, // Image tapped
        child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Row(
              children: [
                (url.contains('.mp3')) ? Icon(Icons.music_note) : Icon(Icons.file_copy),
                Text(url),
              ],
            )
        )
    );
  }

  Widget SliderMusic(){
    return Slider.adaptive(
        value: postion.inSeconds.toDouble(),
        max: duration.inSeconds.toDouble(),
        onChanged: (double value) {
          setState(() {
            audioPlayer.seek(new Duration(seconds: value.toInt()));
          });
        }
    );
  }

  void getAudio(String url) async {
    if(playing){
      var res = await audioPlayer.pause();
      if(res == 1){
        setState(() {
          playing = false;
        });
      }
    } else {
      var res = await audioPlayer.play(server.address+'/rooms/'+message['Id']+'/files$url', isLocal: true);
      if(res == 1){
        setState(() {
          playing = true;
        });
      }
    }
    audioPlayer.onDurationChanged.listen((Duration dd) {
      setState(() {
        duration = dd;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((Duration dd) {
      setState(() {
        postion = dd;
      });
    });
  }

}