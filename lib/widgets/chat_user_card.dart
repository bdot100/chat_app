import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_user.dart';
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
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      // color: Colors.blue.shade100,
      elevation: 0.5,
      child: InkWell(
          onTap: () {},
          child: ListTile(
            // leading: CircleAvatar(
            //   child: Icon(CupertinoIcons.person),
            // ),
            leading: CachedNetworkImage(
              width: mq.height * .055,
              height: mq.height * .055,
              imageUrl: widget.user.image,
              // placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(CupertinoIcons.person),
            ),
            title: Text(widget.user.name),
            subtitle: Text(
              widget.user.about,
              maxLines: 1,
            ),
            trailing: Text(
              '12:00 PM',
              style: TextStyle(color: Colors.black54),
            ),
          )),
    );
  }
}
