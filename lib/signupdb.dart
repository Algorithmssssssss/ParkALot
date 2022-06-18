import 'package:flutter/material.dart';

class rtdb extends StatelessWidget {
  final String text;
  const rtdb({required this.text});

  rtdb.fromJson(Map<dynamic, dynamic> json) : text = json['text'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'text': "text",
      };

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
