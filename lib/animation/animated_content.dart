import 'package:flutter/material.dart';
import 'package:signup/theme/theme.dart';

// Animated Text Field Widget
class AnimatedTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;

  AnimatedTextField({required this.controller, required this.label});

  @override
  _AnimatedTextFieldState createState() => _AnimatedTextFieldState();
}

class _AnimatedTextFieldState extends State<AnimatedTextField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: _focused ? AppTheme.primaryColor : Colors.grey,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.label,
          border: InputBorder.none,
        ),
        onTap: () {
          setState(() {
            _focused = true;
          });
        },
        onEditingComplete: () {
          setState(() {
            _focused = false;
          });
        },
      ),
    );
  }
}

// Animated Button Widget
class AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;

  AnimatedButton({required this.onPressed, required this.label});

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          shape: StadiumBorder(),
        ),
        child: Text(
          widget.label,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

// Animated Content Widget
class AnimatedContent extends StatefulWidget {
  final Widget child;
  final bool show;
  final double leftToRight;
  final double topToBottom;
  final int time;

  const AnimatedContent({
    Key? key,
    required this.child,
    this.show = false,
    this.leftToRight = 0.0,
    this.topToBottom = 0.0,
    this.time = 300,
  }) : super(key: key);

  @override
  AnimatedContentState createState() => AnimatedContentState();
}

class AnimatedContentState extends State<AnimatedContent>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> animationSlideUp;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.time),
    );

    animationSlideUp = Tween<Offset>(
      begin: Offset(widget.leftToRight, widget.topToBottom),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: animationController, curve: Curves.ease),
    );

    if (widget.show) {
      animationController.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget != oldWidget) {
      if (widget.show && !oldWidget.show) {
        animationController.forward(from: 0.0);
      } else if (!widget.show) {
        animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animationSlideUp,
      child: FadeTransition(
        opacity: animationController,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
