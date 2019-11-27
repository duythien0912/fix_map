import 'package:fix_map/blocs/blocs.dart';
import 'package:fix_map/blocs/shops/bloc.dart';
import 'package:fix_map/generated/i18n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';

showDownloadDialog(BuildContext context, ShopsBloc bloc) {
  showCupertinoDialog(
      context: context,
      builder: (context) => WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: BlocListener(
              bloc: bloc,
              listener: (context, state) async {
                if (state is ShopsDownloadedState) {
                  Navigator.of(context).pop();
                }
              },
              child: StreamBuilder<double>(
                  stream: bloc.downloadListener,
                  initialData: 0,
                  builder: (context, snapshot) {
                    return CupertinoAlertDialog(
                      title: Text(snapshot.data <= 0.0
                          ? S.of(context).downloadingDataDialogTitle
                          : S.of(context).initializingDataDialogTitle),
                      content: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: snapshot.data <= 0.0
                            ? CupertinoActivityIndicator()
                            : LinearPercentIndicator(
                                lineHeight: 15.0,
                                percent: snapshot.data / 100.0,
                                center: Text(
                                  "${snapshot.data.toStringAsFixed(2)}%",
                                ),
                                linearStrokeCap: LinearStrokeCap.roundAll,
                                progressColor: Theme.of(context).accentColor,
                              ),
                      ),
                    );
                  }),
            ),
          ));
}

void showRequestPermissionDialog(BuildContext context) {
  showCupertinoDialog<String>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(S.of(context).requestPermissionDialogTitle),
      content: Text(S.of(context).requestPermissionDialogContent),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text(S.of(context).doNotAllowLabelButton),
          onPressed: () =>
              Navigator.pop(context, S.of(context).doNotAllowLabelButton),
        ),
        CupertinoDialogAction(
          child: Text(S.of(context).allowLabelButton),
          onPressed: () {
            BlocProvider.of<SettingsBloc>(context)
                .add(SettingsRequestPermissionEvent());
          },
        ),
      ],
    ),
  );
}
