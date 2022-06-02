import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../stream/socket.dart';
import '../data/server.dart';

class ProfileScreen extends StatefulWidget {
  static const route = '/profile';

  const ProfileScreen({
    Key? key,
    this.userData,
  }) : super(key: key);

  final userData; //data dạng obj của user hiện tại

  @override
  State<StatefulWidget> createState() {
    return ProfileScreenState(userData: userData);
  }
}

class ProfileScreenState extends State<StatefulWidget> {
  final formKey = GlobalKey<FormState>();
  ServiceSocket? socket = ServiceSocket(); //khai báo socket chung
  Server server = Server();

  ProfileScreenState({
    this.userData,
  });
  final userData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: buildAppBar(),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(),
          const SizedBox(height: 24),
          buildName(),
          const SizedBox(height: 24),
          buildAbout('Bio about me'),
          const SizedBox(height: 24),
          buildContact('Contact me'),
        ],
      ),
    );
  }

  AppBar buildAppBar() {  //không dùng
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white.withOpacity(0.4),
      // shadowColor: kPrimaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
      ),
      elevation: 0,
      title: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundImage: userData == null
                ? NetworkImage(
                    'data:image/png;base64,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')
                : NetworkImage(server.address_feed + '/' + userData['avatar']),
          ),
          SizedBox(
            width: 12,
          ),
          Text('Chat'),
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


  Widget buildName() => Column(
        children: [
          Text(
            userData['name'],
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            userData['main_email'],
            style: TextStyle(color: Colors.grey),
          )
        ],
      );


  Widget buildAbout(String bio) => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              bio,
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
            SizedBox(height: 5),
            Text(
              'Birth: ',
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
            SizedBox(height: 5),
            Text(
              'Education: ',
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
            SizedBox(height: 5),
            Text(
              'Work: ',
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );

  Widget buildContact(String bio) => Container(
    padding: EdgeInsets.symmetric(horizontal: 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Text(
          bio,
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
        SizedBox(height: 5),
        Text(
          'Email: ',
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
        SizedBox(height: 5),
        Text(
          'Phone: ',
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
        SizedBox(height: 5),
        Text(
          'Website: ',
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
        SizedBox(height: 5),
        Text(
          'Social: ',
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
      ],
    ),
  );


  Widget ButtonWidget() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: StadiumBorder(),
        onPrimary: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      ),
      child: Text('text'),
      onPressed: () => {},
    );
  }

  Widget ProfileWidget() {
    final color = Theme.of(context).colorScheme.primary;
    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color),
          ),
        ],
      ),
    );
  }
  Widget buildImage() {
    final image = userData==null ? NetworkImage(
        'https://exploringbits.com/wp-content/uploads/2021/11/anime-girl-15.jpg?ezimgfmt=rs:352x342/rscb3/ng:webp/ngcb3')
        : NetworkImage(server.address_feed + '/' + userData['avatar']);
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(onTap: () => {}),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: Icon(
            Icons.edit,
            color: Colors.white,
            size: 20,
          ),
        ),
      );
  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
