import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthapp/bloc/caffeine_bloc.dart';
import 'package:healthapp/caffeine_repository.dart';
import 'package:healthapp/constants/colors.dart';
import '../../bloc/caffeine_detailed_bloc.dart';
import '../../bloc/quote_bloc.dart';
import '../../caffeine_detailed_view.dart';
import '../dashboard_card.dart';

class QuoteCard extends StatelessWidget {
  const QuoteCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      flex: 5,
      color: quoteCardColor,
      child: BlocBuilder<QuoteBloc, QuoteState>(builder: (context, state) {
        if (state.status == QuoteStatus.loading) {
          return CircularProgressIndicator();
        } else {
          final quote = state.quote;
          return SingleChildScrollView(
            child: Center(
              child: Text(
                quote! + "\n\n- Unknown",
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ),
          );
        }
      }),
    );
  }
}
