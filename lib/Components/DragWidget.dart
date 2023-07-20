import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Components/FriendCard.dart';
import 'package:flutter_app/Services/Entity/Profile.dart';

enum Swipe {left, right, none}

class DragWidget extends StatefulWidget {
  final UserProfile userprofile;
  final int index;
  final ValueNotifier<Swipe> swipeNotifier;

  const DragWidget({
    super.key,
    required this.userprofile,
    required this.index,
    required this.swipeNotifier
  });

  @override
  State<DragWidget> createState() => _DragWidgetState();
}

class _DragWidgetState extends State<DragWidget> {
  ValueNotifier<Swipe> swipeNotifier = ValueNotifier(Swipe.none);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Draggable<int>(
        data: widget.index,
        feedback: Material(
          color: Colors.transparent,
          child: ValueListenableBuilder(
            valueListenable: swipeNotifier,
            builder: (context, swipe, _){
              return RotationTransition(
                  turns: swipe != Swipe.none
                      ? swipe == Swipe.left
                      ? const AlwaysStoppedAnimation(-15/360)
                      : const AlwaysStoppedAnimation(15/360)
                      : const AlwaysStoppedAnimation(0),
                child: FriendCard(userProfile: widget.userprofile)
              );
            }),
        ),
        onDragUpdate: (DragUpdateDetails dragUpdateDetail){
          if(dragUpdateDetail.delta.dx > 0 &&
            dragUpdateDetail.globalPosition.dx > MediaQuery.of(context).size.width/2){
              swipeNotifier.value = Swipe.right;
            }

          if(dragUpdateDetail.delta.dx < 0 &&
            dragUpdateDetail.globalPosition.dx < MediaQuery.of(context).size.width/2){
              swipeNotifier.value = Swipe.left;
           }
        },

        onDragEnd: (drag){
          swipeNotifier.value = Swipe.none;
        },

        childWhenDragging: Container(color: Colors.transparent),
        child: FriendCard(userProfile: widget.userprofile),
      ),
    );
  }
}
