import 'package:flutter/material.dart';

class DashboardCard extends StatefulWidget {
  const DashboardCard({Key? key, this.flex = 1, this.color = Colors.white, this.height = 120, this.child}) : super(key: key);
  final int? flex;
  final Color? color;
  final double? height;
  final Widget? child;

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex!,
      child: Container(
        margin: EdgeInsets.all(10),
        height: widget.height,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: widget.color!,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: widget.child,
      ));
  }
}
