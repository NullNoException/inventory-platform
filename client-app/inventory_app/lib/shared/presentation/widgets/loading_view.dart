import 'package:flutter/material.dart';

/// A reusable loading view that shows a centered circular progress indicator.
class LoadingView extends StatelessWidget {
  final String? message;
  final Color color;

  const LoadingView({Key? key, this.message, this.color = Colors.blue})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: color),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }
}
