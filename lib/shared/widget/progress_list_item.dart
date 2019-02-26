import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProgressListItem extends StatelessWidget {
  @override
  Widget build(context) => Padding(
        padding: EdgeInsets.all(8),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
}
