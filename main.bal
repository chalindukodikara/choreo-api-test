import choreo_api_test.database as db;
import choreo_api_test.postgres;

// import ballerina/http;
import ballerina/io;

public function main() returns error? {
    io:println("Hello, World!");
    db:Database database = check new postgres:PostgreSQL();
    // db:Resource actualStoreData = {"kind": "Component", "spec": {"type": "byocService", "build": {"default": {"port": "999999", "version": "1.x"}}, "source": {"github": {"path": "hello-world", "branch": "main", "repository": "https://github.com/example/choreo-samples/tree/main/hello-world"}}}, "status": {"state": "Running", "completedAt": "1999-06-27"}, "metadata": {"name": "chalindu_300", "orgName": "42c1fb78-c726-49a9-98f4-c067e8297109", "displayName": "Juan James", "projectName": "bailey_davidss"}, "apiVersion": "core.choreo.dev/v1alpha1"};
    // db:Resource desiredStoreData = {"kind": "Component", "spec": {"type": "byocCronjob", "build": {"default": {"port": "999999", "version": "1.x"}}, "source": {"github": {"path": "hello-world", "branch": "main", "repository": "https://github.com/example/choreo-samples/tree/main/hello-world"}}}, "metadata": {"name": "chalindu_300", "orgName": "e9fffc6a-de5f-48d6-a925-f31894732da8", "displayName": "Shelby Rush", "projectName": "lisa_wardss"}, "apiVersion": "core.choreo.dev/v1alpha1"};
    // db:Resource desiredStoreData2 = {"kind": "Component", "spec": {"type": "byocCronjobed", "build": {"default": {"port": "20202", "version": "1.x"}}, "source": {"github": {"path": "hello-worlded", "branch": "mained", "repository": "https://github.com/example/choreo-samples/tree/main/hello-worlded"}}}, "metadata": {"name": "chalindu_300", "orgName": "e9fffc6a-de5f-48d6-a925-f31894732da8", "displayName": "Shelby Rush", "projectName": "lisa_wardss"}, "apiVersion": "core.choreo.dev/v1alpha1"};
    // _ = check database->/kindResource.post(actualStoreData);
    // _ = check database->/kindResource.post(desiredStoreData);
    // _ = check database->/kindResource.post(desiredStoreData);
    // _ = check database->/kindResource.post(desiredStoreData);
    // _ = check database->/kindResource.post(desiredStoreData);

    // int? x = check database->/kindResource.delete(deleteQuery);

    // db:Resource[] searchKindResult = check database->/kindResources(seachQuery);
    // int searchKindResultCount = check database->/kindResourceCount(searchCountQuery);
    // io:println("Search kind initial results, ", searchKindResult, searchKindResult.length(), " ", searchKindResultCount);
    // _ = check database->/kindResource.put(desiredStoreData2.metadata, desiredStoreData2);
    // db:Resource[] searchKindResult2 = check database->/kindResources(seachQuery);
    // io:println("Search kind results after updating, ", searchKindResult2);

    db:Resource test1 = {"kind": "Component", "spec": {"type": "WebApplication", "source": {"type": "git", "sourceRepository": {"github": {"url": "https://github.com/sameerajayasoma/expense-tracker", "path": "/frontend"}}}}, "metadata": {"uid": "e87bf92e-8496-4925-b415-53c2d9c17ec9", "name": "expense-tracker-fronted-1", "labels": [{"key": "part", "value": "frontend"}], "generation": 1, "description": "A sample frontend component to illustrate the ComponentEvent JSON structure", "displayName": "Expense Tracker Frontend", "projectName": "expense-tracker-project-1"}, "apiVersion": "v0.1"};
    db:Resource test2 = {"kind": "Project", "spec": {"components": [{"kind": "Component", "spec": {"type": "WebApplication", "source": {"type": "git", "sourceRepository": {"github": {"url": "https://github.com/sameerajayasoma/expense-tracker", "path": "/frontend"}}}}, "metadata": {"name": "expense-tracker-fronted-1", "labels": [{"key": "part", "value": "frontend"}], "description": "A sample frontend component to illustrate the ComponentEvent JSON structure", "displayName": "Expense Tracker Frontend", "projectName": "expense-tracker-project-1"}, "apiVersion": "v0.1"}], "sourceRepository": {"github": {"url": "https://github.com/sameerajayasoma/expense-tracker", "path": "/"}}}, "status": {"code": "200", "state": "Pending", "message": "Component creation request sent", "completedAt": "2024-04-19T14:19:09.713866796Z", "observedGeneration": 1}, "metadata": {"uid": "470806ef-d7fb-45a8-a5ac-283a0c35c4da", "name": "expense-tracker-project-1", "labels": [{"key": "type", "value": "web"}], "createdAt": "2024-03-19T11:00:00Z", "updatedAt": "2024-03-19T11:30:00Z", "generation": 1, "description": "Expense Tracker Project", "displayName": "Expense Tracker Project"}, "apiVersion": "v0.1"};
    _ = check database->/kindResource.post(test1);
    _ = check database->/kindResource.post(test2);
    db:Resource[] searchKindResult = check database->/kindResources(queryTest);
    io:println("Search kind results, ", searchKindResult);
}

type Status record {
    string state;
    string completedAt;
};

// type Spec record {
//     string type;
//     Build build;
//     Source source;
// };

db:SearchQuery queryTest = {
    "searchCriteria":
    {
        "conditions": [
            {"key": "kind", "value": "Project"},
            {"key": "metadata.name", "value": "expense-tracker-project-1"}
        ],
        "sort": {"key": "metadata.name", "order": "ASC"},
        "top": 10
    },
    "responseFilter": ["SPEC", "STATUS"]
};

db:SearchQuery query = {
    searchCriteria: {
        conditions: [
            {
                key: "metadata.name",
                value: "chalindu_100"
            },
            {
                key: "metadata.projectName",
                value: "jeffrey_henderson"
            },
            {
                key: "metadata.orgName",
                value: "2c0032a1-57d0-491a-94bb-92be740b225f"
            },
            {
                key: "kind",
                value: "Component"
            }
        ]
    },
    responseFilter: [db:SPEC, db:STATUS]
};
db:SearchQuery seachQuery = {
    searchCriteria: {
        conditions: [
            {
                key: "metadata.name",
                value: "chalindu_300"
            },
            {
                key: "kind",
                value: "Component"
            }
        ]
        ,
        sort: {
            key: "metadata.name",
            'order: db:ASC
        },
        top: 10
    },
    responseFilter: [db:SPEC, db:STATUS]
};

db:SearchCountCriteria searchCountQuery = {
    conditions: [
        {
            key: "metadata.name",
            value: "chalindu_300"
        },
        {
            key: "kind",
            value: "Component"
        }
    ],
    groupingField: "metadata.name"
};

db:DeleteCriteria deleteQuery = {
    conditions: [
        {
            key: "metadata.name",
            value: "chalindu_300"
        },
        {
            key: "kind",
            value: "Component"
        }
    ]
};

db:SearchQuery query1 = {
    searchCriteria: {
        conditions: [
            {
                key: "metadata.name",
                value: "elizabeth_anderson"
            },
            {
                key: "kind",
                value: "Project"
            },
            {
                key: "metadata.orgName",
                value: "09fee561-eda4-4644-8eaf-8a838dd32d39"
            }
        ],
        sort: {
            key: "metadata.name",
            'order: db:ASC
        },
        top: 10
    },
    responseFilter: [db:STATUS, db:SPEC]
};

db:SearchQuery query2 = {
    searchCriteria: {
        conditions: [
            {
                key: "metadata.name",
                value: "kevin_ellis"
            }
        ]
    },
    responseFilter: [db:SPEC]
};

// io:println(searchedKindResult);
// json example = {
//     "kind": "Component",
//     "metadata": {
//         "name": "test-component",
//         "projectName": "test-project",
//         "labels": {
//             "app": "test-app"
//         }
//     }
// };
// boolean x = example.status is json;
// io:println(example.kind, example.spec);
