import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/models/documents/document.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:flutter_quill/widgets/toolbar.dart';
import 'package:subb_front/models/thread.dart';
import 'package:subb_front/utils/api_collection.dart';
import 'package:flutter_quill/widgets/controller.dart';

class ComposePostScreen extends StatefulWidget {
  static const routeName = '/compose_post';

  final Thread thread;

  ComposePostScreen(this.thread);

  @override
  _ComposePostScreenState createState() => _ComposePostScreenState(thread);
}

class _ComposePostScreenState extends State<ComposePostScreen> {
  QuillController? _quillController;
  late final _titleController;
  // TODO: fix focus bug
  late FocusNode _focusNode;

  final Thread thread;

  _ComposePostScreenState(this.thread);

  Future<void> _loadFromAssets() async {
    try {
      final result = await rootBundle.loadString('assets/sample_data.json');
      final doc = Document.fromJson(jsonDecode(result));
      setState(() {
        _quillController = QuillController(
            document: doc, selection: const TextSelection.collapsed(offset: 0));
      });
    } catch (error) {
      final doc = Document()..insert(0, 'Empty asset');
      setState(() {
        _quillController = QuillController(
            document: doc, selection: const TextSelection.collapsed(offset: 0));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _titleController = TextEditingController();
    _loadFromAssets();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _newPost() async {
    SnackBar snackBar = SnackBar(content: Text('No title!'));

    final apiResponse = await newPost(
      threadId: thread.threadId.toString(), 
      content: await compute(
        jsonEncode, _quillController!.document.toDelta().toJson()));

    if (apiResponse != null) {
      snackBar = SnackBar(content: Text('Post created'));
    } else {
      snackBar = SnackBar(content: Text('Post created failed'));
    }

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_quillController == null) {
      return const Scaffold(body: Center(child: Text('Loading...')));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Writing Post: ${thread.title}"),
      ),
      body: SafeArea(
          child: Column(
        children: [
          QuillToolbar.basic(controller: _quillController!),
          Expanded(
            child: Column(children: <Widget>[
              QuillEditor(
                controller: _quillController!,
                readOnly: false,
                autoFocus: true,
                focusNode: _focusNode,
                scrollController: ScrollController(),
                scrollable: true,
                expands: false,
                padding: EdgeInsets.only(top: 4),
                // embedBuilder: defaultEmbedBuilderWeb,
              ),
            ]),
          )
        ],
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff03dac6),
        foregroundColor: Colors.black,
        // onPressed: _sendNewPost,
        onPressed: _newPost,
        child: Icon(Icons.send),
      ),
    );
  }
}
