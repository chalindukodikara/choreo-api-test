import ballerina/io;
import ballerina/sql;
import ballerina/yaml;
// import ballerina/uuid;
import ballerinax/postgresql;
import ballerinax/postgresql.driver as _;

string dbHost = "localhost";
string dbUsername = "chalindu";

string dbPassword = "Admin@1234";
string dbName = "postgres";

final postgresql:Client dbClient = check new (dbHost, dbUsername, dbPassword, dbName);

public isolated function insertKind() returns int|error {

    json value = check yaml:readFile("componentBal.yaml");

    transaction {
        sql:ParameterizedQuery kindInsertQuery =
            `INSERT INTO kind (value) VALUES (${value.toJsonString()}::jsonb)`;
        sql:ExecutionResult kindExecutionResult = check dbClient->execute(kindInsertQuery);
        // int lastInsertId = <int>kindExecutionResult.lastInsertId;
        check commit;
        // return lastInsertId;
        return 1;
    } on fail error e {
        return e;
    }
}

public isolated function searchKind() returns error? {

    string port = "9090";
    string projectName = "later";

    // sql:ParameterizedQuery kindSearchQuery =
    //         `SELECT * FROM kind WHERE (value #> Array['spec', 'build', 'buildpack', 'port']) @> ${port}`;
    // sql:ParameterizedQuery kindSearchQuery =
    //         `SELECT * FROM kind WHERE value->'metadata'->>'projectName'=${projectName}`;
    // sql:ParameterizedQuery kindSearchQuery =
    //         `SELECT * FROM kind WHERE value->'build'->'default'->>'port'=${port}`;
    sql:ParameterizedQuery kindSearchQuery = `SELECT * FROM kind WHERE (value->'metadata') @> '{"projectName": "project"}' and (value ->> 'kind')='Component'`;
    stream<ComponentKindResultStream, sql:Error?> componentKindResultStream = dbClient->query(kindSearchQuery);
    ComponentKindResultStream[]|error componentKinds = from var x in componentKindResultStream
        let var value = x.value
        group by value
        select {
            value: value
        };
    io:println(componentKinds);
}

type ComponentKindResultStream record {
    string value;
};
