import 'package:json_annotation/json_annotation.dart';

part 'journey.g.dart';

@JsonSerializable()
class Journey {
    @JsonKey(name: "DepartureTime")
    DateTime departureTime;
    @JsonKey(name: "DestinationDisplay")
    String destinationDisplay;
    @JsonKey(name: "Operator")
    Operator journeyOperator;
    @JsonKey(name: "PrimaryIdentifier")
    String primaryIdentifier;
    @JsonKey(name: "Service")
    Service service;

    Journey({
        required this.departureTime,
        required this.destinationDisplay,
        required this.journeyOperator,
        required this.primaryIdentifier,
        required this.service,
    });

    factory Journey.fromJson(Map<String, dynamic> json) => _$JourneyFromJson(json);

    Map<String, dynamic> toJson() => _$JourneyToJson(this);
}

@JsonSerializable()
class Operator {
    @JsonKey(name: "PrimaryIdentifier")
    String primaryIdentifier;
    @JsonKey(name: "PrimaryName")
    String primaryName;

    Operator({
        required this.primaryIdentifier,
        required this.primaryName,
    });

    factory Operator.fromJson(Map<String, dynamic> json) => _$OperatorFromJson(json);

    Map<String, dynamic> toJson() => _$OperatorToJson(this);
}

@JsonSerializable()
class Service {
    @JsonKey(name: "BrandColour")
    String brandColour;
    @JsonKey(name: "BrandDisplayMode")
    String brandDisplayMode;
    @JsonKey(name: "BrandIcon")
    String brandIcon;
    @JsonKey(name: "OperatorRef")
    String operatorRef;
    @JsonKey(name: "PrimaryIdentifier")
    String primaryIdentifier;
    @JsonKey(name: "ServiceName")
    String serviceName;
    @JsonKey(name: "TransportType")
    String transportType;

    Service({
        required this.brandColour,
        required this.brandDisplayMode,
        required this.brandIcon,
        required this.operatorRef,
        required this.primaryIdentifier,
        required this.serviceName,
        required this.transportType,
    });

    factory Service.fromJson(Map<String, dynamic> json) => _$ServiceFromJson(json);

    Map<String, dynamic> toJson() => _$ServiceToJson(this);
}