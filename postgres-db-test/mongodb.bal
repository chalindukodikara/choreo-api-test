// import ballerina/io;
// import ballerinax/mongodb;

// configurable string host = "localhost";
// configurable int port = 27017;
// configurable string username = "SA";
// configurable string password = "Password123";
// configurable string database = "kinds";
// configurable string collection = "component";

// mongodb:ConnectionConfig mongoConfig = {
//     connection: {
//         host: host,
//         port: port,
//         auth: {
//             username: username,
//             password: password
//         },
//         options: {
//             sslEnabled: false,
//             serverSelectionTimeout: 5000
//         }
//     },
//     databaseName: database
// };

// mongodb:Client mongoClient = check new (mongoConfig);

// public function insertData() returns error? {

//     string collection = "component";
//     map<json> doc = {
//         "apiVersion": "core.choreo.dev/v1alpha1",
//         "kind": "Component",
//         "metadata": {
//             "name": "MI-NEW-1",
//             "projectName": "udqn"
//         },
//         "spec": {
//             "type": "miApiService",
//             "source": {
//                 "github": {
//                     "repository": "https://github.com/chalindukodikara/choreo-samples",
//                     "branch": "main",
//                     "path": "hello-world-mi"
//                 }
//             },
//             "build": {
//                 "buildpack": {
//                     "language": "",
//                     "version": ""
//                 }
//             }
//         }
//     };

//     check mongoClient->insert(doc, collection);

// }

// public function retrieveData() returns error? {

//     string collection = "component";
//     map<json> filterData = {"spec.build.buildpack.port": {"$lt": 8582}};

//     stream<map<json>, error?>|mongodb:Error resultStream = check mongoClient->find(collection, filter = filterData);
//     if resultStream is stream<map<json>, error?> {
//         map<json>[]|error componentKindsFromMongo = check from map<json> x in resultStream
//             select {
//                 x

//                 // };
//                 io:println(componentKindsFromMongo)
//             ;
//     }
// }

// type ComponentKindResultStreamMongo record {
//     json kind;
// };
