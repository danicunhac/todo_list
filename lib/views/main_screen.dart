import 'package:todo_list/database/database.dart';
import 'package:todo_list/model/todo.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _key = GlobalKey<FormState>();

  var todoInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("To do List"),
        ),
        body: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            children: [
              Form(
                key: _key,
                child: Column(
                  children: [
                    TextFormField(
                      controller: todoInput,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Tarefa',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(0.0),
                          child: Icon(
                            Icons.book_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty) {
                            return "Informe o nome da tarefa";
                          }
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40), // NEW
                        ),
                        onPressed: () {
                          if (!_key.currentState!.validate()) {
                            return;
                          }

                          setState(() {
                            insert(Todo(todoInput.text, 0));
                          });

                          showDialogSucess(
                              context, "Tarefa criada com sucesso!");
                        },
                        child: const Text("Cadastrar")),
                    const SizedBox(height: 24),
                    ListView(
                      shrinkWrap: true,
                      children: [
                        FutureBuilder<List<Todo>>(
                          future: findAll(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: ListTile(
                                      title: Text(snapshot.data![index].name,
                                          style: TextStyle(
                                              decoration: snapshot
                                                          .data![index].done ==
                                                      1
                                                  ? TextDecoration.lineThrough
                                                  : null)),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Checkbox(
                                            checkColor: Colors.black,
                                            activeColor: Colors.green,
                                            value:
                                                snapshot.data![index].done == 0
                                                    ? false
                                                    : true,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                update(Todo(
                                                    snapshot.data![index].name,
                                                    value! ? 1 : 0,
                                                    id: snapshot
                                                        .data![index].id));
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  showDialogSucess(context, message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Sucesso"),
            content: Text("$message"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Ok"))
            ],
          );
        });
  }
}
