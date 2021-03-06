// Copyright (c) 2019 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/config;
import ballerina/io;
import ballerina/test;

BigqueryConfiguration bigqueryConfig = {
    clientConfig: {
        auth: {
            scheme: http:OAUTH2,
            accessToken: config:getAsString("ACCESS_TOKEN"),
            clientId: config:getAsString("CLIENT_ID"),
            clientSecret: config:getAsString("CLIENT_SECRET"),
            refreshToken: config:getAsString("REFRESH_TOKEN")
        }
    }
};
Client bigqueryClient = new(bigqueryConfig);

string projectId = "publicdata";
string runQueryProjectId = "bigqueryproject-1121";
string datasetId = "samples";
string tableId = "shakespeare";
string jobId = "";

@test:Config
function testListProjects() {
    io:println("-----------------Test case for listProjects method------------------");
    var bigqueryRes = bigqueryClient->listProjects();
    if (bigqueryRes is ProjectList) {
        io:print(bigqueryRes);
        test:assertNotEquals(bigqueryRes, null, msg = "Failed to list projects");
    } else {
        test:assertFail(msg = <string>bigqueryRes.detail().message);
    }
}

@test:Config
function testGetDataset() {
    io:println("-----------------Test case for getDataset method------------------");
    var bigqueryRes = bigqueryClient->getDataset(projectId, datasetId);
    if (bigqueryRes is Dataset) {
        io:print(bigqueryRes);
        test:assertNotEquals(bigqueryRes.id, null, msg = "Failed to get the dataset");
    } else {
        test:assertFail(msg = <string>bigqueryRes.detail().message);
    }
}

@test:Config
function testListDatasets() {
    io:println("-----------------Test case for listDatasets method------------------");
    var bigqueryRes = bigqueryClient->listDatasets(projectId);
    if (bigqueryRes is DatasetList) {
        io:print(bigqueryRes);
        test:assertNotEquals(bigqueryRes, null, msg = "Failed to list projects");
    } else {
        test:assertFail(msg = <string>bigqueryRes.detail().message);
    }
}

@test:Config
function testListTables() {
    io:println("-----------------Test case for listTables method------------------");
    var bigqueryRes = bigqueryClient->listTables(projectId, datasetId);
    if (bigqueryRes is TableList) {
        io:print(bigqueryRes);
        test:assertNotEquals(bigqueryRes, null, msg = "Failed to list projects");
    } else {
        test:assertFail(msg = <string>bigqueryRes.detail().message);
    }
}

@test:Config
function testListTableData() {
    io:println("-----------------Test case for listTableData method------------------");
    var bigqueryRes = bigqueryClient->listTableData(projectId, datasetId, tableId);
    if (bigqueryRes is TableData) {
        io:print(bigqueryRes);
        test:assertNotEquals(bigqueryRes, null, msg = "Failed to list projects");
    } else {
        test:assertFail(msg = <string>bigqueryRes.detail().message);
    }
}

@test:Config
function testGetTable() {
    io:println("-----------------Test case for getTable method------------------");
    var bigqueryRes = bigqueryClient->getTable(projectId, datasetId, tableId, "word", "word_count");
    if (bigqueryRes is Table) {
        io:print(bigqueryRes);
        test:assertNotEquals(bigqueryRes.id, null, msg = "Failed to get table");
    } else {
        test:assertFail(msg = <string>bigqueryRes.detail().message);
    }
}

@test:Config
function testInsertAllTableData() {
    io:println("-----------------Test case for insertAllTableData method------------------");
    InsertRequestData[] insertRequestData = [{jsonData : {"testKey" : "testVal"}}];
    var bigqueryRes = bigqueryClient->insertAllTableData(projectId, datasetId, tableId, insertRequestData);
    if (bigqueryRes is error) {
        io:print(bigqueryRes);
        test:assertFail(msg = <string>bigqueryRes.detail().message);
    }
}

@test:Config
function testRunQuery() {
    io:println("-----------------Test case for runQuery method------------------");
    string queryString = "SELECT count(*) FROM [publicdata:samples.github_nested]";
    var bigqueryRes = bigqueryClient->runQuery(runQueryProjectId, queryString);
    if (bigqueryRes is error) {
        io:print(bigqueryRes);
        test:assertFail(msg = <string>bigqueryRes.detail().message);
    } else {
        jobId = untaint bigqueryRes.jobId;
    }
}

@test:Config {
    dependsOn: ["testRunQuery"]
}
function testGetQueryResults() {
    io:println("-----------------Test case for getQueryResults method------------------");
    var bigqueryRes = bigqueryClient->getQueryResults(runQueryProjectId, jobId);
    if (bigqueryRes is error) {
        io:print(bigqueryRes);
        test:assertFail(msg = <string>bigqueryRes.detail().message);
    } else {
        io:print(bigqueryRes);
    }
}
