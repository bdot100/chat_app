import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/api/apis.dart';
import 'package:chat_app/helper/my_date_util.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    // last message info (if null --> no message)
    Message? _message;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      // color: Colors.blue.shade100,
      elevation: 0.5,
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(
                          user: widget.user,
                        )));
          },
          child: StreamBuilder(
              stream: APIs.getLastMessage(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;

                final list = data
                        ?.map((e) =>
                            Message.fromJson(e.data() as Map<String, dynamic>))
                        .toList() ??
                    [];

                if (list.isNotEmpty) _message = list[0];

                return ListTile(
                  // user profile pic
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .3),
                    child: CachedNetworkImage(
                      width: mq.height * .055,
                      height: mq.height * .055,
                      imageUrl: widget.user.image,
                      errorWidget: (context, url, error) =>
                          CircleAvatar(child: Icon(CupertinoIcons.person)),
                    ),
                  ),

                  // username
                  title: Text(widget.user.name),

                  // last message
                  subtitle: Text(
                    _message != null ? _message!.msg : widget.user.about,
                    maxLines: 1,
                  ),

                  // last message time
                  trailing: _message == null
                      ? null //show nothing when no message is sent
                      : _message!.read.isEmpty &&
                              _message!.fromId != APIs.user.uid
                          ?
                          // show for unread message
                          Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                  color: Colors.greenAccent.shade400,
                                  borderRadius: BorderRadius.circular(10)),
                            )
                          :
                          // message sent time
                          Text(
                              MyDateUtil.getLastMessageTime(
                                  context: context, time: _message!.sent),
                              style: TextStyle(color: Colors.black54),
                            ),
                );
              })),
    );
  }
}
