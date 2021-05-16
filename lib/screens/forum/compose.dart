import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/models/documents/document.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:flutter_quill/widgets/toolbar.dart';
import 'package:subb_front/utils/network.dart';
import 'package:flutter_quill/widgets/controller.dart';

class ComposeScreen extends StatefulWidget {
  static const routeName = '/compose';
  @override
  _ComposeScreenState createState() => _ComposeScreenState();
}

class _ComposeScreenState extends State<ComposeScreen> {
  QuillController? _quillController;
  late final _titleController;
  // TODO: fix focus bug
  late FocusNode _focusNode;

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

  void _newThread() async {
    SnackBar snackBar = SnackBar(content: Text('No title!'));

    String forumID = '1';
    // String title = 'demo title 3';
    if (_titleController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final queryParams = {
      'forum_id': forumID,
      'title': _titleController.text,
    };
    final b = await compute(
        jsonEncode, _quillController!.document.toDelta().toJson());

    final apiResponse =
        await doPost('small_talk_api/new_thread/', queryParams, b);

    if (apiResponse != null) {
      // print('code: ${apiResponse.code}');
      // print('message: ${apiResponse.message}');
      // print('data: ${apiResponse.data}');
      snackBar = SnackBar(content: Text('Thread created'));
    } else {
      snackBar = SnackBar(content: Text('Thread created failed'));
      // print("_signIn() error, null apiResponse");
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
      body: SafeArea(
          child: Column(
        children: [
          QuillToolbar.basic(controller: _quillController!),
          Expanded(
            child: Column(children: <Widget>[
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Title'),
                controller: _titleController,
                autofocus: true,
              ),
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
        onPressed: _newThread,
        child: Icon(Icons.send),
      ),
    );
  }
}
