import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:superchat/model/message.dart';
import 'package:superchat/pages/home.dart';

class ChatPage extends StatefulWidget {
  final String userId;
  final String userName;
  const ChatPage({
    super.key,
    required this.userId,
    required this.userName,
    });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final CollectionReference _messagesCollection = FirebaseFirestore.instance.collection('messages');
  User? user = FirebaseAuth.instance.currentUser;
  late Stream<QuerySnapshot> _messageStream;

  TextEditingController _messageController = new TextEditingController();
  List<Message> filteredMessages = [];

  void listenToMessages() {
    _messagesCollection.snapshots().listen((QuerySnapshot snapshot) {
      List<Message> newMessages = [];
      for (var message in snapshot.docs) {
        var messageData = message.data() as Map<String, dynamic>;
        if ((messageData['from'] == user!.uid && messageData['to'] == widget.userId) ||
            (messageData['from'] == widget.userId && messageData['to'] == user!.uid)) {
          newMessages.add(Message.fromJson(messageData));
        }
      }
      setState(() {
        filteredMessages = newMessages;
      });
      print(filteredMessages.length);
      // Print the filtered messages to the console
      for (Message msg in filteredMessages) {
        print("From: ${msg.from}, To: ${msg.to}, Content: ${msg.content}");
      }
    });
  }


  @override 
  void initState(){
    super.initState();
    listenToMessages();
  }

  @override
  Widget build (BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFF553370),
      resizeToAvoidBottomInset: true,
      body: Container(
        margin: EdgeInsets.only(top : 50.0, left: 20.0, right: 20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) => const Home())), 
                    icon: Icon(Icons.arrow_back_ios_new_outlined, color: Color(0Xffc199cd),),),
                  SizedBox(width: 40.0,),
                  Text("chat with ${widget.userName}",
                      style: TextStyle(color : Color.fromARGB(255, 219, 177, 232),
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500),),
                ],
            ),
            ),
            
            SizedBox(height: 20.0,),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0, bottom: 20.0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/1.20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0)),
                ),
                child: filteredMessages.isEmpty ?
                Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // To center the column itself
                        children: [
                          Text(
                            "No Messages Yet In This Discussion \nStart the Conversation below",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "😊", // Smiling emoji
                            style: TextStyle(
                              fontSize: 24.0, // Emoji size
                            ),
                          ),
                        ],
                      ),
                    )
                      :
                ListView.builder(
                  itemCount: filteredMessages.length,
                  itemBuilder: (context, index) {
                    Message message = filteredMessages[index];
                    bool isSentByCurrentUser = message.from == user!.uid ;
                    return Container(
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.only(
                        left: isSentByCurrentUser ? MediaQuery.of(context).size.width/2 : 0,
                        right: isSentByCurrentUser ? 0 : MediaQuery.of(context).size.width/2,
                        bottom: 5.0,
                      ),
                      alignment: isSentByCurrentUser ? Alignment.bottomRight : Alignment.bottomLeft,
                      decoration: BoxDecoration(
                            color: isSentByCurrentUser ? Color.fromARGB(255, 207, 211, 217) : Color.fromARGB(255, 196, 210, 230),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: isSentByCurrentUser ? Radius.circular(10) : Radius.zero,
                              bottomRight: isSentByCurrentUser ? Radius.zero : Radius.circular(10),
                            ),
                      ),
                      child: Text(message.content ?? '',
                      style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w500),),
                      );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 10),
              child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _messageController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Type Your Message here ...",
                                            hintStyle: TextStyle(color: Colors.black45)),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(color: Color(0xFFf3f3f3), borderRadius: BorderRadius.circular(60)),
                                        child: Center(
                                          child: ElevatedButton(
                                            onPressed: _sendMessage,
                                            child: Icon(Icons.send, color: Color.fromARGB(255, 168, 166, 166),),) ,
                                          )
                                           
                                      ),
                                      
                            ]),
                          ),
                      ),
            ),
        ],
      ),
      ),
    );
  }

   void _sendMessage() {
    String messageText = _messageController.text.trim();
    User? user = FirebaseAuth.instance.currentUser;
    if (messageText.isNotEmpty) {
      _messagesCollection.add({
        'from': user?.uid,
        'to': widget.userId,
        'content': messageText,
        'timestamp': FieldValue.serverTimestamp(),
      }).then((_) {
        print('Message sent: $messageText');
        _messageController.clear();
      }).catchError((error) {
        print('Error sending message: $error');
        // Ajoutez ici la gestion des erreurs d'envoi du message à Firestore
      });
    }
  }
}

