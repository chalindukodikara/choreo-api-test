public enum Field {
    SPEC,
    STATUS
};

public enum Operator {
    EQUAL = "="
};

public enum Order {
    ASC = "ASC",
    DESC = "DESC"
};

public enum Connective {
    AND = "AND"
};

public type Resource record {
    string apiVersion;
    string kind;
    json metadata;
    json spec?;
    json status?;
};

public type SearchQuery record {
    SearchCriteria searchCriteria;
    Field[] responseFilter;
};

public type SearchCriteria record {
    Condition[] conditions;
    Sort sort?;
    int top?;
    // Connective[] conditionConnectives;
    // string groupingField?;
};

public type SearchCountCriteria record {
    Condition[] conditions;
    string groupingField?;
};

public type Condition record {
    string key;
    // Operator operator;
    string value;
};

public type Sort record {
    string key;
    Order 'order;
};

public type DeleteCriteria record {
    Condition[] conditions;
};

public type CountOutput record {
    int count;
};

// public type StorageError record {
//     string message;
// };

// # Represents any error related to the Ballerina GraphQL module.
// type GenericError error<record {|string message; int code;|}>;

