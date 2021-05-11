import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_quill/models/documents/document.dart';
import 'package:flutter_quill/widgets/default_styles.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:flutter_quill/widgets/toolbar.dart';
import 'package:subb_front/constants.dart';
import 'package:subb_front/models/api_response.dart';
import 'package:subb_front/universal_ui/universal_ui.dart';
import 'package:subb_front/utils/network.dart';
import 'package:tuple/tuple.dart';
import 'package:subb_front/screens/appbar.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:subb_front/screens/home.dart';

class ComposeScreen extends StatefulWidget {
  static const routeName = '/compose';
  static const _apiPath = '/new_thread';
  @override
  _ComposeScreenState createState() => _ComposeScreenState();
}

class _ComposeScreenState extends State<ComposeScreen> {
  QuillController? _controller;
  // TODO: fix focus bug
  late FocusNode _focusNode;

  Future<void> _loadFromAssets() async {
    try {
      final result = await rootBundle.loadString('assets/sample_data.json');
      final doc = Document.fromJson(jsonDecode(result));
      setState(() {
        _controller = QuillController(
            document: doc, selection: const TextSelection.collapsed(offset: 0));
      });
    } catch (error) {
      final doc = Document()..insert(0, 'Empty asset');
      setState(() {
        _controller = QuillController(
            document: doc, selection: const TextSelection.collapsed(offset: 0));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _loadFromAssets();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _sendNewPost() async {
    String forumID = '1';
    String title = 'demo title 2';
    final queryParams = {
      'forum_id': forumID,
      'title': title,
    };
    final b =
        await compute(jsonEncode, _controller!.document.toDelta().toJson());

    final apiResponse =
        await doPost('small_talk_api/new_thread/', queryParams, b);
    if (apiResponse != null) {
      print('code: ${apiResponse.code}');
      print('message: ${apiResponse.message}');
      print('data: ${apiResponse.data}');
    } else {
      print("_sendNewPost() error, null apiResponse");
    }
  }

  Future<void> _testPost() async {
    final apiResponse =
        await doGet("/small_talk_api/get_post", {'post_id': '1'});
    if (apiResponse != null) {
      print('code: ${apiResponse.code}');
      print('message: ${apiResponse.message}');
      print('data: ${apiResponse.data}');
    } else {
      print("_testPost() error, null apiResponse");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Scaffold(body: Center(child: Text('Loading...')));
    }
    return Scaffold(
      appBar: MyAppbar(),
      drawer: ForumDrawer(),
      body: SafeArea(
          child: Column(
        children: [
          QuillToolbar.basic(controller: _controller!),
          Expanded(
            child: Container(
              child: QuillEditor(
                controller: _controller!,
                readOnly: false,
                autoFocus: true,
                focusNode: _focusNode,
                scrollController: ScrollController(),
                scrollable: true,
                expands: false,
                padding: EdgeInsets.zero,
                embedBuilder: defaultEmbedBuilderWeb,
              ),
            ),
          )
        ],
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff03dac6),
        foregroundColor: Colors.black,
        // onPressed: _sendNewPost,
        onPressed: _testPost,
        child: Icon(Icons.send),
      ),
      // body: RawKeyboardListener(
      //   focusNode: FocusNode(),
      //   onKey: (event) {
      //     if (event.data.isControlPressed && event.character == 'b') {
      //       if (_controller!
      //           .getSelectionStyle()
      //           .attributes
      //           .keys
      //           .contains('bold')) {
      //         _controller!
      //             .formatSelection(Attribute.clone(Attribute.bold, null));
      //       } else {
      //         _controller!.formatSelection(Attribute.bold);
      //       }
      //     }
      //   },
      //   child: _buildWelcomeEditor(context),
      // ),
    );
  }

  // Widget _buildWelcomeEditor(BuildContext context) {
  // var quillEditor = QuillEditor(
  //     controller: _controller!,
  //     scrollController: ScrollController(),
  //     scrollable: true,
  //     focusNode: _focusNode,
  //     autoFocus: false,
  //     readOnly: false,
  //     placeholder: 'Add content',
  //     expands: false,
  //     padding: EdgeInsets.zero,
  //     customStyles: DefaultStyles(
  //       h1: DefaultTextBlockStyle(
  //           const TextStyle(
  //             fontSize: 32,
  //             color: Colors.black,
  //             height: 1.15,
  //             fontWeight: FontWeight.w300,
  //           ),
  //           const Tuple2(16, 0),
  //           const Tuple2(0, 0),
  //           null),
  //       sizeSmall: const TextStyle(fontSize: 9),
  //     ));
  // if (kIsWeb) {
  //   quillEditor = QuillEditor(
  //     controller: _controller!,
  //     scrollController: ScrollController(),
  //     scrollable: true,
  //     focusNode: _focusNode,
  //     autoFocus: false,
  //     readOnly: false,
  //     placeholder: 'Add content',
  //     expands: false,
  //     padding: EdgeInsets.zero,
  //     customStyles: DefaultStyles(
  //       h1: DefaultTextBlockStyle(
  //           const TextStyle(
  //             fontSize: 32,
  //             color: Colors.black,
  //             height: 1.15,
  //             fontWeight: FontWeight.w300,
  //           ),
  //           const Tuple2(16, 0),
  //           const Tuple2(0, 0),
  //           null),
  //       sizeSmall: const TextStyle(fontSize: 9),
  //     ),
  //     // embedBuilder: defaultEmbedBuilderWeb
  //   );
  // }
  // return SafeArea(
  //   child: Column(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: <Widget>[
  //       Expanded(
  //         flex: 15,
  //         child: Container(
  //           color: Colors.white,
  //           padding: const EdgeInsets.only(left: 16, right: 16),
  //           child: quillEditor,
  //         ),
  //       ),
  //       kIsWeb
  //           ? Expanded(
  //               child: Container(
  //               padding:
  //                   const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
  //               child: QuillToolbar.basic(
  //                 controller: _controller!,
  //                 // onImagePickCallback: _onImagePickCallback),
  //               ),
  //             ))
  //           : Container(
  //               child: QuillToolbar.basic(
  //                 controller: _controller!,
  //                 // onImagePickCallback: _onImagePickCallback),
  //               ),
  //             ),
  //     ],
  //   ),
  // );
  // }

  // Renders the image picked by imagePicker from local file storage
  // You can also upload the picked image to any server (eg : AWS s3 or Firebase) and then return the uploaded image URL
  // Future<String> _onImagePickCallback(File file) async {
  //   // Copies the picked file from temporary cache to applications directory
  //   final appDocDir = await getApplicationDocumentsDirectory();
  //   final copiedFile =
  //       await file.copy('${appDocDir.path}/${basename(file.path)}');
  //   return copiedFile.path.toString();
  // }

  // Widget _buildMenuBar(BuildContext context) {
  //   final size = MediaQuery.of(context).size;
  //   const itemStyle = TextStyle(
  //     color: Colors.white,
  //     fontSize: 18,
  //     fontWeight: FontWeight.bold,
  //   );
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Divider(
  //         thickness: 2,
  //         color: Colors.white,
  //         indent: size.width * 0.1,
  //         endIndent: size.width * 0.1,
  //       ),
  //       ListTile(
  //         title: const Center(child: Text('Read only demo', style: itemStyle)),
  //         dense: true,
  //         visualDensity: VisualDensity.compact,
  //         onTap: _readOnly,
  //       ),
  //       Divider(
  //         thickness: 2,
  //         color: Colors.white,
  //         indent: size.width * 0.1,
  //         endIndent: size.width * 0.1,
  //       ),
  //     ],
  //   );
  // }

  // void _readOnly() {
  //   Navigator.push(
  //     super.context,
  //     MaterialPageRoute(
  //       builder: (context) => ReadOnlyPage(),
  //     ),
  //   );
  // }

}
