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

import ballerina/time;
import ballerina/persist;
import ballerina/constraint;

@persist:Entity {
    key: ["needId"],
    uniqueConstraints: [["beneficiaryId", "urgency"]],
    tableName: "MedicalNeeds"
}
public type MedicalNeed record {|
    @persist:AutoIncrement
    readonly int needId = 1;
    int beneficiaryId;
    time:Civil period;
    string urgency;
    int quantity;
    @persist:Relation {keyColumns: ["name"], reference: ["name"]}
    Item item?;
    @persist:Relation {keyColumns: ["name1"], reference: ["name"]}
    Item1 item1?;
|};

@persist:Entity {
    key: ["id"],
    uniqueConstraints: [["name"]]
}
public type Item record {
    @persist:AutoIncrement
    readonly int id = 3;
    @constraint:String {
        maxLength: 10
    }
    string name;
};

@persist:Entity {
    key: ["id"],
    uniqueConstraints: [["name"]]
}
public type Item1 record {
    @persist:AutoIncrement
    readonly int id = 5;
    @constraint:String {
        maxLength: 20
    }
    string name;
    @persist:Relation {keyColumns: ["itemName"], reference: ["name"], onDelete: persist:SET_DEFAULT}
    Item2 item?;
};

@persist:Entity {
    key: ["id"]
}
public type Item2 record {
    @persist:AutoIncrement
    readonly int id = 2;
    @constraint:String {
        length: 20
    }
    string name;
};
