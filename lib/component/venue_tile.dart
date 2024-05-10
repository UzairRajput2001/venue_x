// //ignore_for_file: prefer_interpolation_to_compose_strings

// import 'package:flutter/material.dart';
// import 'package:untitled1/component/Venue.dart';


// class VenueTile extends StatelessWidget {
//   final Venue venue;
//   const VenueTile({
//     super.key,
//     required this.venue
//   });


//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         children: [
//           Image.asset(
//             Venue.imagePath,
//             height: 140
//             ),

//           Text(
//             Venue.name,
//             style: TextStyle(fontSize: 20),
//           ),

//           //CAPACITY+RAting
//           SizedBox(width: 160,
//           child: Row(children: [

//             //CAPACITY
//           Text('\$' + Venue.capacity),

//             //RATING

//           Icon(Icons.star),
//           Text(Venue.rating),

//           ],
//         ),
//       ),
        
//         ],
//       ),
//     );
//   }
// }


