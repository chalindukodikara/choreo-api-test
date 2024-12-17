
public type Database client object {
    isolated resource function post kindResource(Resource kind) returns error?;
    isolated resource function get kindResources(SearchQuery searchQuery) returns Resource[]|error;
    isolated resource function get kindResourceCount(SearchCountCriteria searchCountQuery) returns int|error;
    isolated resource function put kindResource(json metadata, Resource kind) returns int?|error;
    // This function deletes a kind resource based on the delete criteria.
    // Provided conditions will be logically combined using 'AND'.
    // Example:
    // {
    //     conditions: [
    //         {
    //             key: "metadata.projectName",
    //             value: "example_project"
    //         },
    //         {
    //             key: "kind",
    //             value: "Component"
    //         }
    //     ]
    // };
    // This returns the affected row count if there is no error. 
    isolated resource function delete kindResource(DeleteCriteria deleteQuery) returns int?|error;
};
