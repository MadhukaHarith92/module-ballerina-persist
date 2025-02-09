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

import ballerina/io;
import package_02.'client as needclient;
import package_02.entity;

public function main() returns error? {
    needclient:MedicalNeedClient mnClient = check new ();

    record {int needId; string period; int quantity;}[]? mns =
    check from entity:MedicalNeed medicalNeed in mnClient->read()
        limit 5
        select {
            needId: medicalNeed.needId,
            period: medicalNeed.period,
            quantity: medicalNeed.quantity
        };
    io:println(mns);

    int quantityMinValue = 5;
    record {int needId; string period; int quantity;}[]? mns1 =
    check from entity:MedicalNeed medicalNeed in mnClient->read()
        limit quantityMinValue
        select {
            needId: medicalNeed.needId,
            period: medicalNeed.period,
            quantity: medicalNeed.quantity
        };
    io:println(mns1);

    record {int needId; string period; int quantity;}[]? mns2 =
    check from entity:MedicalNeed medicalNeed in mnClient->read()
        limit "5"
        select {
            needId: medicalNeed.needId,
            period: medicalNeed.period,
            quantity: medicalNeed.quantity
        };
    io:println(mns2);

    check mnClient.close();
}
