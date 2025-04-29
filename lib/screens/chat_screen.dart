import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/api/apis.dart';
import 'package:chat_app/helper/my_date_util.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/screens/view_profile_screen.dart';
import 'package:chat_app/widgets/message_card.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // this list is for storing all messages
  List<Message> _list = [];

  // this is for handling message text changes
  final _textController = TextEditingController();

  // showEmoji -- for storing value of showing or hiding emoji
  // isUploading -- for checking if image is still uploading or not
  bool _showEmoji = false, _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        // ignore: deprecated_member_use
        child: WillPopScope(
          // if emojis are shown and back button is pressed, then hide emojis and
          // or else simply close the current screen on back button click
          onWillPop: () {
            if (_showEmoji) {
              setState(() {
                _showEmoji = !_showEmoji;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            // app Bar
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
            ),

            backgroundColor: Color.fromARGB(255, 234, 248, 255),

            // body
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: APIs.getAllMessages(widget.user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        // data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const Center(
                            child: SizedBox(),
                          );

                        // if some or all data is loaded then show it
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          _list = data
                                  ?.map((e) => Message.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                                reverse: true,
                                itemCount: _list.length,
                                padding: EdgeInsets.only(top: mq.height * .01),
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return MessageCard(message: _list[index]);
                                });
                          } else {
                            return Center(
                              child: Text(
                                "Say Hi! 👋🏾",
                                style: TextStyle(fontSize: 20),
                              ),
                            );
                          }
                      }
                    },
                  ),
                ),

                // progress indicator for showing uploading
                if (_isUploading)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),

                //chat input field
                _chatInput(),

                // show emoji on keyboard emoji click and vice versa
                if (_showEmoji)
                  SizedBox(
                    height: mq.height * .35,
                    child: EmojiPicker(
                      textEditingController:
                          _textController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                      config: Config(
                        height: 256,
                        checkPlatformCompatibility: true,
                        emojiViewConfig: EmojiViewConfig(
                          // Issue: https://github.com/flutter/flutter/issues/28894
                          emojiSizeMax: 28 * (Platform.isIOS ? 1.20 : 1.0),
                          backgroundColor: Color.fromARGB(255, 234, 248, 255),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // app bar widget
  Widget _appBar() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ViewProfileScreen(user: widget.user)));
      },
      child: StreamBuilder(
          stream: APIs.getUserInfo(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;

            final list =
                data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

            return Row(
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
                    imageUrl:
                        list.isNotEmpty ? list[0].image : widget.user.image,
                    // placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        Icon(CupertinoIcons.person),
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
                      list.isNotEmpty ? list[0].name : widget.user.name,
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
                      list.isNotEmpty
                          ? list[0].isOnline
                              ? 'Online'
                              : MyDateUtil.getLastActiveTime(
                                  context: context,
                                  lastActive: list[0].lastActive)
                          : MyDateUtil.getLastActiveTime(
                              context: context,
                              lastActive: widget.user.lastActive),
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                )
              ],
            );
          }),
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
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() => _showEmoji = !_showEmoji);
                    },
                    icon: Icon(
                      Icons.emoji_emotions,
                      color: Colors.blueAccent,
                    )),

                // text field
                Expanded(
                    child: TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onTap: () {
                    if (_showEmoji) setState(() => _showEmoji = !_showEmoji);
                  },
                  decoration: InputDecoration(
                      hintText: "Type something...",
                      hintStyle: TextStyle(color: Colors.blueAccent),
                      border: InputBorder.none),
                )),

                // pick image from gallery button
                IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();

                      // Picking multiple images
                      final List<XFile> images =
                          await picker.pickMultiImage(imageQuality: 70);

                      // uploading and sending image one by one
                      for (var i in images) {
                        log('Image Path: ${i.path}');
                        setState(() => _isUploading = true);
                        await APIs.sendChatImage(widget.user, File(i.path));
                        setState(() => _isUploading = false);
                      }
                    },
                    icon: Icon(
                      Icons.image,
                      color: Colors.blueAccent,
                      size: 26,
                    )),

                // take image from camera button
                IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 70);

                      if (image != null) {
                        log('Image Path: ${image.path}');
                        setState(() => _isUploading = true);
                        await APIs.sendChatImage(widget.user, File(image.path));
                        setState(() => _isUploading = false);
                      }
                    },
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
          onPressed: () {
            if (_textController.text.isNotEmpty) {
              APIs.sendMessage(widget.user, _textController.text, Type.text);
              _textController.text = '';
            }
          },
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
