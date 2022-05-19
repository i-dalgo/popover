import 'package:flutter/material.dart';
import 'utils/build_context_extension.dart';

// [FORK-MODIFICATION]
class PopoverBlack extends StatefulWidget {
  final BuildContext context;
  final BorderRadiusDirectional borderRadius;

  PopoverBlack({
    required this.context,
    required this.borderRadius,
  });

  _PopoverBlackState createState() => _PopoverBlackState();
}
class _PopoverBlackState extends State<PopoverBlack>
  with SingleTickerProviderStateMixin {
  late Animation<double> alphaAnim;
  late AnimationController alphaController;
  late RRect highlight;

  @override
  void initState() {
    alphaController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    alphaAnim = Tween<double>(begin: 0, end: 4000).animate(alphaController);
    alphaController.forward();

    super.initState();
  }

  @override
  void dispose() {
    alphaController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, __) {
        _configureHighlight();
        return ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withAlpha(alphaAnim.value.toInt()),
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: false,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(color: const Color(0x80000000))
                  )
                )
              ),
              Positioned(
                top: highlight.top,
                left: highlight.left,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: highlight.tlRadius,
                      topRight: highlight.trRadius,
                      bottomLeft: highlight.blRadius,
                      bottomRight: highlight.brRadius,
                    )
                  ),
                  width: highlight.width,
                  height: highlight.height,
                ),
              )
            ],
          ),
        );
      }
    );
  }

  void _configureHighlight() {
    final offset = BuildContextExtension.getWidgetLocalToGlobal(widget.context);
    final bounds = BuildContextExtension.getWidgetBounds(widget.context);

    highlight = RRect.fromRectAndCorners(
      Rect.fromLTWH(
        offset.dx,
        offset.dy,
        bounds.width,
        bounds.height,
      ),
      topLeft: widget.borderRadius.topStart,
      topRight: widget.borderRadius.topEnd,
      bottomLeft: widget.borderRadius.bottomStart,
      bottomRight: widget.borderRadius.bottomEnd,
    );
  }
}