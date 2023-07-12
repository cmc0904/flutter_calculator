import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "간단한 계산기",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget{
  const Calculator({Key? key}) : super(key : key);

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final List<String> buttons = [
    "C", '(', ')', '/',
    "7", "8", "9", "*",
    "4", "5", "6", "+",
    "1", "2", "3", "-",
    'AC', "0", ".", "="
  ];

  String statement = "";
  String result = "0";

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Flexible(
              flex : 2, 
              child: _resultView()
            ),
            Expanded(
              flex: 4,
              child: _buttons(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultView() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          padding: EdgeInsets.all(20),
          alignment: Alignment.centerRight,
          child: Text(statement, style: TextStyle(fontSize: 32),),
        ),
        Container(
          padding: EdgeInsets.all(15),
          alignment: Alignment.centerRight,
          child: Text(result, style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
        )
      ],
    );
  }

  Widget _buttons() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemBuilder: (context, index) {
        return _myButton(buttons[index]); 
      },
      itemCount: buttons.length,
    );
  }

  Widget _myButton(String text) {
    return Container(
      margin: EdgeInsets.all(2),
      child: MaterialButton(
        onPressed: () {
          setState(() {
            clickBtn(text);
          });
        },
        color: _getColor(text),
        textColor: Colors.white,
        child: Text(text, style: TextStyle(fontSize: 24, ),),
        // shape: CircleBorder(),
      ),
    );
  }

  _getColor(String text) {
    if(text == '/' || text == "*" || text == "-" || text == "+" || text == "-" || text == "=") {
      return Colors.orangeAccent;
    } else if(text == "(" || text == ")" || text == ".") {
      return Colors.blueGrey;
    } else if (text == "C" || text == "AC") {
      return Colors.red;
    }
    return Colors.blueAccent;
  }

  clickBtn(String text) {
    if(text == "AC") {
      statement = "";
      result = '0';
      return;
    }

    if(text == "C") {
      statement = statement.substring(0, statement.length - 1);
      return;
    }

    if(text == "=") {
      result = calculate();
      return;
    }
    statement = statement +  text;
  }
  
  calculate() {
    try {
      var exp = Parser().parse(statement);
      var result = exp.evaluate(EvaluationType.REAL, ContextModel());
      statement = result.toString();
      return result.toString();
    } catch(e) {
      statement = "";
      result = "0";
      return "error";
    }
  }
}