class HeatingUnit {
  final String tank1;
  final String tank2;
  final String tank3;
  final String flow1;
  final String flow2;

  HeatingUnit({
    required this.tank1,
    required this.tank2,
    required this.tank3,
    required this.flow1,
    required this.flow2,
  });

  static HeatingUnit fromMap(Map<String, dynamic> heatingUnitData) =>
      HeatingUnit(
          tank1: heatingUnitData['TankT1'].toString(),
          tank2: heatingUnitData['TankT2'].toString(),
          tank3: heatingUnitData['TankT3'].toString(),
          flow1: heatingUnitData['Flow1'].toString(),
          flow2: heatingUnitData['Flow2'].toString());
}
