import 'package:flutter/material.dart';
import 'package:gerenciador_tarefas_md/model/cadastro_model.dart';
import 'package:intl/intl.dart';

class PrincipalView extends StatefulWidget {
  const PrincipalView({super.key});

  @override
  State<PrincipalView> createState() => _PrincipalState();
}

class _PrincipalState extends State<PrincipalView> {
  final scrollController = ScrollController();

  // lista vazia de cadastros
  List<CadastroModel> cadastros = [];
  // inicia sem estar pesquisando
  bool pesquisando = false;
  // a pesquisa pode ser null
  String? pesquisa;

  // passamos o model e o index por parametro
  editarCadastro({required CadastroModel cadastroModel, required int index}) {
    Navigator.pushNamed(
      context,
      '/adicionarPontoTuristico',
      arguments: {
        'model': cadastroModel,
        'onPressed': (CadastroModel cadastroModel) {
          // build a tela inteira novamente atualizando na lista cadastros o cadastro na posicao INDEX passado por parametro
          setState(() {
            cadastros[index] = cadastroModel;
          });
        },
      },
    );
  }

  // passamos o index por parametro
  removerCadastro({required int index}) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remover ponto turístico?'),
          content: const SingleChildScrollView(
            child: Text('Deseja realmente remover esse ponto turístico?'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Não'),
              onPressed: () {
                // fecha o alerta
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Sim'),
              onPressed: () {
                // utiliza o setstate para buildar a tela novamente
                // setstate faz o "build" inteiro novamente
                setState(() {
                  // remove o item na posicao index(passado por parametro no metodo) da lista cadastros
                  cadastros.removeAt(index);
                });
                // fecha o alerta
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // converte a data para estilo americano
  converterData({required String date}) {
    if (date.length == 10) {
      var y = date.substring(6, 10);
      var m = date.substring(3, 5);
      var d = date.substring(0, 2);
      date = "$y-$m-$d";
    }
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        // Necessário utilizar o controller no CustomScrollView e ListView para rolar a lista
        controller: scrollController,
        slivers: [
          SliverAppBar.medium(
            title: const Text("Lista de lugares"),
          ),
          if (cadastros.isEmpty)
            SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/empty.jpg', fit: BoxFit.cover),
                  const Text(
                    "Nenhum ponto turístico adicionado!",
                    style: TextStyle(fontSize: 22),
                  ),
                ],
              ),
            ),
          if (cadastros.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Pesquisa pelo nome ou data de cadastro',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  onChanged: (value) {
                    setState(() {
                      // se value nao é vazio e diferente de "" seta como true a variavel pesquisando
                      pesquisando = (value.isNotEmpty && value != "");
                      // seta na variavel pesquisa o texto digitado
                      pesquisa = value;
                    });
                  },
                ),
              ),
            ),
          if (cadastros.isNotEmpty)
            SliverToBoxAdapter(
              child: ListView.builder(
                controller: scrollController,
                shrinkWrap: true,
                itemCount: cadastros.length,
                itemBuilder: (BuildContext context, int index) {
                  // transforma cada item da lista em um model para ser utilizado nos cards
                  CadastroModel cadastroModel = cadastros[index];

                  // esconde ou nao o card para utilizar no filtro
                  return Visibility(
                    // se estiver pesquisando e o texto conter no nome ou for igual a data de cadastro
                    visible: pesquisando
                        ? cadastroModel.nome.contains(pesquisa!) ||
                            cadastroModel.data == converterData(date: pesquisa!)
                        // se nao estiver pesquisando sempre fica true
                        : true,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            // caso seja o ultimo item da lista adiciona um espaco para a fab nao fique por cima do item
                            // como o index começa em zero, então é necessario somar + 1 para que possa validar se é o último item
                            bottom: cadastros.length == (index + 1) ? 80 : 0,
                          ),
                          child: SizedBox(
                            // pega o tamanho da tela do celular
                            width: MediaQuery.of(context).size.width,
                            height: 320,
                            child: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 5,
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 170,
                                    child: Image.asset(
                                      // valida qual o tipo para setar uma imagem
                                      cadastroModel.tipo == 0
                                          ? 'assets/images/deserto.jpg'
                                          : cadastroModel.tipo == 1
                                              ? 'assets/images/praia.jpg'
                                              : 'assets/images/montanhas.jpg',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  // necessário Expanded para quebrar a linha do texto, pois o máximo do subtitle é duas linhas
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          title: Text(
                                            cadastroModel.nome,
                                            // numero de linhas apenas 1
                                            maxLines: 1,
                                            // caso tenha mais texto do que caiba, ficará com (...) no final
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(
                                            cadastroModel.descricao,
                                            // numero de linhas 2
                                            maxLines: 2,
                                            // caso tenha mais texto do que caiba, ficará com (...) no final
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                  shape:
                                                      MaterialStateProperty.all(
                                                    const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  40.0)),
                                                    ),
                                                  ),
                                                  elevation:
                                                      MaterialStateProperty.all(
                                                          0),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.blueAccent),
                                                ),
                                                onPressed: () {
                                                  editarCadastro(
                                                      cadastroModel:
                                                          cadastroModel,
                                                      index: index);
                                                },
                                                child: const Text(
                                                  // se o model passado por argumento for diferente de null, é para atualizar, caso contrario é um cadastro novo
                                                  "Editar",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                  shape:
                                                      MaterialStateProperty.all(
                                                    const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  40.0)),
                                                    ),
                                                  ),
                                                  elevation:
                                                      MaterialStateProperty.all(
                                                          0),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.pink),
                                                ),
                                                onPressed: () {
                                                  removerCadastro(index: index);
                                                },
                                                child: const Text(
                                                  // se o model passado por argumento for diferente de null, é para atualizar, caso contrario é um cadastro novo
                                                  "Remover",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        onPressed: () {
          // abre a tela de adicionar ponto turistico passando o model como parametro null para saber que é um novo ponto
          // e um metodo onPressed para adicionar o item na lista
          Navigator.pushNamed(context, '/adicionarPontoTuristico', arguments: {
            'model': null,
            'onPressed': (CadastroModel cadastroModel) {
              // build a tela inteira novamente adicionando na lista cadastro o cadastro passado por parametro transformando em json
              setState(() {
                cadastros.add(cadastroModel);
              });
            },
          });
        },
        label: const Text("Adicionar", style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
