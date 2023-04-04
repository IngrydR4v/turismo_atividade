import 'package:flutter/material.dart';
import 'package:gerenciador_tarefas_md/model/cadastro_model.dart';
import 'package:intl/intl.dart';

class AdicionarView extends StatefulWidget {
  AdicionarView({super.key, required this.arguments});
  Map arguments;

  @override
  _AdicionarState createState() => _AdicionarState();
}

class _AdicionarState extends State<AdicionarView>
    with TickerProviderStateMixin {
  // instancia null porém quando for utilizar não poderá ser null
  // é setado no initState
  late Function onPressed;

  // key para utilizar no Form
  final formKey = GlobalKey<FormState>();

  // Controllers para os campos de texto
  final nomeController = TextEditingController();
  final descricaoController = TextEditingController();

  // lista de tipo para ser utilizado nos chips
  List tipos = ['Deserto', 'Praia', 'Montanha'];
  // inicia com o tipo zero que é o deserto
  int tipo = 0;

  // model do cadastro pode ser null, por isso utiliza o ?
  // vem null quando é um novo ponto
  CadastroModel? cadastroModel;

  @override
  void initState() {
    super.initState();
    // seta o metodo onPressed passado por argumento para ser utilizado aqui
    // pode adicionar ou atualizar itens na tela principal_view
    onPressed = widget.arguments['onPressed'];
    // se o model for diferente de null
    if (widget.arguments['model'] != null) {
      // seta na variavel cadsatroModel o que esta passando por argumento
      cadastroModel = widget.arguments['model'];

      // seta o tipo do cadastro
      tipo = cadastroModel!.tipo;
      // escreve no campo nome o nome do cadastro
      nomeController.text = cadastroModel!.nome;
      // escreve no campo descricao a descricao do cadastro
      descricaoController.text = cadastroModel!.descricao;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(210.0),
        child: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Colors.blue,
          elevation: 0,
          flexibleSpace: Image.asset(
            // valida qual o tipo para setar uma imagem
            tipo == 0
                ? 'assets/images/deserto.jpg'
                : tipo == 1
                    ? 'assets/images/praia.jpg'
                    : 'assets/images/montanhas.jpg',
            fit: BoxFit.fill,
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height + 240,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.0),
            topRight: Radius.circular(18.0),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              children: <Widget>[
                // se o model passado por argumento for diferente de null, é para atualizar, caso contrario é um cadastro novo
                Text(
                  widget.arguments['model'] != null
                      ? "Atualizar ponto turístico"
                      : "Novo ponto turístico",
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // caso seja um edicao o model deverá ser diferente de null
                // cria um texto informando a data que foi cadastrado no formado dd/mm/aaaa
                // utilizado ${} pois quando está dentro de uma "string" pode ser "concatenado" uma variavel
                // utilizado DateTime.parse() pois cadastroModel.data é uma String
                if (widget.arguments['model'] != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        "Cadastrado em ${DateFormat('dd/MM/yyyy').format(DateTime.parse(cadastroModel!.data))}"),
                  ),
                Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 18),
                      // cria as chips para setar o tipo do cadastro
                      // utilizado Wrap para caso falte espaço para as chips, quebre para a próxima linha
                      Wrap(
                        children: List<Widget>.generate(
                          tipos.length,
                          (int index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: ChoiceChip(
                                label: Text(tipos[index]),
                                selected: tipo == index,
                                onSelected: (bool selected) {
                                  setState(() {
                                    tipo = index;
                                  });
                                },
                              ),
                            );
                          },
                        ).toList(),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: nomeController,
                        // ao abrir a tela o foco é o campo nome
                        autofocus: true,
                        // maximo de caracteres 70
                        maxLength: 70,
                        decoration: InputDecoration(
                          hintText: 'Nome*',
                          // como setamos o maximo de caracteres 70 nao queremos que mostre o contador
                          counterText: "",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        validator: (String? valor) {
                          if (valor == null || valor.isEmpty) {
                            return 'Campo obrigatório';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: descricaoController,
                        // nao existe máximo de linha, automaticamente vai quebrando pra baixo o widget
                        maxLines: null,
                        // maximo de caracteres é 400
                        maxLength: 400,
                        decoration: InputDecoration(
                          hintText: 'Descrição*',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        validator: (String? valor) {
                          if (valor == null || valor.isEmpty) {
                            return 'Campo obrigatório';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width,
        height: 45,
        padding: const EdgeInsets.only(left: 31),
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
              ),
            ),
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all(Colors.pink),
          ),
          onPressed: () {
            // valida se os campos estão preenchidos
            if (formKey.currentState!.validate()) {
              // passa para o model os valores informados nos campos
              CadastroModel cadastroModel = CadastroModel(
                // posicao da lista de itens
                index: 0,
                nome: nomeController.text,
                descricao: descricaoController.text,
                // formata a data para ano-mes-dia
                data: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                // tipo selecionado (0 = Deserto / 1 = Praia / 2 = Montanha)
                tipo: tipo,
              );

              // executa o metodo onPressed(atualizar ou adicionar) que foi passado por argumento, devolvendo o model do cadastro
              onPressed(cadastroModel);
              // fecha a tela
              Navigator.pop(context);
            }
          },
          child: Text(
            // se o model passado por argumento for diferente de null, é para atualizar, caso contrario é um cadastro novo
            widget.arguments['model'] != null ? "Atualizar" : "Cadastrar",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
