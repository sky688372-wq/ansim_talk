import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {

  Future<void> getChats(String accessToken) async {
    final url = Uri.parse(
      'http://192.168.40.175:8000/api/v1/chats',
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'accept': 'application/json',
      },
    );

    print(response.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChats('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwiZXhwIjoxNzg3ODY3NzY2fQ._8E0eEyDKrCRR9TzF-vMVPm3amxPYwFH70w8Qb7DXJw');
  }
  
   
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
