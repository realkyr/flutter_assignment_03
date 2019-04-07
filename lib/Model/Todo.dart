final String _primekey = '_id';
final String _firstCol = 'title';
final String _secCol = 'done';

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

  Todo.fromJson(dynamic json) {
    _id = json[_primekey];
    subject = json[_firstCol];
    done = json[_secCol];
  }

  Map<String, dynamic> toMapDB() {
    Map<String, dynamic> data = {
      _firstCol: subject,
      _secCol: done,
    };

    if (_id != null) {
      data[_primekey] = _id;
    }
    return data;
  }

  Map<int, dynamic> toMap() {
    return {
      _id: {'subject': subject, 'done': done == 0 ? false : true}
    };
  }
}
