import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

typedef ItemBuilder<T> = Widget Function(
  T item,
);

class DynamicListView<T> extends StatefulWidget {
  final Axis axis;
  final List<dynamic> data;
  final ItemBuilder<dynamic> itemBuilder;
  @override
  final GlobalKey? globalKey;

  DynamicListView({super.key,   required this.data,
      this.axis = Axis.vertical,
      required this.itemBuilder,
      this.globalKey});

  @override
  _DynamicListViewState createState() => _DynamicListViewState();
}

class _DynamicListViewState<T> extends State<DynamicListView<T>> {
  final duration = 500;
  final delay = 0;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // key:  widget.key?? UniqueKey(),
      key: widget.key,
      scrollDirection: widget.axis,
      itemCount: widget.data.length,
      itemBuilder: (context, index) {
        return AnimationConfiguration.staggeredList(
          position: index,
          //  width: 200,
          //  height: 200,
          duration: Duration(milliseconds: duration),
          delay: Duration(milliseconds: delay),

          // color: Colors.blue[index * 100],
          child: SlideAnimation(
            duration: Duration(milliseconds: duration),
            verticalOffset: 50,
            delay: Duration(milliseconds: 0),
            child: FadeInAnimation(
              duration: Duration(milliseconds: duration),
              delay: Duration(milliseconds: delay),
              curve: Curves.easeInOut,
              child: widget.itemBuilder(
                widget.data[index],
              ),
            ),
          ),
        );
      },
    );
  }
}
