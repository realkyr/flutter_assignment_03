class Todo {
  int _id;
  String subject;
  int done;

  Todo({int id, String subject, int done}) {
    this._id = id;
    this.subject = subject;
    this.done = done;
  }

  set setSubject(String subject) => this.subject = subject;
  String get getSubject => this.subject;

  set setId(int id) => this._id = id;
  int get getId => this._id;

  set setDone(int done) => this.done = done;
  int get getDone => this.done;

  Todo.fromJson(Map<String, dynamic> json) {
    _id = json['_id'];
    subject = json['subject'];
    done = json['done'];
  }

  Map<int, dynamic> toMap() {
    return {
      _id: {'subject': subject, 'done': done == 0 ? false : true}
    };
  }
}
