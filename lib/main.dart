import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'database.dart'; // Importação do helper do banco de dados

void main() => runApp(MaterialApp(
      title: 'Named Routes Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => Index(),
        '/ter': (context) => ExemploInicial(),
      },
    ));

class Index extends StatefulWidget {
  Index({Key? key}) : super(key: key);
  @override
  _Index createState() => _Index();
}

class LoginData {
  String username = "";
  String password = "";
}

class _Index extends State<Index> {
  LoginData _loginData = LoginData();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "Por favor entre com o usuário";
                  }
                  return null;
                },
                onSaved: (String? value) {
                  _loginData.username = value!;
                },
                decoration: InputDecoration(
                  hintText: "nome@servidor.com",
                  labelText: "Username (e-mail)",
                ),
              ),
              TextFormField(
                obscureText: true,
                validator: (String? value) {
                  if (value!.length < 8) {
                    return "Senha deve ser maior ou igual a 8 caracteres";
                  }
                  return null;
                },
                onSaved: (String? value) {
                  _loginData.password = value!;
                },
                decoration: InputDecoration(
                  hintText: "Senha",
                  labelText: "Senha",
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Navigator.pushNamed(context, '/ter');
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExemploInicial extends StatefulWidget {
  ExemploInicial({Key? key}) : super(key: key);

  @override
  _ExemploInicial createState() => _ExemploInicial();
}

class _ExemploInicial extends State<ExemploInicial> {
  var _currentPage = 0;

  final List<Widget> _pages = [
    Principal(),
    Torneios(),
    Inscricao(),
    TabelaTimesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300), // Animação suave ao trocar de página
        child: _pages[_currentPage],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_volleyball),
            label: "Principal",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Torneios",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: "Inscrição",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.table_chart),
            label: "Tabela",
          ),
        ],
        currentIndex: _currentPage,
        selectedItemColor: Color.fromARGB(255, 255, 255, 0), // Cor amarela ao selecionar
        unselectedItemColor: Colors.black, // Cor preta para os itens não selecionados
        onTap: (int index) {
          setState(() {
            _currentPage = index;
          });
        },
      ),
    );
  }
}


class Principal extends StatefulWidget {
  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  bool _showFirstImage = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startImageSwitchTimer();
  }

  void _startImageSwitchTimer() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        _showFirstImage = !_showFirstImage;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Principal'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DestinationPage()),
            );
          },
          child: AnimatedSwitcher(
            duration: const Duration(seconds: 0),
            child: _showFirstImage
                ? Image.asset('image/campeao.png',
                    key: ValueKey<int>(1), width: 150, height: 150)
                : Image.asset('image/VNL.webp',
                    key: ValueKey<int>(2), width: 150, height: 150),
          ),
        ),
      ),
    );
  }
}


class DestinationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Destination Page'),
      ),
      body: Center(
        child: Text(
          'Descrição do torneio\n'
          'Descrição do torneio',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class Torneios extends StatefulWidget {
  @override
  _TorneiosState createState() => _TorneiosState();
}

class _TorneiosState extends State<Torneios> {
  final List<Map<String, String>> _torneiosAnuais = [
    {'nome': 'Copa do Mundo de Vôlei', 'data': 'Setembro - Outubro'},
    {'nome': 'Liga das Nações de Vôlei (VNL)', 'data': 'Maio - Julho'},
    {'nome': 'Superliga de Vôlei', 'data': 'Outubro - Abril'},
    {'nome': 'Campeonato Europeu de Vôlei', 'data': 'Agosto - Setembro'},
    {'nome': 'Campeonato Sul-Americano de Vôlei', 'data': 'Agosto'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Torneios Anuais'),
      ),
      body: ListView.builder(
        itemCount: _torneiosAnuais.length,
        itemBuilder: (context, index) {
          final torneio = _torneiosAnuais[index];
          return Card(
            child: ListTile(
              title: Text(torneio['nome']!),
              subtitle: Text('Data: ${torneio['data']}'),
            ),
          );
        },
      ),
    );
  }
}

class Inscricao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inscrição'),
      ),
      body: CadastroTimePage(),
    );
  }
}

class CadastroTimePage extends StatefulWidget {
  final Map<String, dynamic>? time;

  CadastroTimePage({this.time});

  @override
  _CadastroTimePageState createState() => _CadastroTimePageState();
}

class _CadastroTimePageState extends State<CadastroTimePage> {
  final _nomeController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _jogadoresController = TextEditingController();
  final _valorController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  int? _editingTimeId;
  double _valorPorPessoa = 0;

  @override
  void initState() {
    super.initState();
    if (widget.time != null) {
      _editingTimeId = widget.time!['id'];
      _nomeController.text = widget.time!['nome'];
      _cidadeController.text = widget.time!['cidade'];
      _jogadoresController.text = widget.time!['jogadores'];
      _valorController.text = widget.time!['valor'].toString();
    }
  }

  void _cadastrarTime() async {
    final nome = _nomeController.text;
    final cidade = _cidadeController.text;
    final jogadores = _jogadoresController.text;
    final valor = int.tryParse(_valorController.text) ?? 0;

    if (_editingTimeId == null) {
      await _dbHelper.insertInscricao({
        'nome': nome,
        'cidade': cidade,
        'jogadores': jogadores,
        'valor': valor,
      });
    } else {
      await _dbHelper.updateInscricao(_editingTimeId!, {
        'nome': nome,
        'cidade': cidade,
        'jogadores': jogadores,
        'valor': valor,
      });
    }

    _clearFields();
    Navigator.of(context as BuildContext).pop(); // Volta para a tela anterior após cadastro
  }

  void _clearFields() {
    _nomeController.clear();
    _cidadeController.clear();
    _jogadoresController.clear();
    _valorController.clear();
    _editingTimeId = null;
  }

  void _calcularValorPorPessoa() {
    final numeroJogadores = int.tryParse(_jogadoresController.text) ?? 0;

    if (numeroJogadores > 0) {
      setState(() {
        _valorPorPessoa = 500 / numeroJogadores;
      });
    } else {
      setState(() {
        _valorPorPessoa = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            controller: _nomeController,
            decoration: InputDecoration(labelText: 'Nome do Time'),
          ),
          SizedBox(height: 12.0),
          TextField(
            controller: _cidadeController,
            decoration: InputDecoration(labelText: 'Cidade'),
          ),
          SizedBox(height: 12.0),
          TextField(
            controller: _jogadoresController,
            decoration: InputDecoration(labelText: 'Quantidade de Jogadores'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 12.0),
          Text(
            'Valor total a ser dividido: R\$ 500',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 12.0),
          Text(
            'Valor por pessoa: R\$ ${_valorPorPessoa.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 16.0, color: Colors.blueAccent),
          ),
          SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: () {
              _calcularValorPorPessoa();
              _cadastrarTime();
            },
            child: Text(_editingTimeId == null ? 'Cadastrar' : 'Atualizar'),
          ),
        ],
      ),
    );
  }
}

class TabelaTimesPage extends StatefulWidget {
  @override
  _TabelaTimesPageState createState() => _TabelaTimesPageState();
}

class _TabelaTimesPageState extends State<TabelaTimesPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _times = [];

  @override
  void initState() {
    super.initState();
    _carregarTimes();
  }

  void _carregarTimes() async {
    final times = await _dbHelper.getTimes();
    setState(() {
      _times = times;
    });
  }

  void _editarTime(Map<String, dynamic> time) {
    Navigator.push(
      context as BuildContext,
      MaterialPageRoute(
        builder: (context) => CadastroTimePage(time: time),
      ),
    ).then((_) => _carregarTimes());
  }

  void _excluirTime(int id) async {
    await _dbHelper.deleteInscricao(id);
    _carregarTimes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Times Cadastrados'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _times.isEmpty
            ? Center(child: Text('Nenhum time cadastrado.'))
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Nome')),
                    DataColumn(label: Text('Cidade')),
                    DataColumn(label: Text('Jogadores')),
                    DataColumn(label: Text('Valor')),
                    DataColumn(label: Text('Ações')),
                  ],
                  rows: _times.map((time) {
                    return DataRow(
                      cells: [
                        DataCell(Text(time['nome'])),
                        DataCell(Text(time['cidade'])),
                        DataCell(Text(time['jogadores'])),
                        DataCell(Text('R\$ ${time['valor']}')),
                        DataCell(
                          Row(
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: () => _editarTime(time),
                                child: Text('Alterar'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 58, 33, 243), // Cor para botão alterar
                                ),
                              ),
                              SizedBox(width: 8), // Espaço entre os botões
                              ElevatedButton(
                                onPressed: () => _excluirTime(time['id']),
                                child: Text('Excluir'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red, // Cor para botão excluir
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
      ),
    );
  }
}

