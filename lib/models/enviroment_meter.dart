class EnvironmentMeter {
  String? temperature;
  String? humidity;
  String? lux;
  String? status;
  String? usage;

  EnvironmentMeter(
      {this.temperature, this.humidity, this.lux, this.status, this.usage});

  static EnvironmentMeter fromMap(Map<String, dynamic> environmentMeter) =>
      EnvironmentMeter(
        temperature: environmentMeter['temperature'].toString(),
        humidity: environmentMeter['humidity'].toString(),
        lux: environmentMeter['lux'].toString(),
        status: environmentMeter['lux'].toString(),
        usage: environmentMeter['lux'].toString(),
      );

  Map<String, dynamic> asMap() => {
        "temperature": temperature ?? '0.0',
        "humidity": humidity ?? '0.0',
        "lux": lux ?? '0.0',
        "status": lux ?? '0.0',
        "usage": lux ?? '0.0'
      };
}
