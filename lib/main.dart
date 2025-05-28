import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de notas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFEBEE),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(244, 153, 194, 1),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 20),
          bodyMedium: TextStyle(fontSize: 18),
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'App de notas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _disciplinaSelecionada;
  final Map<String, List<String>> _disciplinasComAnotacoes = {
    'DM': [],
    'POO': [],
  };

  void _adicionarAnotacao(String anotacao) {
    if (_disciplinaSelecionada != null) {
      setState(() {
        _disciplinasComAnotacoes[_disciplinaSelecionada]!.add(anotacao);
      });
    }
  }

  void _mostrarAdicionarAnotacao() {
    TextEditingController controller = TextEditingController();
    final FocusNode campoFoco = FocusNode();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nova anotação', style: TextStyle(fontSize: 20)),
          content: TextField(
            controller: controller,
            focusNode: campoFoco,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Digite a anotação'),
            style: const TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar', style: TextStyle(fontSize: 18)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(48, 48),
              ),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  _adicionarAnotacao(controller.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Adicionar', style: TextStyle(fontSize: 18)),
            ),
          ],
        );
      },
    );
  }

  void _adicionarDisciplina(String disciplina) {
    setState(() {
      _disciplinasComAnotacoes[disciplina] = [];
    });
  }

  void _mostrarAdicionarDisciplina() {
    TextEditingController controller = TextEditingController();
    final FocusNode campoFoco = FocusNode();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nova disciplina', style: TextStyle(fontSize: 20)),
          content: TextField(
            controller: controller,
            focusNode: campoFoco,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Digite o nome da disciplina'),
            style: const TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar', style: TextStyle(fontSize: 18)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(48, 48),
              ),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  _adicionarDisciplina(controller.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Adicionar', style: TextStyle(fontSize: 18)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 237, 136, 149),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/kawaii_note_icon.jpg'),
                    radius: 40,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Disciplinas',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            ..._disciplinasComAnotacoes.keys.map(
              (disciplina) => Tooltip(
                message: disciplina == 'DM'
                    ? 'Desenvolvimento Mobile'
                    : disciplina == 'POO'
                        ? 'Programação Orientada a Objetos'
                        : '',
                child: Semantics(
                  button: true,
                  label: 'Selecionar disciplina $disciplina',
                  child: ListTile(
                    title: Text(disciplina, style: const TextStyle(fontSize: 18)),
                    minVerticalPadding: 12,
                    onTap: () {
                      setState(() {
                        _disciplinaSelecionada = disciplina;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: Builder(
          builder: (BuildContext context) {
            return Tooltip(
              message: 'Abrir menu de navegação',
              child: IconButton(
                iconSize: 32,
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            );
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(widget.title, style: const TextStyle(fontSize: 22)),
                Tooltip(
                  message: 'Adicionar Disciplina',
                  child: IconButton(
                    iconSize: 32,
                    icon: const Icon(Icons.add),
                    onPressed: _mostrarAdicionarDisciplina,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: _disciplinaSelecionada != null
          ? MergeSemantics(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Semantics(
                    label: 'Anotações para a disciplina $_disciplinaSelecionada',
                    child: Text(
                      'Anotações para ${_disciplinaSelecionada!}:',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _disciplinasComAnotacoes[_disciplinaSelecionada!]!.length,
                      itemBuilder: (context, index) {
                        return Semantics(
                          label:
                              'Anotação número ${index + 1}: ${_disciplinasComAnotacoes[_disciplinaSelecionada!]![index]}',
                          child: ListTile(
                            minVerticalPadding: 12,
                            title: Text(
                              _disciplinasComAnotacoes[_disciplinaSelecionada!]![index],
                              style: const TextStyle(fontSize: 18),
                            ),
                            trailing: Tooltip(
                              message: 'Excluir anotação',
                              child: IconButton(
                                iconSize: 32,
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    _disciplinasComAnotacoes[_disciplinaSelecionada!]!
                                        .removeAt(index);
                                  });
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Focus(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(48, 48),
                      ),
                      onPressed: () {
                        setState(() {
                          _disciplinasComAnotacoes[_disciplinaSelecionada]!.clear();
                        });
                      },
                      child: const Text('Remover todas as anotações',
                          style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            )
          : Center(
              child: Semantics(
                label: 'Nenhuma disciplina selecionada. Use o menu lateral.',
                child: const Text(
                  'Selecione uma disciplina no menu.',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
      floatingActionButton: Semantics(
        button: true,
        label: 'Botão para adicionar uma nova anotação',
        child: FloatingActionButton(
          onPressed: () {
            if (_disciplinaSelecionada != null) {
              _mostrarAdicionarAnotacao();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Selecione uma disciplina primeiro!')),
              );
            }
          },
          tooltip: 'Adicionar Anotação',
          child: const Icon(Icons.note_add, size: 32),
        ),
      ),
    );
  }
}
