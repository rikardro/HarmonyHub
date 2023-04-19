import 'dart:developer';

import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthapp/bloc/caffeine_bloc.dart';

import 'bloc/caffeine_detailed_bloc.dart';

class CaffeineDetailedView extends StatefulWidget {
  const CaffeineDetailedView({super.key});

  @override
  State<CaffeineDetailedView> createState() => _CaffeineDetailedViewState();
}

class _CaffeineDetailedViewState extends State<CaffeineDetailedView> {
  @override
  Widget build(BuildContext context) {
    context.read<CaffeineBloc>().add(const FetchCaffeine());
    context.read<CaffeineDetailedBloc>().add(const FetchAllCaffeine());
    return BlocBuilder<CaffeineDetailedBloc, CaffeineDetailedState>(
      builder: (context, state) {
        if (state.status == CaffeineDetailedStatus.success) {
          final List<CaffeineRecord> listOfCaffeine = state.caffeineList ?? [];
          return Scaffold(
            appBar: AppBar(
              title: const Text(""),
              backgroundColor: const Color(0xFF8D3786),
            ),
            backgroundColor: const Color(0xFF8D3786),
            body: Center(
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
                            if (state.status == CaffeineStatus.loading) {
                              return const CircularProgressIndicator();
                            } else {
                              return Column(
                                children: [
                                  Text(
                                    "$caffeineAmount mg",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    caffeineStatus,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white),
                                  ),
                                ],
                              );
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      //TODO: Why does this not work?
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return const AddCaffeinePopup();
                        },
                      );
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
                  const SizedBox(height: 50),
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product),
              const SizedBox(width: 10),
              Text('$caffeineAmount mg'),
              const SizedBox(width: 10),
              Text(dateText),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {},
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
                QuickAddGrid(),
                // Food tab
                CustomAddSliders(),
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
  double _sliderValue2 = 0;
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
                '0 mg/ml',
                style: TextStyle(fontSize: 14.0),
              ),
            ),
            const Text(
              'caffeine content',
              style: TextStyle(fontSize: 24.0),
            ),
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: const Text(
                '50 mg/ml',
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
          max: 50,
          divisions: 10,
          label: '$_sliderValue1',
        ),
        Slider(
          value: _sliderValue2,
          onChanged: (newValue) {
            setState(() {
              _sliderValue2 = newValue;
            });
          },
          min: 0,
          max: 100,
          divisions: 10,
          label: '$_sliderValue2',
        ),
        Slider(
          value: _sliderValue3,
          onChanged: (newValue) {
            setState(() {
              _sliderValue3 = newValue;
            });
          },
          min: 0,
          max: 100,
          divisions: 10,
          label: '$_sliderValue3',
        ),
      ],
    );
  }
}

class QuickAddGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GridView.count(
        crossAxisCount: 3,
        children: List.generate(6, (index) {
          return Card(
            color: Colors.white,
            child: Center(
              child: Text(
                'Card ${index + 1}',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          );
        }),
      ),
    );
  }
}

List<CaffeineRecord> listCards = [
  CaffeineRecord(
      id: "XXX",
      product: "Kaffe",
      caffeineAmount: 50,
      timeConsumed: Timestamp.fromDate(DateTime.now())),
];

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

