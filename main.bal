import ballerina/io;
import ballerina/yaml;

public function main() returns error? {
    string yamlString = check io:fileReadString("component.yaml");
    json jsonData = check yaml:readString(yamlString);
    io:println(jsonData);
}
