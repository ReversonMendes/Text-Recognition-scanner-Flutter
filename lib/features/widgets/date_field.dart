import 'package:brasil_fields/brasil_fields.dart';
import 'package:capture_prime/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DateField extends StatefulWidget {
  final bool fadeDate;
  final TextEditingController dateController;
  final String title;
  const DateField(
      {super.key,
      required this.dateController,
      required this.fadeDate,
      required this.title});

  @override
  State<DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField>
    with SingleTickerProviderStateMixin {
  double bottomAnimationValue = 0;
  double opacityAnimationValue = 0;
  EdgeInsets paddingAnimationValue = EdgeInsets.only(top: 22);

  late TextEditingController dateController;
  late AnimationController _animationController;
  late Animation<Color?> _animation;
  late String title = '';

  FocusNode node = FocusNode();
  @override
  void initState() {
    dateController = widget.dateController;
    title = widget.title;
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    final tween = ColorTween(begin: Colors.grey.withOpacity(0), end: blueColor);

    _animation = tween.animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();

    node.addListener(() {
      if (node.hasFocus) {
        setState(() {
          bottomAnimationValue = 1;
        });
      } else {
        setState(() {
          bottomAnimationValue = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        title != null
            ? Text(
                title,
                style: TextStyle(
                    fontSize: 15, color: Colors.black.withOpacity(0.7)),
              )
            : Text('Data'),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 300),
            tween: Tween(begin: 0, end: widget.fadeDate ? 0 : 1),
            builder: ((_, value, __) => Opacity(
                  opacity: value,
                  child: TextFormField(
                    controller: dateController,
                    focusNode: node,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      DataInputFormatter()
                    ],
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return null;
                      }
                      final components = value.split("/");
                      if (components.length == 3) {
                        final day = int.tryParse(components[0]);
                        final month = int.tryParse(components[1]);
                        final year = int.tryParse(components[2]);
                        if (day != null && month != null && year != null) {
                          final date = DateTime(year, month, day);
                          if (date.year == year &&
                              date.month == month &&
                              date.day == day) {
                            return null;
                          }
                        }
                      }
                      return "wrong date";
                    },
                    onChanged: (value) async {
                      if (value.isNotEmpty) {
                        if (isValidDate(value)) {
                          setState(() {
                            bottomAnimationValue = 0;
                            opacityAnimationValue = 1;
                            paddingAnimationValue = EdgeInsets.only(top: 0);
                          });
                          _animationController.forward();
                        } else {
                          _animationController.reverse();
                          setState(() {
                            bottomAnimationValue = 1;
                            opacityAnimationValue = 0;
                            paddingAnimationValue = EdgeInsets.only(top: 22);
                          });
                        }
                      } else {
                        setState(() {
                          bottomAnimationValue = 0;
                        });
                      }
                    },
                  ),
                )),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: widget.fadeDate ? 0 : 300,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: bottomAnimationValue),
                curve: Curves.easeIn,
                duration: Duration(milliseconds: 500),
                builder: ((context, value, child) => LinearProgressIndicator(
                      value: value,
                      backgroundColor: Colors.grey.withOpacity(0.5),
                      color: Colors.black,
                    )),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: AnimatedPadding(
            curve: Curves.easeIn,
            duration: Duration(milliseconds: 500),
            padding: paddingAnimationValue,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: widget.fadeDate ? 0 : 1),
              duration: Duration(milliseconds: 700),
              builder: ((context, value, child) => Opacity(
                    opacity: value,
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0)
                            .copyWith(bottom: 0),
                        child: Icon(Icons.check_rounded,
                            size: 27,
                            color: _animation.value // _animation.value,
                            ),
                      ),
                    ),
                  )),
            ),
          ),
        ),
      ],
    );
  }

  bool isValidDate(String date) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(date);
  }
}
