import 'package:flutter/material.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    child:
                    Row(
                      children: [
                        Icon(Icons.label),
                        Text('HOME')
                      ],
                    ),
                  ),
                  Container(
                    child:
                    Row(
                      children: [
                        Icon(Icons.label),
                        Text('HOME')
                      ],
                    ),
                  ),
                  Container(
                    child:
                    Row(
                      children: [
                        Icon(Icons.label),
                        Text('HOME')
                      ],
                    ),
                  ),
                  Container(
                    child:
                    Row(
                      children: [
                        Icon(Icons.label),
                        Text('HOME')
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(),
            ),
          ],
        ),
      ),
    );
  }
}
