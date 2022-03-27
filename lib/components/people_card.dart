import 'package:flutter/material.dart';
import '../data/server.dart';
import '../theme/colour.dart';

class PeopleCard extends StatelessWidget {
  PeopleCard({
    Key? key,
    this.people_data,
    this.press,
  }) : super(key: key);

  // final Chat? chat;
  final VoidCallback? press;
  final people_data;
  Server server = Server();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.75),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(server.address+'/'+people_data['avatar']),
                ),
                if (true)   //kiểm tra trạng thái user có đang active hay không(do model trong database chưa có trường isActive nên tạm thời cho true)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
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
                const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      people_data['name'],
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 8),
                    Opacity(
                      opacity: 0.64,
                      child: Text(
                        'work at ...',   //last message trong group
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Opacity(
              opacity: 0.64,
              child: Text('offline'),
            ),
          ],
        ),
      ),
    );
  }
}