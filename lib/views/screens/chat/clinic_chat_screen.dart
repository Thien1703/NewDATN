// import 'package:flutter/material.dart';
// import 'package:health_care/config/app_config.dart';
// import 'package:health_care/models/clinic.dart';
// import 'package:health_care/viewmodels/api/clinic_api.dart';
// import 'package:health_care/views/screens/chat/chat_screen.dart';

// class ClinicChatScreen extends StatefulWidget {
//   const ClinicChatScreen({super.key});

//   @override
//   State<ClinicChatScreen> createState() => _ClinicChatScreenState();
// }

// class _ClinicChatScreenState extends State<ClinicChatScreen> {
//   List<Clinic> clinics = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchClinics();
//   }

//   Future<void> _fetchClinics() async {
//     final result = await ClinicApi.getAllClinic();
//     setState(() {
//       clinics = result;
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("🩺 Chọn phòng khám để chat")),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : clinics.isEmpty
//               ? const Center(child: Text("Không có phòng khám nào."))
//               : ListView.separated(
//                   itemCount: clinics.length,
//                   separatorBuilder: (_, __) => Divider(height: 1),
//                   itemBuilder: (context, index) {
//                     final clinic = clinics[index];
//                     return ListTile(
//                       leading: CircleAvatar(
//                         backgroundImage: NetworkImage(clinic.image),
//                         radius: 24,
//                       ),
//                       title: Text(clinic.name),
//                       subtitle: Text(clinic.address),
//                       trailing: const Icon(Icons.chevron_right),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => ChatScreen(
//                               clinicId: clinic.id,
//                               clinicName: clinic.name,
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//     );
//   }
// }
