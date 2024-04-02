// import ballerina/http;
import ballerina/io;

// import ballerina/yaml;

// service / on new http:Listener(9090) {

//     // This function responds with `string` value `Hello, World!` to HTTP GET requests.
//     resource function post jsonFromYaml(@http:Payload string yamlContent) returns json|error {
//         json jsonData = check yaml:readString(yamlContent);
//         io:println(jsonData);
//         return jsonData;``
//     }
// }

type Example record {
    int id;
    string? name;
    string address?;
};

public function main() returns error? {
    // Read the JSON file
    // json jsonValue = check io:fileReadJson("resources/sample.json");
    // string yamlString = check io:fileReadString("component.yaml");
    // json jsonData = check yaml:readString(yamlString);
    // // io:println(jsonData);
    // Example example = {
    //     id: 1,
    //     name: null
    // };
    // io:println(example, example.address is (), example.address is string);
    // Convert the JSON value to the YAML value
    // string yamlValue = check convertToYaml(jsonValue);

    // Encode the YAML string into base64 encoding
    // string encodedString = check (check mime:base64Encode(yamlValue)).ensureType();

    // io:println(yamlValue);

    //## PostgreSQL Operations ##/////////////////////////////////////////////////////
    int|error insertedId = insertKind();
    io:println(insertedId);
    error? searchedKindResult = searchKind();
    io:println(searchedKindResult);
    //## Mongo DB Operations ##/////////////////////////////////////////////////////
    // error? mongoInsert = insertData();
    // error? mongoRetrieve = retrieveData();
}

// function convertToYaml(json input) returns string|error {
//     // Converting the JSON value into a YAML value.
//     // This returns an array of YAML values.
//     // The blockLevel indicates the maximum depth level for a block
//     string[] yamlArray = check yaml:writeString(input, blockLevel = 10);
//     json yamlArray1 = check yaml:writeString(input, blockLevel = 10);
//     io:println(yamlArray);
//     io:println(yamlArray1);
//     json yamlArray2 = check yaml:readString(string:'join("\n", ...yamlArray));
//     io:println(yamlArray2);
//     // Finally, we join the array using a new line character to build the YAML string
//     return string:'join("\n", ...yamlArray);
// }
