class PowerUnit {
  String? deviceMode;
  String? time;
  String? acVoltage;
  String? acFrequency;
  String? pvInputVoltage;
  String? pvInputPower;
  String? outputApparentPower;
  String? outputActivePower;
  String? batteryVoltage;
  String? batteryCapacity;
  String? chargingCurrent;
  String? batteryDischargeCurrent;
  String? outputVoltage;
  String? outputFrequency;

  PowerUnit({
    required this.deviceMode,
    required this.time,
    required this.acVoltage,
    required this.acFrequency,
    required this.pvInputVoltage,
    required this.pvInputPower,
    required this.outputApparentPower,
    required this.outputActivePower,
    required this.batteryVoltage,
    required this.batteryCapacity,
    required this.chargingCurrent,
    required this.batteryDischargeCurrent,
    required this.outputVoltage,
    required this.outputFrequency,
  });

  static PowerUnit fromMap(Map<String, dynamic> powerUnitData) => PowerUnit(
        deviceMode: powerUnitData['device_mode'],
        time: powerUnitData['time'],
        acVoltage: powerUnitData['ac_voltage'].toString(),
        acFrequency: powerUnitData['ac_frequency'].toString(),
        pvInputVoltage: powerUnitData['pv_input_voltage'].toString(),
        pvInputPower: powerUnitData['pv_input_power'].toString(),
        outputApparentPower: powerUnitData['output_apparent_power'].toString(),
        outputActivePower: powerUnitData['output_active_power'].toString(),
        batteryVoltage: powerUnitData['battery_voltage'].toString(),
        batteryCapacity: powerUnitData['battery_capacity'].toString(),
        chargingCurrent: powerUnitData['charging_current'].toString(),
        batteryDischargeCurrent:
            powerUnitData['battery_discharge_current'].toString(),
        outputVoltage: powerUnitData['output_voltage'].toString(),
        outputFrequency: powerUnitData['output_frequency'].toString(),
      );

  Map<String, dynamic> asMap() => {
        "device_mode": "Line Mode",
        "time": "2022-12-06 15:24:12",
        "ac_voltage": 234.0,
        "ac_frequency": 49.9,
        "pv_input_voltage": 245.0,
        "pv_input_power": 0,
        "output_apparent_power": 0.0,
        "output_active_power": 0.0,
        "battery_voltage": 27.0,
        "battery_capacity": 100,
        "charging_current": 0.0,
        "battery_discharge_current": 0.0,
        "output_voltage": 234.0,
        "output_frequency": 49.9,
      };
}
