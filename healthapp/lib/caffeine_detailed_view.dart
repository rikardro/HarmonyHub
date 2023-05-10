import 'dart:developer';
import 'dart:math';

import 'package:healthapp/util/dialogs/error_dialog.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthapp/bloc/caffeine_bloc.dart';
import 'package:healthapp/bloc/caffeine_detailed_bloc.dart';

import 'bloc/caffeine_detailed_bloc.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CaffeineDetailedView extends StatefulWidget {
  const CaffeineDetailedView({super.key});

  @override
  State<CaffeineDetailedView> createState() => _CaffeineDetailedViewState();
}

class _CaffeineDetailedViewState extends State<CaffeineDetailedView> {
  @override
  Widget build(BuildContext context) {
    context.read<CaffeineDetailedBloc>().add(const FetchAllCaffeine());
    final bloc = BlocProvider.of<CaffeineDetailedBloc>(context);
    return BlocConsumer<CaffeineDetailedBloc, CaffeineDetailedState>(
      listener: (context, state) {
        context.read<CaffeineBloc>().add(const FetchCaffeine());
      },
      builder: (context, state) {
        if (state.status == CaffeineDetailedStatus.success) {
          final List<CaffeineRecord> listOfCaffeine = state.caffeineList ?? [];
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              title: const Text(""),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xFF8D3786),
                  Color(0xFF8D3751),
                ],
                end: Alignment.bottomCenter,
                begin: Alignment.topCenter),
              ),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 35),
                      child: Column(
                        children: [
                          const Text(
                            "Your caffeine level",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 30),
                          BlocBuilder<CaffeineBloc, CaffeineState>(
                            builder: (context, state) {
                              final String caffeineStatus =
                                  state.caffeineStatus ?? "";
                              final double caffeineAmount = state.caffeine ?? 0;
                              final roundedAmount = caffeineAmount.round();
                              if (state.status == CaffeineStatus.loading) {
                                return const CircularProgressIndicator();
                              } else {
                                return Column(
                                  children: [

                                    Stack(
                                      alignment:  AlignmentDirectional.center,
                                      children: [
                                        Stack(
                                          alignment: AlignmentDirectional.center,
                                          // clipBehavior: Clip.none, // <--- important part
                                          children: [

                                            Center(
                                                child: SfRadialGauge(
                                                  axes: <RadialAxis>[
                                                    RadialAxis(
                                                      minimum: 0, maximum: 301,
                                                      startAngle: 180, endAngle: 0,
                                                      axisLabelStyle: const GaugeTextStyle(
                                                        color: Colors.white, fontSize: 15,),
                                                      ranges: <GaugeRange>[
                                                        GaugeRange(
                                                            startValue: 0,
                                                            endValue: min(300, roundedAmount.toDouble()),
                                                            color: Colors.white,
                                                            startWidth: 15,
                                                            endWidth: 15,
                                                        )
                                                      ],
                                                      majorTickStyle: const MajorTickStyle(length: 0.1, 
                                                        lengthUnit: GaugeSizeUnit.factor, thickness: 1.5, color: Colors.white),
                                                        minorTickStyle: const MinorTickStyle(length: 0.05, 
                                                        lengthUnit: GaugeSizeUnit.factor, thickness: 1.5, color: Colors.white)
                                                    ),
                                                  ],
                                                )
                                            ),

                                            Center(
                                              child: SfRadialGauge(
                                              axes: <RadialAxis>[
                                                RadialAxis(
                                                  minimum: 0, maximum: 300,
                                                  startAngle: 180, endAngle: 0,
                                                  ranges: <GaugeRange>[
                                                  GaugeRange(startValue: 0, endValue: min(50, roundedAmount.toDouble()), color:Colors.green, startWidth: 14, endWidth: 14,),
                                                  GaugeRange(startValue: 50,endValue: max(50, min(200, roundedAmount.toDouble())), color: Colors.orange, startWidth: 14, endWidth: 14,),
                                                  GaugeRange(startValue: 200,endValue: max(200, min(299, roundedAmount.toDouble())),color: Colors.red, startWidth: 14, endWidth: 14,)],
                                                  // pointers: <GaugePointer>[NeedlePointer(value: roundedAmount.toDouble())],
                                                  showLabels: false,
                                                  showTicks: false,
                                                  showAxisLine: false,
                                            )])),
                                            
                                              Center(
                                                child: SfRadialGauge(
                                                  axes: <RadialAxis>[
                                                    RadialAxis(
                                                      minimum: 0, maximum: 301,
                                                      startAngle: 180, endAngle: 0,
                                                      axisLabelStyle: const GaugeTextStyle(
                                                        color: Colors.white, fontSize: 15,),
                                                      ranges: <GaugeRange>[
                                                        GaugeRange(
                                                            startValue: 0,
                                                            endValue: min(300, roundedAmount.toDouble()),
                                                            color: Colors.white,
                                                            startWidth: 1,
                                                            endWidth: 1
                                                        ),
                                                        GaugeRange(startValue: 0, endValue: 1, color:Colors.white, startWidth: 15, endWidth: 15,),
                                                        GaugeRange(startValue: min(300, roundedAmount.toDouble()) - 1, endValue: min(300, roundedAmount.toDouble()), color:Colors.white, startWidth: 15, endWidth: 15,),
                                                      ],
                                                      majorTickStyle: const MajorTickStyle(length: 0.1, 
                                                        lengthUnit: GaugeSizeUnit.factor, thickness: 1.5, color: Colors.white),
                                                        minorTickStyle: const MinorTickStyle(length: 0.05, 
                                                        lengthUnit: GaugeSizeUnit.factor, thickness: 1.5, color: Colors.white)
                                                    ),
                                                  ],
                                                )
                                            ),


                                          ],
                                        ),

                                        Column(
                                          children: [
                                            const SizedBox(height: 88,),
                                            Text(
                                              caffeineStatus,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(height: 10,),
                                            Text(
                                              "$roundedAmount mg",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(height: 10,),
                                            const SizedBox(height : 60),
                                            ElevatedButton(
                                              onPressed: () {
                                                showModalBottomSheet(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                    context: context,
                                                    builder: (context) {
                                                      return BlocProvider<CaffeineDetailedBloc>.value(
                                                          value: bloc, child: const AddCaffeinePopup());
                                                    });
                                              },
                                              style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all(Colors.white),
                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(18.0),
                                                  ),
                                                ),
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.all(18.0),
                                                child: Text("Add consumed drink",
                                                    style: TextStyle(color: Colors.black)),
                                              ),
                                            ),
                                          ],
                                        ),

                                      ],
                                    ),
                                  ],
                                );
                              }
                            },
                          )
                        ],
                      ),
                    ),

                    const Text(
                      "Consumption history",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Expanded(
                      child: CaffeineList(caffeineList: listOfCaffeine),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

class CaffeineList extends StatelessWidget {
  final List<CaffeineRecord> caffeineList;

  const CaffeineList({
    Key? key,
    required this.caffeineList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: caffeineList.length,
      itemBuilder: (BuildContext context, int index) {
        final timeConsumed = caffeineList[index].timeConsumed.toDate();
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final yesterday = DateTime(now.year, now.month, now.day - 1);
        String dateText;
        if (timeConsumed.isAfter(today)) {
          dateText = "TODAY " +
              timeConsumed.hour.toString().padLeft(2, '0') +
              ":" +
              timeConsumed.minute.toString().padLeft(2, '0');
        } else if (timeConsumed.isAfter(yesterday)) {
          dateText = "YESTERDAY " +
              timeConsumed.hour.toString().padLeft(2, '0') +
              ":" +
              timeConsumed.minute.toString().padLeft(2, '0');
        } else {
          dateText = timeConsumed.day.toString().padLeft(2, '0') +
              "/" +
              timeConsumed.month.toString().padLeft(2, '0') +
              "/" +
              timeConsumed.year.toString() +
              " " +
              timeConsumed.hour.toString().padLeft(2, '0') +
              ":" +
              timeConsumed.minute.toString().padLeft(2, '0');
        }
        return CaffeineRecordCard(
          id: caffeineList[index].id,
          dateText: dateText,
          product: caffeineList[index].product,
          caffeineAmount: caffeineList[index].caffeineAmount,
        );
      },
    );
  }
}

class CaffeineRecordCard extends StatelessWidget {
  const CaffeineRecordCard({
    super.key,
    required this.dateText,
    required this.id,
    required this.product,
    required this.caffeineAmount,
  });

  final String dateText;
  final String id;
  final String product;
  final double caffeineAmount;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 20,),
              Text(product),
              const SizedBox(width: 10),
              Text('$caffeineAmount mg'),
              const SizedBox(width: 10),
              Text(dateText),
            ],
          ),
          //TODO: implement next sprint!
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.black),
            onPressed: () {
              context.read<CaffeineDetailedBloc>().add(DeleteCaffeine(id: id));
              context.read<CaffeineDetailedBloc>().add(const FetchAllCaffeine());
            },
          ),
        ],
      ),
    );
  }
}

class AddCaffeinePopup extends StatefulWidget {
  const AddCaffeinePopup({Key? key}) : super(key: key);

  @override
  _AddCaffeinePopupState createState() => _AddCaffeinePopupState();
}

class _AddCaffeinePopupState extends State<AddCaffeinePopup> {
  final Map<int, Widget> _tabs = {
    0: const Text('Quick add'),
    1: const Text('Custom add'),
  };

  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CaffeineDetailedBloc>(context);
    return Container(
      color: const Color(0xFFEFECEC),
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          const SizedBox(height: 16.0),
          CupertinoSlidingSegmentedControl(
            groupValue: _selectedTab,
            children: _tabs,
            onValueChanged: (value) {
              setState(() {
                _selectedTab = value!;
              });
            },
            backgroundColor: Colors.grey,
            thumbColor: Colors.white,
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: [
                // Drink tab
                BlocProvider<CaffeineDetailedBloc>.value(
                  value: bloc,
                  child: QuickAddGrid(),
                ),
                // Food tab
                BlocProvider<CaffeineDetailedBloc>.value(
                  value: bloc,
                  child: CustomAddSliders(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomAddSliders extends StatefulWidget {
  @override
  _CustomAddSlidersState createState() => _CustomAddSlidersState();
}

class _CustomAddSlidersState extends State<CustomAddSliders> {
  double _sliderValue1 = 0;
  double _sliderValue2 = 100;
  double _sliderValue3 = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            Container(
              margin: const EdgeInsets.only(left: 16.0),
              child: const Text(
                '0 mg/100ml',
                style: TextStyle(fontSize: 14.0),
              ),
            ),
            const Text(
              'Caffeine content',
              style: TextStyle(fontSize: 24.0),
            ),
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: const Text(
                '60 mg/100ml',
                style: TextStyle(fontSize: 14.0),
              ),
            ),
          ],
        ),
        Slider(
          value: _sliderValue1,
          onChanged: (newValue) {
            setState(() {
              _sliderValue1 = newValue;
            });
          },
          min: 0,
          max: 60,
          divisions: 12,
          label: '$_sliderValue1 mg/ml',
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            Container(
              margin: const EdgeInsets.only(left: 16.0),
              child: const Text(
                '100 ml',
                style: TextStyle(fontSize: 14.0),
              ),
            ),
            const Text(
              'Volume of drink',
              style: TextStyle(fontSize: 24.0),
            ),
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: const Text(
                '500 ml',
                style: TextStyle(fontSize: 14.0),
              ),
            ),
          ],
        ),
        Slider(
          value: _sliderValue2,
          onChanged: (newValue) {
            setState(() {
              _sliderValue2 = newValue;
            });
          },
          min: 100,
          max: 500,
          divisions: 8,
          label: '$_sliderValue2 ml',
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            Container(
              margin: const EdgeInsets.only(left: 16.0),
              child: const Text(
                'Now      ',
                style: TextStyle(fontSize: 14.0),
              ),
            ),
            const Text(
              'Hours since ingested',
              style: TextStyle(fontSize: 24.0),
            ),
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: const Text(
                '10 hours',
                style: TextStyle(fontSize: 14.0),
              ),
            ),
          ],
        ),
        Slider(
          value: _sliderValue3,
          onChanged: (newValue) {
            setState(() {
              _sliderValue3 = newValue;
            });
          },
          min: 0,
          max: 10,
          divisions: 10,
          label: '$_sliderValue3 hour(s)',
        ),
        ElevatedButton(
          onPressed: () {
            BlocProvider.of<CaffeineDetailedBloc>(context).add(
              AddCaffeine(
                drinkType: "Custom drink",
                amount: _sliderValue1 * _sliderValue2 / 100,
                timeSince: _sliderValue3,
              ),
            );
            BlocProvider.of<CaffeineDetailedBloc>(context).add(
              FetchAllCaffeine(),
            );
            Navigator.pop(context);
          },
          child: Text("Add drink"),
        )
      ],
    );
  }
}

List<CaffeineCardOptions> drinks = [
  CaffeineCardOptions(product: "Small Coffee", caffeineAmount: 80),
  CaffeineCardOptions(product: "Large Coffee", caffeineAmount: 120),
  CaffeineCardOptions(product: "Espresso", caffeineAmount: 50),
  CaffeineCardOptions(product: "Red Bull", caffeineAmount: 150),
  CaffeineCardOptions(product: "Nocco", caffeineAmount: 180),
  CaffeineCardOptions(product: "Celsius", caffeineAmount: 200),
];

class CaffeineCardOptions {
  final String product;
  final double caffeineAmount;

  CaffeineCardOptions({
    required this.product,
    required this.caffeineAmount,
  });
}

class QuickAddGrid extends StatefulWidget {
  @override
  _QuickAddGridState createState() => _QuickAddGridState();
}

class _QuickAddGridState extends State<QuickAddGrid> {
  double _sliderValue = 0.0;
  int _selectedCardIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.transparent,
          height: 300,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 3,  
              children: List.generate(6, (index) {
                final product = drinks[index].product;
                final amount = drinks[index].caffeineAmount;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCardIndex = index;
                    });
                  },
                  child: Card(
                    color: _selectedCardIndex == index
                        ? Colors.blue
                        : Colors.white,
                    child: Center(
                      child: Text(
                        '$product\n$amount mg',
                        style: TextStyle(
                          color: _selectedCardIndex == index
                              ? Colors.white
                              : Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            Container(
              margin: const EdgeInsets.only(left: 16.0),
              child: const Text(
                'Now      ',
                style: TextStyle(fontSize: 14.0),
              ),
            ),
            const Text(
              'Hours since ingested',
              style: TextStyle(fontSize: 24.0),
            ),
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: const Text(
                '10 hours',
                style: TextStyle(fontSize: 14.0),
              ),
            ),
          ],
        ),
        Container(
          color: Colors.transparent,
          height: 50,
          child: Center(
            child: SliderTheme(
              data: SliderThemeData(
                showValueIndicator: ShowValueIndicator.always,
                valueIndicatorTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Slider(
                value: _sliderValue,
                min: 0,
                max: 10,
                divisions: 20,
                onChanged: (newValue) {
                  setState(() {
                    _sliderValue = newValue;
                  });
                },
                label: '$_sliderValue',
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_selectedCardIndex == -1) {
              showErrorDialog(context, "Please select a drink");
            }
            context.read<CaffeineDetailedBloc>().add(
                  AddCaffeine(
                    amount: drinks[_selectedCardIndex].caffeineAmount,
                    drinkType: drinks[_selectedCardIndex].product,
                    timeSince: _sliderValue,
                  ),
                );
            BlocProvider.of<CaffeineDetailedBloc>(context).add(
              FetchAllCaffeine(),
            );
            Navigator.pop(context);
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Color(0xFF8D3786)),
          ),
          child: const Text("Add"),
        ),
      ],
    );
  }
}

/* class QuickAddGrid extends StatefulWidget {
  @override
  _QuickAddGridState createState() => _QuickAddGridState();
}

class _QuickAddGridState extends State<QuickAddGrid> {
  double _sliderValue = 0.0;
  Card? _selectedCard;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.red,
          height: 300,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              children: List.generate(6, (index) {
                final product = drinks[index].product;
                final amount = drinks[index].caffeineAmount;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCard = Card(
                        color: Colors.blue,
                        child: Center(
                          child: Text(
                            '$product\n$amount mg',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    });
                  },
                  child: Card(
                    color: _selectedCard == null
                        ? Colors.white
                        : _selectedCard?.color,
                    child: Center(
                      child: Text(
                        '$product\n$amount mg',
                        style: TextStyle(
                          color: _selectedCard == null
                              ? Colors.black
                              : Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        Container(
          color: Colors.yellow,
          height: 80,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("0", style: TextStyle(fontSize: 18)),
                    Text("Hours since consumption",
                        style: TextStyle(fontSize: 22)),
                    Text("10", style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              SliderTheme(
                data: SliderThemeData(
                  showValueIndicator: ShowValueIndicator.always,
                  valueIndicatorTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Slider(
                  value: _sliderValue,
                  min: 0,
                  max: 10,
                  divisions: 20,
                  onChanged: (newValue) {
                    setState(() {
                      _sliderValue = newValue;
                    });
                  },
                  label: '$_sliderValue',
                ),
              ),
            ],
          ),
        ),
        ElevatedButton(
            onPressed: () {
              if (_selectedCard == null) {
                // No card selected
                return;
              }

              context.read<CaffeineDetailedBloc>().add(
                    AddCaffeine(amount: 50, drinkType: "Coffee"),
                  );
            },
            child: Text("Add drink"))
      ],
    );
  }
} */

/* List<CaffeineRecord> listCards = [
  CaffeineRecord(
      id: "XXX",
      product: "Kaffe",
      caffeineAmount: 50,
      timeConsumed: Timestamp.fromDate(DateTime.now())),
]; */

class CaffeineRecord {
  final String id;
  final String product;
  final double caffeineAmount;
  final Timestamp timeConsumed;

  CaffeineRecord({
    required this.id,
    required this.product,
    required this.caffeineAmount,
    required this.timeConsumed,
  });
}

/* class _AddCaffeinePopupState extends State<AddCaffeinePopup> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: "Snabbval"),
              Tab(text: "Avancerat"),
            ],
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontSize: 16),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Add Drink page
                Center(
                  child: Text("Add consumed drink"),
                ),
                // History page
                Center(
                  child: Text("Caffeine intake history"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} */

