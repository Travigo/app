// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Journey _$JourneyFromJson(Map<String, dynamic> json) => Journey(
      departureTime: DateTime.parse(json['DepartureTime'] as String),
      destinationDisplay: json['DestinationDisplay'] as String,
      journeyOperator:
          Operator.fromJson(json['Operator'] as Map<String, dynamic>),
      primaryIdentifier: json['PrimaryIdentifier'] as String,
      service: Service.fromJson(json['Service'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JourneyToJson(Journey instance) => <String, dynamic>{
      'DepartureTime': instance.departureTime.toIso8601String(),
      'DestinationDisplay': instance.destinationDisplay,
      'Operator': instance.journeyOperator,
      'PrimaryIdentifier': instance.primaryIdentifier,
      'Service': instance.service,
    };

Operator _$OperatorFromJson(Map<String, dynamic> json) => Operator(
      primaryIdentifier: json['PrimaryIdentifier'] as String,
      primaryName: json['PrimaryName'] as String,
    );

Map<String, dynamic> _$OperatorToJson(Operator instance) => <String, dynamic>{
      'PrimaryIdentifier': instance.primaryIdentifier,
      'PrimaryName': instance.primaryName,
    };

Service _$ServiceFromJson(Map<String, dynamic> json) => Service(
      brandColour: json['BrandColour'] as String,
      brandDisplayMode: json['BrandDisplayMode'] as String,
      brandIcon: json['BrandIcon'] as String,
      operatorRef: json['OperatorRef'] as String,
      primaryIdentifier: json['PrimaryIdentifier'] as String,
      serviceName: json['ServiceName'] as String,
      transportType: json['TransportType'] as String,
    );

Map<String, dynamic> _$ServiceToJson(Service instance) => <String, dynamic>{
      'BrandColour': instance.brandColour,
      'BrandDisplayMode': instance.brandDisplayMode,
      'BrandIcon': instance.brandIcon,
      'OperatorRef': instance.operatorRef,
      'PrimaryIdentifier': instance.primaryIdentifier,
      'ServiceName': instance.serviceName,
      'TransportType': instance.transportType,
    };
