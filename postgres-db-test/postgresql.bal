// // Copyright (c) 2023, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.
// //
// // This software is the property of WSO2 LLC. and its suppliers, if any.
// // Dissemination of any information or reproduction of any material contained
// // herein in any form is strictly forbidden, unless permitted by WSO2 expressly.
// // You may not alter or remove any copyright or other notice from copies of this content.
// import ballerina/regex;
// import ballerina/sql;
// import ballerinax/postgresql;
// import ballerinax/postgresql.driver as _;

// string dbHost = "localhost";
// string dbUsername = "chalindu";
// string dbPassword = "Admin@1234";
// string desiredDbName = "desired_store";
// string actualDbName = "desired_store";

// final postgresql:Client dbClientActual = check new (dbHost, dbUsername, dbPassword, actualDbName);
// final postgresql:Client dbClientDesired = check new (dbHost, dbUsername, dbPassword, desiredDbName);

// isolated client class PostgreSQL {

//     *Database;

//     isolated resource function post kindResource(json kind) returns error? {
//         transaction {
//             sql:ParameterizedQuery kindResourceinsertQuery = `INSERT INTO kind (value) VALUES (${kind.toJsonString()}::jsonb)`;
//             if kind.status is json {
//                 _ = check dbClientActual->execute(kindResourceinsertQuery);
//             } else {
//                 _ = check dbClientDesired->execute(kindResourceinsertQuery);
//             }
//             check commit;
//         } on fail error e {
//             return e;
//         }
//     };

//     isolated resource function get kindResources(map<string> searchJsonPathMap, string[] fields) returns KindResult[]|error? {
//         Field[]|error fieldsList = fields.cloneWithType();
//         if fieldsList is error {
//             return error("Please provide valid fields");
//         }
//         sql:ParameterizedQuery initialQueryPart = `SELECT * FROM kind WHERE `;
//         sql:ParameterizedQuery whereClause = ``;
//         sql:ParameterizedQuery condition = ``;
//         string[] result = [];
//         foreach int jsonKeyId in 0 ..< searchJsonPathMap.keys().length() {
//             // io:println("key: ", searchJsonPathMap.keys()[jsonKeyId]);
//             result = regex:split(searchJsonPathMap.keys()[jsonKeyId], "\\.");
//             // io:println("result: ", result);
//             if result.length() == 0 {
//                 return error("Invalid search path");
//             } else if result.length() == 1 {
//                 condition = sql:queryConcat(`value->>`, `${result[0]}`, `=`, `${searchJsonPathMap.get(searchJsonPathMap.keys()[jsonKeyId])}`);
//             } else {
//                 condition = sql:queryConcat(`value->`, `${result[0]}`);
//                 foreach int id in 1 ..< result.length() {
//                     // io:println("id: ", id);
//                     if (id == result.length() - 1) {
//                         condition = sql:queryConcat(condition, `->>`, `${result[id]}`, `=`, `${searchJsonPathMap.get(searchJsonPathMap.keys()[jsonKeyId])}`);
//                         break;
//                     }
//                     condition = sql:queryConcat(condition, `->`, `${result[id]}`);
//                 }
//             }
//             if jsonKeyId == 0 {
//                 whereClause = sql:queryConcat(whereClause, condition);
//             } else {
//                 whereClause = sql:queryConcat(whereClause, ` AND `, condition);
//             }
//         }
//         sql:ParameterizedQuery sqlQuery = sql:queryConcat(initialQueryPart, whereClause);
//         if fields.indexOf(STATUS) != () {
//             stream<KindResult, sql:Error?> kindResourceResultStream = dbClientActual->query(sqlQuery);
//             return check self.transformKindResult(<stream<KindResult>>kindResourceResultStream);
//         } else {
//             stream<KindResult, sql:Error?> kindResourceResultStream = dbClientDesired->query(sqlQuery);
//             return check self.transformKindResult(<stream<KindResult>>kindResourceResultStream);
//         }
//     }

//     isolated function transformKindResult(stream<KindResult> kindResourceResultStream) returns KindResult[]|error {
//         KindResult[] kindResourceResult = from var x in kindResourceResultStream
//             let var value = x.value
//             group by value
//             select {
//                 value: value
//             };
//         return kindResourceResult;
//     };
// }
