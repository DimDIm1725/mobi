import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobiwoom/core/models/drawer_toolbar.dart';
import 'package:mobiwoom/core/utils/utils.dart';
import 'package:mobiwoom/ui/shared/navigation_util.dart';
import 'package:mobiwoom/ui/widgets/drawer.dart';
import 'package:provider/provider.dart';

import '../../core/utils/utils.dart';

class MobiAppBar extends StatefulWidget {
  final Widget child;
  final List<MobiAction> actions;

  MobiAppBar({this.child, this.actions});

  @override
  _MobiAppBarState createState() => _MobiAppBarState();
}

class _MobiAppBarState extends State<MobiAppBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DrawerAndToolbar>(
        builder: (_, indexData, __) => Scaffold(
              drawer: isLargeScreen(context) ? null : MobiDrawer(),
              appBar: AppBar(
                actions: widget.actions
                    ?.map((e) => Visibility(
                          visible: e.onPressed != null,
                          child: IconButton(
                            icon: Icon(
                              e.icon,
                              color: e.iconColor,
                            ),
                            onPressed: e.onPressed,
                          ),
                        ))
                    ?.toList(),
                title: Text(
                  kScreenTitle[indexData.currentIndex],
                  style: TextStyle(color: Colors.white, fontFamily: 'RobotoCondensed'),
                ),
              ),
              body: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  isLargeScreen(context) ? MobiDrawerForWeb() : Container(),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [getChildren(indexData)],
                    ),
                  )
                ],
              ),
            ));
    // return Consumer<DrawerAndToolbar>(
    //   builder: (_, indexData, __) => NestedScrollView(
    //     controller: _scrollController,
    //     body: widget.child,
    //     headerSliverBuilder: (context, innerBoxIsScrolled) {
    //       return <Widget>[
    //         SliverAppBar(
    //           expandedHeight: 90.0,
    //           floating: true,
    //           pinned: true,
    //           snap: false,
    //           centerTitle: false,
    //           actions: widget.actions
    //               ?.map((e) => AnimatedOpacity(
    //                     opacity: collapsed ? 1 : 0,
    //                     duration: Duration(milliseconds: 100),
    //                     child: Visibility(
    //                       visible: e.onPressed != null,
    //                       child: IconButton(
    //                         icon: Icon(e.icon),
    //                         onPressed: e.onPressed,
    //                       ),
    //                     ),
    //                   ))
    //               ?.toList(),
    //           title: AnimatedOpacity(
    //             opacity: collapsed ? 1 : 0,
    //             duration: Duration(milliseconds: 100),
    //             child: Text(
    //               kScreenTitle[indexData.currentIndex],
    //               style: TextStyle(color: Colors.white),
    //             ),
    //           ),
    //           flexibleSpace: FlexibleSpaceBar(
    //             centerTitle: false,
    //             title: AnimatedOpacity(
    //               opacity: collapsed ? 0 : 1,
    //               duration: Duration(milliseconds: 100),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Expanded(
    //                     child: Text(
    //                       kScreenTitle[indexData.currentIndex],
    //                       style: Theme.of(context).textTheme.subtitle2.copyWith(
    //                             fontWeight: FontWeight.bold,
    //                             color: Colors.white,
    //                           ),
    //                       maxLines: 1,
    //                       overflow: TextOverflow.ellipsis,
    //                     ),
    //                   ),
    //                   ...(widget.actions
    //                           ?.map((e) => Visibility(
    //                                 visible: e.onPressed != null,
    //                                 child: InkWell(
    //                                   borderRadius: BorderRadius.circular(16),
    //                                   child: Padding(
    //                                     padding: const EdgeInsets.symmetric(
    //                                       vertical: 8,
    //                                       horizontal: 8,
    //                                     ),
    //                                     child: Icon(
    //                                       e.icon,
    //                                       size: 16,
    //                                       color: e.onPressed == null ? Colors.grey : e.iconColor ?? Colors.white,
    //                                     ),
    //                                   ),
    //                                   onTap: e.onPressed,
    //                                 ),
    //                               ))
    //                           ?.toList() ??
    //                       []),
    //                 ],
    //               ),
    //             ),
    //             titlePadding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
    //           ),
    //         ),
    //       ];
    //     },
    //   ),
    // );
  }

  getChildren(indexData) {
    if (indexData.currentIndex != kPartnersMapScreen &&
        indexData.currentIndex != kParkingMap &&
        isLargeScreen(context)) {
      return Container(
        child: Center(child: widget.child),
        width: getLargeScreenWidth(context),
      );
    } else {
      return Expanded(child: widget.child);
    }
  }
}

class MobiAction {
  Function onPressed;
  IconData icon;
  Color iconColor;
  Opacity opacity;

  MobiAction({this.onPressed, this.icon, this.iconColor, this.opacity});
}
