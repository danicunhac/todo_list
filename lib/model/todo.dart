class Todo {
  int id;
  String name;
  int done;

  Todo(this.name, this.done, {this.id = 0});

  @override
  String toString() {
    return 'Todo{id: $id, name: $name, done: $done}';
  }
}
