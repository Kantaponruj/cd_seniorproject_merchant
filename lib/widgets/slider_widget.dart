import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class BuildSlider extends StatefulWidget {
  BuildSlider(
      {Key key, @required this.min, @required this.max, @required this.interval, @required this.stepSize, this.showTicks, @required this.minorTicksPerInterval, this.showLabels, @required this.value, @required this.onChanged,})
      : super(key: key);

  final dynamic min;
  final dynamic max;
  final double interval;
  final double stepSize;
  final bool showTicks;
  final int minorTicksPerInterval;
  final bool showLabels;
  final dynamic value;
  final Function(dynamic) onChanged;

  @override
  _BuildSliderState createState() => _BuildSliderState();
}

class _BuildSliderState extends State<BuildSlider> {
  @override
  Widget build(BuildContext context) {
    return SfSlider(
      min: widget.min,
      max: widget.max,
      interval: widget.interval,
      stepSize: widget.stepSize,
      showTicks: true,
      minorTicksPerInterval: widget.minorTicksPerInterval,
      showLabels: true,
      value: widget.value,
      onChanged: widget.onChanged,
    );
  }
}
