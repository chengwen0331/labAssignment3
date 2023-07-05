
import 'package:barterit_application/model/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:grouped_list/grouped_list.dart';

class ChatScreen extends StatefulWidget {
  final User user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late List<Widget> tabchildren;
  String maintitle = "Messenger";
  List<Message> messages = [
    Message(
      text:'Yes sure!',
      date: DateTime.now().subtract(Duration(minutes: 1)),
      isSentByMe: false,
    ),
    Message(
      text:'OK!',
      date: DateTime.now().subtract(Duration(minutes: 1)),
      isSentByMe: false,
    ),
    Message(
      text:'OK!',
      date: DateTime.now().subtract(Duration(minutes: 1)),
      isSentByMe: true,
    ),
  ].reversed.toList();

  @override
  void initState() {
      super.initState();
      print("Chat");
  }
  
  void _addMessage(String text) {
    final message = Message(
      text: text,
      date: DateTime.now(),
      isSentByMe: true,
    );
    setState(() => messages.add(message));
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Messenger'),
          backgroundColor: Colors.amber,
        ),
        body: Column(
          children: [
            Expanded(
              child: GroupedListView<Message, DateTime>(
                padding: const EdgeInsets.all(8),
                reverse:true,
                order:GroupedListOrder.DESC,
                useStickyGroupSeparators:true,
                floatingHeader:true,
                elements:messages,
                groupBy:(message) => DateTime(
                  message.date.year,
                  message.date.month,
                  message.date.day,
                ),
                groupHeaderBuilder:(Message message) => SizedBox(
                  height:40,
                  child:Center(
                    child: Card(
                      color:Theme.of(context).primaryColor,
                      child:Padding(
                        padding: const EdgeInsets.all(8),
                        child:Text(
                          DateFormat.yMMMd().format(message.date),
                          style:const TextStyle(color:Colors.white),
                        )
                      )
                    ),
                  )
                ),
                
                /*itemBuilder: (context, Message message) => Align(
                  alignment: message.isSentByMe
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                  child: Card(
                    elevation: 8,
                    child:Padding(
                      padding: const EdgeInsets.all(12),
                      child:Text(message.text),
                    )
                  )
                ),*/
                itemBuilder: (context, Message message) => 
                MessageBubble(message:message),
              ),
              
            ),
          
            NewMessageWidget(
                /*onSubmitted:(text){
                  final message = Message(
                    text:text,
                    date:DateTime.now(),
                    isSentByMe: true,
                  );
                  setState(() =>messages.add(message));
                }*/
                onSubmitted: (text) => _addMessage(text),
              ),
              /*Container(
                  color:Colors.grey.shade200,
                  child:NewMessageWidget(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(12),
                      hintText: 'Type your message here...'
                    ),
                    onSubmitted:(text){
                  final message = Message(
                    text:text,
                    date:DateTime.now(),
                    isSentByMe: true,
                  );
                  setState(() =>messages.add(message));
                }
                  )
                )*/
            
          ],
        ),
      ),
    );
  }
}

class Message{
  final String text;
  final DateTime date;
  final bool isSentByMe;

  const Message({
    required this.text,
    required this.date,
    required this.isSentByMe,
  });
}

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: message.isSentByMe ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isSentByMe ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class NewMessageWidget extends StatelessWidget {
  final Function(String) onSubmitted;

  const NewMessageWidget({required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();

    void handleSubmit() {
      String text = textController.text.trim();
      if (text.isNotEmpty) {
        onSubmitted(text);
        textController.clear();
      }
    }

    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              decoration: const InputDecoration(
                hintText: 'Type your message here...',
              ),
              onSubmitted: (_) => handleSubmit(),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: handleSubmit,
          ),
        ],
      ),
    );
  }
}