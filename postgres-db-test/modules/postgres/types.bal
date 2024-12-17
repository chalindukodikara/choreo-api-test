import choreo_api_test.database as db;

type KindResultStream record {
    string apiversion;
    string kind;
    json metadata;
    json spec?;
};

type KindResultCountStream record {
    int count;
};

public type SearchCriteria record {
    db:Condition[] conditions;
    db:Sort sort?;
    int top?;
    string groupingField?;
};
