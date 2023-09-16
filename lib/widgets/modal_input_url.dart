import 'package:flutter/material.dart';
import 'package:markdown_editor_plus/src/toolbar.dart';

class ModalInputUrl extends StatelessWidget {
  const ModalInputUrl({
    Key? key,
    required this.toolbar,
    required this.leftText,
    required this.selection,
    required this.sideButton,
    this.imageUri,
    this.onActionCompleted,
  }) : super(key: key);

  final Toolbar toolbar;
  final String leftText;
  final TextSelection selection;
  final bool sideButton;
  final Function? imageUri;
  final VoidCallback? onActionCompleted;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      padding: const EdgeInsets.all(30),
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Please provide a URL here or Choose a photo from your device.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  autocorrect: false,
                  autofocus: true,
                  cursorRadius: const Radius.circular(16),
                  decoration: const InputDecoration(
                    hintText: "Input your url.",
                    helperText: "example: https://example.com",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                  ),
                  style: const TextStyle(fontSize: 16),
                  enableInteractiveSelection: true,
                  onSubmitted: (String value) {
                    Navigator.pop(context);

                    /// check if the user entered an empty input
                    if (value.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            "Please input url",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: Colors.red.withOpacity(0.8),
                          duration: const Duration(milliseconds: 700),
                        ),
                      );
                    } else {
                      if (!value
                          .contains(RegExp(r'https?:\/\/(www.)?([^\s]+)'))) {
                        value = "http://$value";
                      }
                      toolbar.action(
                        "$leftText$value)",
                        "",
                        textSelection: selection,
                      );
                    }

                    onActionCompleted?.call();
                  },
                ),
              ),
              ...(sideButton && imageUri != null
                  ? [
                      const Text(" or "),
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          final value = imageUri!();
                          if (!value.isNull) {
                            toolbar.action(
                              "$leftText$value",
                              "",
                              textSelection: selection,
                            );
                          }
                          onActionCompleted?.call();
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.upload_file),
                            Text("Upload photo"),
                          ],
                        ),
                      )
                    ]
                  : [Container()])
            ],
          ),
        ],
      ),
    );
  }
}
