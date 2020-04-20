import 'package:test/test.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_templates_microservice_dart/pip_template_microservice.dart';

import './BeaconsClientV1Fixture.dart';

var httpConfig = ConfigParams.fromTuples([
  'connection.protocol',
  'http',
  'connection.host',
  'localhost',
  'connection.port',
  3000
]);

void main() {
  group('BeaconsCommandableHttpClientV1', () {
    BeaconsMemoryPersistence persistence;
    BeaconsController controller;
    BeaconsCommandableHttpServiceV1 service;
    BeaconsCommandableHttpClientV1 client;
    BeaconsClientV1Fixture fixture;

    setUp(() async {
      persistence = BeaconsMemoryPersistence();
      persistence.configure(ConfigParams());

      controller = BeaconsController();
      controller.configure(ConfigParams());

      service = BeaconsCommandableHttpServiceV1();
      service.configure(httpConfig);

      client = BeaconsCommandableHttpClientV1();
      client.configure(httpConfig);

      var references = References.fromTuples([
        Descriptor('beacons', 'persistence', 'memory', 'default', '1.0'),
        persistence,
        Descriptor('beacons', 'controller', 'default', 'default', '1.0'),
        controller,
        Descriptor('beacons', 'service', 'http', 'default', '1.0'),
        service,
        Descriptor('beacons', 'client', 'http', 'default', '1.0'),
        client
      ]);
      controller.setReferences(references);
      service.setReferences(references);
      client.setReferences(references);

      fixture = BeaconsClientV1Fixture(client);

      await persistence.open(null);

      await service.open(null);

      await client.open(null);
    });

    tearDown(() async {
      await client.close(null);
      await service.close(null);
      await persistence.close(null);
    });

    test('CRUD Operations', () {
      fixture.testCrudOperations();
    });

    test('Calculate Position', () {
      fixture.testCalculatePosition();
    });
  });
}