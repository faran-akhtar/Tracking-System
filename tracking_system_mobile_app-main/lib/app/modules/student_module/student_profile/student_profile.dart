import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../styles/style.dart';

class StudentProfile extends StatelessWidget {
  const StudentProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue.shade600,
        centerTitle: true,
        title: Text(
          'Profile',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: FlutterTextTheme.lightTextTheme.headline4?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30.h,
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("StudentData")
                .where("studentUserId",
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (
              context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
            ) {
              var data = snapshot.data!.docs[0].data();
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Card(
                      child: ListTile(
                        title: const Text(
                          "Name:",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          data["studentName"],
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text(
                          "Father Name:",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          data["fatherName"],
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text(
                          "Email:",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          data["email"],
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text(
                          "Roll No:",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          data["rollNo"],
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text(
                          "Semester:",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          data["semester"],
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text(
                          "Address:",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        trailing: SizedBox(
                          width: 150,
                          child: Text(
                            data["pickupAddress"],
                            style: const TextStyle(
                                color: Colors.black,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text(
                          "Phone No:",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          data["phoneNumber"],
                          style: const TextStyle(
                              color: Colors.black,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
