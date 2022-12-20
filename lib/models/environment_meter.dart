class EnvironmentMeter {
  String? temperature;
  String? humidity;
  String? illuminance;
  bool? status;
  String? usage;

  EnvironmentMeter(
      {this.temperature,
      this.humidity,
      this.illuminance,
      this.status,
      this.usage});

  static EnvironmentMeter fromMap(Map<String, dynamic> environmentMeter) =>
      EnvironmentMeter(
        temperature: environmentMeter['temperature'].toString(),
        humidity: environmentMeter['humidity'].toString(),
        illuminance: environmentMeter['lux'].toString(),
        status: environmentMeter['status'].toString() == '1' ? true : false,
        usage: environmentMeter['usage'].toString(),
      );

  Map<String, dynamic> asMap() => {
        "temperature": temperature ?? '0.0',
        "humidity": humidity ?? '0.0',
        "lux": illuminance ?? '0.0',
        "status": status == true ? '1' : '0',
        "usage": usage ?? '0.0'
      };
}
