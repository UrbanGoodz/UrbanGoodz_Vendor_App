import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

import '../controllers/digital_human_controller.dart';
import '../models/digital_human_state.dart';

/// Renders the persona's .riv animation and drives its state machine using the
/// inputs defined in [DigitalHumanStateModel.toRiveInputs].
///
/// Only shown once [RiveAssetManager] confirms the asset exists; otherwise the
/// painted fallback avatar is used.
class RiveDigitalHumanView extends StatefulWidget {
  const RiveDigitalHumanView({
    super.key,
    required this.assetPath,
    required this.controller,
    this.fit = BoxFit.contain,
  });

  final String assetPath;
  final DigitalHumanController controller;
  final BoxFit fit;

  @override
  State<RiveDigitalHumanView> createState() => _RiveDigitalHumanViewState();
}

class _RiveDigitalHumanViewState extends State<RiveDigitalHumanView> {
  rive.StateMachineController? _stateMachine;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted && _stateMachine != null) {
      _pushInputs(_stateMachine!);
    }
  }

  void _onArtboardInit(rive.Artboard artboard) {
    final machineName = _firstStateMachineName(artboard);
    if (machineName == null) return;
    final controller = rive.StateMachineController.fromArtboard(
      artboard,
      machineName,
    );
    if (controller == null) return;
    artboard.addController(controller);
    _stateMachine = controller;
    _pushInputs(controller);
  }

  String? _firstStateMachineName(rive.Artboard artboard) {
    for (final animation in artboard.animations) {
      if (animation is rive.StateMachine) return animation.name;
    }
    return null;
  }

  void _pushInputs(rive.StateMachineController controller) {
    final inputs = widget.controller.currentState.toRiveInputs();
    for (final entry in inputs.entries) {
      final value = entry.value;
      final boolInput = controller.getBoolInput(entry.key);
      if (boolInput != null && value is bool) {
        boolInput.value = value;
        continue;
      }
      final numberInput = controller.getNumberInput(entry.key);
      if (numberInput != null && value is num) {
        numberInput.value = value.toDouble();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return rive.RiveAnimation.asset(
      widget.assetPath,
      fit: widget.fit,
      onInit: _onArtboardInit,
    );
  }
}
