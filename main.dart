import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        home: Home(),
        debugShowCheckedModeBanner: false,
      ),
    );

class Pessoa {
  double peso;
  double altura; // em cm
  String genero; // 'masculino' ou 'feminino'

  Pessoa({required this.peso, required this.altura, required this.genero});

  double calcularIMC() {
    double h = altura / 100.0;
    return peso / (h * h);
  }

  String classificarIMC() {
    double imc = calcularIMC();

    // Exemplo: pequenas diferenças por gênero
    if (genero == 'feminino') {
      if (imc < 18.5) return "Abaixo do peso";
      if (imc < 24.0) return "Peso ideal";
      if (imc < 29.0) return "Levemente acima do peso";
      if (imc < 34.0) return "Obesidade Grau I";
      if (imc < 39.0) return "Obesidade Grau II";
      return "Obesidade Grau III";
    } else {
      if (imc < 18.6) return "Abaixo do peso";
      if (imc < 25.0) return "Peso ideal";
      if (imc < 30.0) return "Levemente acima do peso";
      if (imc < 35.0) return "Obesidade Grau I";
      if (imc < 40.0) return "Obesidade Grau II";
      return "Obesidade Grau III";
    }
  }

  Color corClassificacao() {
    String c = classificarIMC();
    if (c == 'Peso ideal') return Colors.green;
    if (c == 'Abaixo do peso') return Colors.blue;
    if (c == 'Levemente acima do peso') return Colors.orange;
    return Colors.red;
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  String _genero = "masculino";

  String _result = "Informe seus dados";
  Color _resultColor = Colors.black;

  void resetFields() {
    _weightController.text = '';
    _heightController.text = '';
    setState(() {
      _genero = "masculino";
      _result = "Informe seus dados";
      _resultColor = Colors.black;
    });
  }

  void calcular() {
    Pessoa p = Pessoa(
      peso: double.parse(_weightController.text),
      altura: double.parse(_heightController.text),
      genero: _genero,
    );

    double imc = p.calcularIMC();
    String classificacao = p.classificarIMC();
    Color cor = p.corClassificacao();

    setState(() {
      _result = "IMC = ${imc.toStringAsPrecision(4)}\n$classificacao";
      _resultColor = cor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de IMC'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: resetFields,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Peso (kg)"),
                validator: (value) => value!.isEmpty ? "Insira seu peso!" : null,
              ),
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Altura (cm)"),
                validator: (value) => value!.isEmpty ? "Insira sua altura!" : null,
              ),

              SizedBox(height: 20),

              Text("Gênero", style: TextStyle(fontSize: 18)),

              Row(
                children: [
                  Radio(
                    value: "masculino",
                    groupValue: _genero,
                    onChanged: (value) {
                      setState(() => _genero = value.toString());
                    },
                  ),
                  Text("Masculino"),

                  Radio(
                    value: "feminino",
                    groupValue: _genero,
                    onChanged: (value) {
                      setState(() => _genero = value.toString());
                    },
                  ),
                  Text("Feminino"),
                ],
              ),

              SizedBox(height: 30),

              Text(
                _result,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _resultColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 30),

              ElevatedButton(
                style: ElevatedButton.styleFrom(padding: EdgeInsets.all(16)),
                onPressed: () {
                  if (_formKey.currentState!.validate()) calcular();
                },
                child: Text(
                  "CALCULAR",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
