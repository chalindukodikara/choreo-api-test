// // Copyright (c) 2024, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.
// //
// // This software is the property of WSO2 LLC. and its suppliers, if any.
// // Dissemination of any information or reproduction of any material contained
// // herein in any form is strictly forbidden, unless permitted by WSO2 expressly.
// // You may not alter or remove any copyright or other notice from copies of this content.

// public type KindResult record {
//     string value;
// };

// enum Field {
//     METADATA = "metadata",
//     SPEC = "spec",
//     STATUS = "status"
// };

// public type Database client object {
//     isolated resource function post kindResource(json kind) returns error?;
//     isolated resource function get kindResources(map<string> searchJsonPathMap, string[] fields) returns KindResult[]|error?;
// };

// public function createPostgreDB() returns Database {
//     return new PostgreSQL();
// };

// // isolated function validateFields(string[] fields) returns string[]|error {
// //     string[] fieldsList = [];
// //     foreach int id in 0 ..< fields.length() {
// //         fieldsList.push(fields[id].toLowerAscii());
// //     }
// //     Field[]|error convertedFields = fieldsList.cloneWithType();
// //     if convertedFields is error {
// //         return error("Please provide valid fields");
// //     }
// //     return fieldsList;
// // };
