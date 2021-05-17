import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/models/documents/document.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:flutter_quill/widgets/toolbar.dart';
import 'package:subb_front/models/post.dart';
import 'package:subb_front/utils/api_collection.dart';
import 'package:flutter_quill/widgets/controller.dart';

class ComposeCommentScreen extends StatefulWidget {
  static const routeName = '/compose_comment';

  final Post post;

  ComposeCommentScreen(this.post);

  @override
  _ComposeCommentScreenState createState() => _ComposeCommentScreenState(post);
}

class _ComposeCommentScreenState extends State<ComposeCommentScreen> {
  QuillController? _quillController;
  late final _titleController;
  // TODO: fix focus bug
  late FocusNode _focusNode;

  final Post post;

  _ComposeCommentScreenState(this.post);

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

  void _newComment() async {
    SnackBar snackBar = SnackBar(content: Text('No title!'));

    final apiResponse = await newComment(
        postId: post.postId.toString(),
        content: await compute(
            jsonEncode, _quillController!.document.toDelta().toJson()));

    if (apiResponse.code == 200) {
      snackBar = SnackBar(content: Text('Comment created'));
    } else {
      snackBar = SnackBar(content: Text('Comment created failed'));
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
        title: Text("Re: ${post.content}"),
      ),
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.all(8.0),
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
                      ),
                    ]),
                  )
                ],
              ))),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff03dac6),
        foregroundColor: Colors.black,
        onPressed: _newComment,
        child: Icon(Icons.send),
      ),
    );
  }
}
