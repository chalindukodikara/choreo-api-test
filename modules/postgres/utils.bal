import choreo_api_test.database as db;

// import ballerina/io;
import ballerina/regex;
import ballerina/sql;

isolated function createSearchQuerySuffix(SearchCriteria searchCriteria) returns sql:ParameterizedQuery|error {
    sql:ParameterizedQuery whereClause = ``;
    sql:ParameterizedQuery condition = ``;
    foreach int conditionId in 0 ..< searchCriteria.conditions.length() {
        condition = sql:queryConcat(check makeBtreeKeyPath(searchCriteria.conditions[conditionId].key),
            getOperator(db:EQUAL), `${searchCriteria.conditions[conditionId].value}`);
        if conditionId == 0 {
            whereClause = sql:queryConcat(whereClause, condition);
        } else {
            whereClause = sql:queryConcat(whereClause, getOperator(db:AND), condition);
        }
    }
    sql:ParameterizedQuery groupByClause = ``;
    if searchCriteria.groupingField != () {
        groupByClause = sql:queryConcat(` GROUP BY `, check makeBtreeKeyPath(<string>searchCriteria.groupingField));
    }
    sql:ParameterizedQuery orderByClause = ``;
    if searchCriteria.sort != () {
        orderByClause = sql:queryConcat(` ORDER BY `, check makeBtreeKeyPath(<string>searchCriteria.sort?.key), ` `,
            getOperator(<db:Order>searchCriteria.sort?.'order));
    }
    sql:ParameterizedQuery limitClause = ``;
    if searchCriteria.top != () {
        limitClause = sql:queryConcat(` LIMIT `, `${<int>searchCriteria.top}`);
    }
    return sql:queryConcat(`WHERE `, whereClause, groupByClause, orderByClause, limitClause);
}

isolated function makeBtreeKeyPath(string keyPath) returns sql:ParameterizedQuery|error {
    sql:ParameterizedQuery condition = ``;
    string[] splittedKey = regex:split(keyPath, "\\.");
    if splittedKey.length() == 0 {
        return error("Invalid key path.");
    } else if splittedKey.length() == 1 {
        condition = sql:queryConcat(`payload->>`, `${splittedKey[0]}`);
    } else {
        condition = sql:queryConcat(`payload->`, `${splittedKey[0]}`);
        foreach int id in 1 ..< splittedKey.length() {
            if (id == splittedKey.length() - 1) {
                condition = sql:queryConcat(condition, `->>`, `${splittedKey[id]}`);
                break;
            }
            condition = sql:queryConcat(condition, `->`, `${splittedKey[id]}`);
        }
    }
    return condition;
}

isolated function getOperator(db:Operator|db:Connective|db:Order operator) returns sql:ParameterizedQuery {
    sql:ParameterizedQuery parameterizedOperator = ``;
    parameterizedOperator.strings = [operator];
    return sql:queryConcat(` `, parameterizedOperator, ` `);
}

isolated function createFullSearchQuery(db:Field[] responseFilter, sql:ParameterizedQuery tableName,
        sql:ParameterizedQuery searchSuffix) returns sql:ParameterizedQuery {
    sql:ParameterizedQuery selectFields = sql:queryConcat(`payload->>'apiVersion' as apiVersion`, `, payload->>'kind' as kind`,
        `, payload->'metadata' as metadata`);
    if responseFilter.indexOf(<db:Field>db:SPEC) != () {
        selectFields = sql:queryConcat(selectFields, `, payload->'spec' as spec`);
    }
    if responseFilter.indexOf(<db:Field>db:STATUS) != () {
        selectFields = sql:queryConcat(selectFields, `, payload->'status' as status`);
    }
    return sql:queryConcat(`SELECT `, selectFields, ` FROM `, tableName, ` `, searchSuffix);
}

isolated function transformKindResult(stream<KindResultStream, sql:Error?> kindResourceResultStream) returns db:Resource[]|error {

    db:Resource[] kindResourceResult = check from KindResultStream x in kindResourceResultStream
        let string apiVersion = x.apiversion, string kind = x.kind, json metadata = x.metadata, json spec = x?.spec,
        anydata a = x["status"], json? status = a is string ? check a.fromJsonString() : ()
        select {
            apiVersion,
            kind,
            metadata,
            spec,
            status
        };
    if kindResourceResult.length() == 0 {
        return [];
    }
    return kindResourceResult;
};

isolated function transformKindCountResult(stream<KindResultCountStream> kindResultCountStream) returns int {
    db:CountOutput[] kindResultCount = from KindResultCountStream x in kindResultCountStream
        let int count = x.count
        select {
            count
        };
    if kindResultCount.length() == 0 {
        return 0;
    }
    return kindResultCount[0].count;
};

isolated function getParameterizedTableName(string tableName) returns sql:ParameterizedQuery {
    sql:ParameterizedQuery parameterizedTableName = ``;
    parameterizedTableName.strings = [tableName];
    return parameterizedTableName;
}
