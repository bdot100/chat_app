import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // app Bar
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),

        // body
        body: Column(
          children: [_chatInput()],
        ),
      ),
    );
  }

  // app bar widget
  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          // back button
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black54,
              )),

          // user profile picture
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .3),
            child: CachedNetworkImage(
              width: mq.height * .05,
              height: mq.height * .05,
              imageUrl: widget.user.image,
              // placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(CupertinoIcons.person),
            ),
          ),

          // add some space
          const SizedBox(
            width: 10,
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // username
              Text(
                widget.user.name,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
              ),

              // add some space
              const SizedBox(
                width: 2,
              ),

              // last seen time of user
              Text(
                'Last seen not available',
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500),
              ),
            ],
          )
        ],
      ),
    );
  }

  // bottom chat input field
  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .01, horizontal: mq.width * .025),
      child: Row(children: [
        // input field and button
        Expanded(
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                // emoji button
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.emoji_emotions,
                      color: Colors.blueAccent,
                    )),

                const Expanded(
                    child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                      hintText: "Type something...",
                      hintStyle: TextStyle(color: Colors.blueAccent),
                      border: InputBorder.none),
                )),

                // pick image from gallery button
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.image,
                      color: Colors.blueAccent,
                      size: 26,
                    )),

                // take image from camera button
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.blueAccent,
                      size: 26,
                    )),

                // add some space
                SizedBox(
                  width: mq.width * .02,
                ),
              ],
            ),
          ),
        ),

        // send button
        MaterialButton(
          onPressed: () {},
          minWidth: 0,
          padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
          shape: CircleBorder(),
          color: Colors.green,
          child: Icon(
            Icons.send,
            color: Colors.white,
            size: 28,
          ),
        )
      ]),
    );
  }
}
