// Copyright (c) 2022 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

import ballerina/persist;
import ballerina/time;

@persist:Entity {
    key: ["needId"],
    uniqueConstraints: [["needId"]],
    tableName: "Medical_Need"
}
public type MedicalNeed record {|
    @persist:AutoIncrement
    readonly int needId = 12;
    int beneficiaryId;
    time:Civil period?;
    string urgency?;
    int quantity;
    @persist:Relation {keyColumns: ["itemId"], reference: ["id"], onDelete: persist:RESTRICT, onUpdate: persist:RESTRICT}
    Item item?;
|};

@persist:Entity {key: ["id"]}
public type Item record {
    @persist:AutoIncrement
    readonly int id = 15;
    string name;
};
