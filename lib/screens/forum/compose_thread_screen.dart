import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/models/documents/document.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:flutter_quill/widgets/toolbar.dart';
import 'package:subb_front/models/models.dart';
import 'package:subb_front/utils/api_collection.dart';
import 'package:flutter_quill/widgets/controller.dart';

class ComposeThreadScreen extends StatefulWidget {
  static const routeName = '/compose';

  final ForumData forum;

  ComposeThreadScreen(this.forum);

  @override
  _ComposeThreadScreenState createState() => _ComposeThreadScreenState(forum);
}

class _ComposeThreadScreenState extends State<ComposeThreadScreen> {
  QuillController? _quillController;
  late final _titleController;
  // TODO: fix focus bug
  late FocusNode _focusNode;

  final ForumData forum;

  _ComposeThreadScreenState(this.forum);

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

    if (_titleController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final apiResponse = await newThread(
        forumId: forum.forumId.toString(),
        title: _titleController.text,
        content: await compute(
            jsonEncode, _quillController!.document.toDelta().toJson()));

    if (apiResponse.code == 200) {
      snackBar = SnackBar(content: Text('Thread created'));
    } else {
      snackBar = SnackBar(content: Text('Thread created failed'));
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
        title: Text("Forum: ${forum.title}"),
      ),
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    decoration:
                        InputDecoration(hintText: 'Thread title here...'),
                    controller: _titleController,
                    autofocus: true,
                  ),
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
                      ),
                    ]),
                  )
                ],
              ))),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff03dac6),
        foregroundColor: Colors.black,
        onPressed: _newThread,
        child: Icon(Icons.send),
      ),
    );
  }
}
