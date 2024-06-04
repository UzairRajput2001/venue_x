// import 'package:flutter/material.dart';
// import 'package:venue_x/Admin/AdminChatScreen.dart';

// class ChatScreen extends StatefulWidget {
//   const ChatScreen(String venueName, {super.key});

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final List<ChatMessage> _messages = <ChatMessage>[];
//   final TextEditingController _textController = TextEditingController();

//   final List<String> _venueOwners = ['Venue Owner 1', 'Venue Owner 2']; // List of venue owners

//   String? _selectedVenueOwner; // Currently selected venue owner

//   void _handleSubmitted(String text) {
//     _textController.clear();
//     ChatMessage message = ChatMessage(
//       text: text,
//       isUser: true, // The message is from the user
//     );
//     setState(() {
//       _messages.insert(0, message);
//     });
//   }

//   Widget _buildTextComposer() {
//     return IconTheme(
//       data: const IconThemeData(color: Colors.blue),
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 8.0),
//         child: Row(
//           children: <Widget>[
//             Flexible(
//               child: TextField(
//                 controller: _textController,
//                 onSubmitted: _handleSubmitted,
//                 decoration: const InputDecoration.collapsed(
//                   hintText: "Send a message",
//                 ),
//               ),
//             ),
//             IconButton(
//               icon: const Icon(Icons.send),
//               onPressed: () => _handleSubmitted(_textController.text),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildVenueOwnersList() {
//     return ListView.builder(
//       itemCount: _venueOwners.length,
//       itemBuilder: (context, index) {
//         return ListTile(
//           title: Text(_venueOwners[index]),
//           onTap: () {
//             setState(() {
//               _selectedVenueOwner = _venueOwners[index];
//             });
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: _selectedVenueOwner != null
//             ? Text('Chat with $_selectedVenueOwner')
//             : const Text('Select a Venue Owner'),
//       ),
//       body: _selectedVenueOwner != null
//           ? Column(
//               children: <Widget>[
//                 Flexible(
//                   child: ListView.builder(
//                     padding: const EdgeInsets.all(8.0),
//                     reverse: true,
//                     itemBuilder: (_, int index) => _messages[index],
//                     itemCount: _messages.length,
//                   ),
//                 ),
//                 const Divider(height: 1.0),
//                 Container(
//                   decoration:
//                       BoxDecoration(color: Theme.of(context).cardColor),
//                   child: _buildTextComposer(),
//                 ),
//               ],
//             )
//           : _buildVenueOwnersList(),
//     );
//   }
// }

// class ChatMessage extends StatelessWidget {
//   final String text;
//   final bool isUser;

//   const ChatMessage({super.key, required this.text, required this.isUser});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           isUser ? const CircleAvatar() : Container(),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: Column(
//                 crossAxisAlignment: isUser
//                     ? CrossAxisAlignment.end
//                     : CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     isUser ? 'You' : 'Venue Owner',
//                     style: Theme.of(context).textTheme.titleSmall,
//                   ),
//                   Container(
//                     margin: const EdgeInsets.only(top: 5.0),
//                     child: Text(text),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           isUser ? Container() : const CircleAvatar(),
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:venue_x/model.dart/OwnerModel.dart';
import 'package:venue_x/model.dart/venue_model.dart';

class ChatScreen extends StatefulWidget {
  final String venueName;

  const ChatScreen(this.venueName, {Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();

  List<String> _venueOwners = [
    'Venue Owner 1',
    'Venue Owner 2'
  ]; // List of venue owners

  String? _selectedVenueOwner; // Currently selected venue owner
  bool _chatEnabled = false; // Flag to track if chat is enabled

  Future<List<String>> _getVenueAdmin() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Fetch user requests
    final userRequestsSnapshot = await FirebaseFirestore.instance
        .collection('bookingRequests')
        .where("userId", isEqualTo: userId)
        .get();

    final List<String> venueNames = userRequestsSnapshot.docs
        .map((doc) => doc.data()["venueName"].toString())
        .toList();

    if (venueNames.isEmpty) {
      return [];
    }

    // Fetch venues for all venue names in one go
    final venueSnapshot = await FirebaseFirestore.instance
        .collection('venues')
        .where("name", whereIn: venueNames)
        .get();

    if (venueSnapshot.docs.isEmpty) {
      return [];
    }

    // Map venue names to owner IDs
    final Map<String, String> venueToOwnerId = {};
    for (var venueDoc in venueSnapshot.docs) {
      final venueData = venueDoc.data();
      venueToOwnerId[venueData["name"]] = Venues.fromMap(venueData).userId;
    }

    // Fetch owner details for all owner IDs in one go
    final ownerIds = venueToOwnerId.values.toSet().toList();
    final ownerSnapshot = await FirebaseFirestore.instance
        .collection('venueOwners')
        .where(FieldPath.documentId, whereIn: ownerIds)
        .get();

    final Set<String> chatVenues = {};
    for (var ownerDoc in ownerSnapshot.docs) {
      chatVenues.add(ownerDoc.get('name'));
    }

    return chatVenues.toList();
  }

  @override
  Widget build(BuildContext context) {
    _getVenueAdmin().then((value) => setState(() {
      _venueOwners=value;
    }) );
    return Scaffold(
      appBar: AppBar(
        title: _selectedVenueOwner != null
            ? Text('Chat with $_selectedVenueOwner')
            : const Text('Select a Venue Owner'),
      ),
      body: _chatEnabled
          ? Column(
              children: <Widget>[
                Flexible(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    reverse: true,
                    itemBuilder: (_, int index) => _messages[index],
                    itemCount: _messages.length,
                  ),
                ),
                const Divider(height: 1.0),
                Container(
                  decoration: BoxDecoration(color: Theme.of(context).cardColor),
                  child: _buildTextComposer(),
                ),
              ],
            )
          : _buildVenueOwnersList(),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: const IconThemeData(color: Colors.blue),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                enabled: _chatEnabled, // Enable/disable based on chat state
                decoration: const InputDecoration.collapsed(
                  hintText: "Send a message",
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _chatEnabled
                  ? () => _handleSubmitted(_textController.text)
                  : null, // Enable/disable based on chat state
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVenueOwnersList() {
    return ListView.builder(
      itemCount: _venueOwners.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_venueOwners[index]),
          onTap: () {
            null;
            setState(() {
              _selectedVenueOwner = _venueOwners[index];
              _chatEnabled = true; // Enable chat when a venue owner is selected
            });
          },
        );
      },
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = ChatMessage(
      text: text,
      isUser: true, // The message is from the user
    );
    setState(() {
      _messages.insert(0, message);
    });
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({Key? key, required this.text, required this.isUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          isUser ? const CircleAvatar() : Container(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment:
                    isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    isUser ? 'You' : 'Venue Owner',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Text(text),
                  ),
                ],
              ),
            ),
          ),
          isUser ? Container() : const CircleAvatar(),
        ],
      ),
    );
  }
}
