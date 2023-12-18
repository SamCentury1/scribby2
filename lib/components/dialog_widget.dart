import 'package:flutter/material.dart';

class DialogWidget extends StatelessWidget {
  final String title;
  final Widget content;
  final Widget? button;
  // final ButtonStyle button;
  // final VoidCallback? onSelected;
  const DialogWidget(
    Key? key, 
    this.title, 
    this.content, 
    this.button,
    // {this.onSelected}
  ): super(key: key);

  @override
  Widget build(BuildContext context) {
        return Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: const Color.fromARGB(216, 141, 227, 233),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 32,
                        ),
                      ),
                      const Divider(
                        color:  Color.fromARGB(255, 90, 90, 90),
                        height:2,
                      )
                    ],
                  ),
                )
              )
            ),
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                color: const Color.fromARGB(216, 141, 227, 233),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: content
                )
              )
            ),
            button ?? const SizedBox()                         
          ],
        );
  }
}