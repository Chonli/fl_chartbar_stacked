import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  static const datas = <_ChartData>[
    _ChartData("12/02/2018", 25, 25),
    _ChartData("22/06/2018", 5, 20),
    _ChartData("04/09/2018", 25, 5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chart Bar'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              SizedBox(
                height: 300,
                child: ChartBarView(
                  datas: datas,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ChartData {
  const _ChartData(
    this.date,
    this.value,
    this.value2,
  );

  final String date;
  final double value;
  final double value2;
}

const topPad = 10.0;
const bottomPad = 30.0;
const rightPad = 25.0;

class ChartBarView extends StatelessWidget {
  const ChartBarView({Key? key, required this.datas}) : super(key: key);

  final List<_ChartData> datas;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final canvasHeight = constraints.maxHeight - (topPad + bottomPad);
        final canvasWidth = constraints.maxWidth - rightPad;
        final maxData = datas
            .reduce((a, b) => a.value + a.value2 > b.value + b.value2 ? a : b);
        final maxValue = maxData.value + maxData.value2 + 10;
        final ratioValuePx = canvasHeight / maxValue;
        final barPad = canvasWidth / (datas.length + 1);
        print('h=$canvasHeight, w=$canvasWidth, b=$barPad');

        return Container(
          color: Colors.grey.shade100,
          child: Stack(
            children: [
              // Y axis
              for (int i = 0; i < 4; i++) ...[
                Positioned(
                  top: topPad + i * canvasHeight / 4,
                  width: canvasWidth,
                  child: const Divider(
                    height: 0,
                    endIndent: rightPad,
                    color: Colors.black54,
                  ),
                ),
                Positioned(
                  top: i * canvasHeight / 4,
                  right: 0,
                  child: Text('${maxValue - i * maxValue / 4}%'),
                ),
              ],

              // X axis
              Positioned(
                bottom: bottomPad - 2,
                width: canvasWidth,
                child: const Divider(
                  height: 0,
                  thickness: 2,
                  endIndent: rightPad,
                  color: Colors.black54,
                ),
              ),

              // Bar
              for (int i = 0; i < datas.length; i++) ...[
                _ChartBar(
                  data: datas[i],
                  leftPad: barPad * (i + 1),
                  ratioValuePx: ratioValuePx,
                ),
              ]
            ],
          ),
        );
      },
    );
  }
}

class _ChartBar extends StatelessWidget {
  const _ChartBar({
    Key? key,
    required this.data,
    required this.leftPad,
    required this.ratioValuePx,
  }) : super(key: key);

  final _ChartData data;
  final double leftPad;
  final double ratioValuePx;

  @override
  Widget build(BuildContext context) {
    const width = 30.0;
    final leftPos = leftPad - width / 2;
    final stackedPosValue2 = data.value2 * ratioValuePx;
    return Stack(
      children: [
        Positioned(
          left: leftPos,
          bottom: bottomPad,
          width: width,
          height: stackedPosValue2,
          child: Container(
            color: Colors.green,
          ),
        ),
        Positioned(
          left: leftPos,
          bottom: bottomPad + stackedPosValue2,
          width: width,
          height: data.value * ratioValuePx,
          child: Container(
            color: Colors.greenAccent,
          ),
        ),
        Positioned(
          left: leftPad,
          bottom: bottomPad - 5,
          height: 5,
          child: const VerticalDivider(
            width: 0,
            thickness: 2,
            color: Colors.black54,
          ),
        ),
        Positioned(
          left: leftPad - 25,
          bottom: 10,
          child: Text(
            data.date,
            style: const TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }
}
