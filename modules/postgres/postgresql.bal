import choreo_api_test.database as db;

import ballerina/io;
import ballerina/sql;
import ballerinax/postgresql;
import ballerinax/postgresql.driver as _;

// final postgresql:Client dbClientActual = check new (config:dbHost, config:dbUsername, config:dbPassword, config:actualDbName);
// final postgresql:Client dbClientDesired = check new (config:dbHost, config:dbUsername, config:dbPassword, config:desiredDbName);
public configurable string dbHost = "localhost";
configurable string dbUsername = "chalindu";
configurable string dbPassword = "Admin@1234";
configurable string dbName = "choreo_declarative_api_db";
configurable string tableName = "kind";

// final postgresql:Client dbClient = check new (dbHost, dbUsername, dbPassword, dbName);

public isolated client class PostgreSQL {

    *db:Database;

    private final postgresql:Client dbClient;
    private final string tableName;

    public isolated function init() returns error? {
        postgresql:Client dbClient = check new (dbHost, dbUsername, dbPassword, dbName);
        self.dbClient = dbClient;
        self.tableName = tableName;
    }

    isolated resource function post kindResource(db:Resource kind) returns error? {
        if kind?.spec == null && kind?.status == null {
            return error("Kind resource must have at least one of the spec or status fields.");
        }
        sql:ParameterizedQuery kindResourceInsertQuery =
            sql:queryConcat(`INSERT INTO `, getParameterizedTableName(self.tableName), ` (payload) VALUES (${kind.toJsonString()}::jsonb)`);
        _ = check self.dbClient->execute(kindResourceInsertQuery);
    };

    isolated resource function get kindResources(db:SearchQuery searchQuery) returns db:Resource[]|error {
        SearchCriteria searchCriteria = check searchQuery.searchCriteria.cloneWithType();
        sql:ParameterizedQuery selectQuerySuffix = check createSearchQuerySuffix(searchCriteria);
        sql:ParameterizedQuery selectQuery = createFullSearchQuery(searchQuery.responseFilter,
            getParameterizedTableName(self.tableName), selectQuerySuffix);
        io:println(selectQuery);
        stream<KindResultStream, sql:Error?> kindResourceResultStream = self.dbClient->query(selectQuery);
        db:Resource[] kindResult = check transformKindResult(<stream<KindResultStream, sql:Error?>>kindResourceResultStream);
        return kindResult;
    }

    isolated resource function get kindResourceCount(db:SearchCountCriteria searchCountQuery) returns int|error {
        SearchCriteria searchCriteria = check searchCountQuery.cloneWithType();
        sql:ParameterizedQuery selectQuerySuffix = check createSearchQuerySuffix(searchCriteria);
        sql:ParameterizedQuery selectQuery = sql:queryConcat(`SELECT COUNT(*) as COUNT FROM `,
            getParameterizedTableName(self.tableName), ` `, selectQuerySuffix);
        stream<KindResultCountStream, sql:Error?> kindResourceResultStream = self.dbClient->query(selectQuery);
        return transformKindCountResult(<stream<KindResultCountStream>>kindResourceResultStream);
    }

    isolated resource function put kindResource(json metadata, db:Resource kind) returns int?|error {
        sql:ParameterizedQuery kindResourceUpdateQuery = sql:queryConcat(`UPDATE `, getParameterizedTableName(self.tableName),
            ` SET payload = ${kind.toJsonString()}::jsonb WHERE payload->'metadata' = `, `${kind.metadata.toString()}::jsonb`);
        sql:ExecutionResult executionResult = check self.dbClient->execute(kindResourceUpdateQuery);
        return executionResult.affectedRowCount;
    }

    isolated resource function delete kindResource(db:DeleteCriteria deleteQuery) returns int?|error {
        SearchCriteria deleteCriteria = check deleteQuery.cloneWithType();
        sql:ParameterizedQuery deleteQuerySuffix = check createSearchQuerySuffix(deleteCriteria);
        sql:ExecutionResult executionResult = check self.dbClient->execute(sql:queryConcat(`DELETE FROM `,
            getParameterizedTableName(self.tableName), ` `, deleteQuerySuffix));
        return executionResult.affectedRowCount;
    }
}
