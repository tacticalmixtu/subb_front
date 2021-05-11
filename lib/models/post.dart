class Post {
  final int postId;
  final int threadId;
  final int author;
  final int timestamp;
  final int quoteId;
  final String content;
  final String status;
  final int comments;
  final int votes;

  Post(
      {required this.postId,
      required this.threadId,
      required this.author,
      required this.timestamp,
      required this.quoteId,
      required this.content,
      required this.status,
      required this.comments,
      required this.votes});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        postId: json['post_id'],
        threadId: json['thread_id'],
        author: json['author'],
        timestamp: json['timestamp'],
        quoteId: json['quote_id'],
        content: json['content'],
        status: json['status'],
        comments: json['comments'],
        votes: json['votes']);
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['post_id'] = this.postId;
  //   data['thread_id'] = this.threadId;
  //   data['author'] = this.author;
  //   data['timestamp'] = this.timestamp;
  //   data['quote_id'] = this.quoteId;
  //   data['content'] = this.content;
  //   data['status'] = this.status;
  //   data['comments'] = this.comments;
  //   data['votes'] = this.votes;
  //   return data;
  // }
}
