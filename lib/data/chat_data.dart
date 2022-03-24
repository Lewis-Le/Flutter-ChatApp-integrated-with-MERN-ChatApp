//model của các messenger(group chat)

class Chat {
  // final String name, lastMessage, image, time;
  final bool isActive;

  final String? room_name, room_avatar, create_by, Id, created, time;
  final List? people, message, admin;

  Chat({
    // this.name = '',
    // this.lastMessage = '',
    // this.image = '',
    // this.time = '',
    // this.isActive = false,

    this.room_name = '',
    this.room_avatar = '',
    this.create_by = '',
    this.Id = '',
    this.created = '',
    this.people,
    this.message,
    this.admin,
    this.isActive = true,
    this.time = '',
  });

  factory Chat.fromJson(Map<String,dynamic> json) {
    return Chat(
      room_name: json['room_name'],
      message: json['message'],
      room_avatar: json['room_avatar'],
      time: '5m ago',
      isActive: true,
    );
  }

}

// List chatsData = [
//   Chat(
//     name: "Jenny Wilson",
//     lastMessage: "Hope you are doing well...",
//     image: "https://i.pravatar.cc/300",
//     time: "3m ago",
//     isActive: false,
//   ),
//   Chat(
//     name: "Esther Howard",
//     lastMessage: "Hello Abdullah! I am...",
//     image: "https://i.pravatar.cc/300",
//     time: "8m ago",
//     isActive: true,
//   ),
//   Chat(
//     name: "Ralph Edwards",
//     lastMessage: "Do you have update...",
//     image: "https://i.pravatar.cc/300",
//     time: "5d ago",
//     isActive: false,
//   ),
//   Chat(
//     name: "Jacob Jones",
//     lastMessage: "You’re welcome :)",
//     image: "https://i.pravatar.cc/300",
//     time: "5d ago",
//     isActive: true,
//   ),
//   Chat(
//     name: "Albert Flores",
//     lastMessage: "Thanks",
//     image: "https://i.pravatar.cc/300",
//     time: "6d ago",
//     isActive: false,
//   ),
//   Chat(
//     name: "Jenny Wilson",
//     lastMessage: "Hope you are doing well...",
//     image: "assets/images/user.png",
//     time: "3m ago",
//     isActive: false,
//   ),
//   Chat(
//     name: "Esther Howard",
//     lastMessage: "Hello Abdullah! I am...",
//     image: "assets/images/user_2.png",
//     time: "8m ago",
//     isActive: true,
//   ),
//   Chat(
//     name: "Ralph Edwards",
//     lastMessage: "Do you have update...",
//     image: "assets/images/user_3.png",
//     time: "5d ago",
//     isActive: false,
//   ),
// ];