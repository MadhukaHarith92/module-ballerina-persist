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

import ballerinax/mysql;
import ballerina/sql;

client class MultipleAssociationsClient {

    private final string entityName = "MultipleAssociations";
    private final sql:ParameterizedQuery tableName = `MultipleAssociations`;
    private final map<FieldMetadata> fieldMetadata = {
        id: {columnName: "id", 'type: int},
        name: {columnName: "name", 'type: string},
        "profile.id": {columnName: "profileId", 'type: int, relation: {entityName: "profile", refTable: "Profiles", refField: "id"}},
        "profile.name": {'type: int, relation: {entityName: "profile", refTable: "Profiles", refField: "name"}},
        "user.id": {columnName: "userId", 'type: int, relation: {entityName: "user", refTable: "Users", refField: "id"}},
        "user.name": {'type: int, relation: {entityName: "user", refTable: "Users", refField: "name"}}
    };
    private string[] keyFields = ["id"];
    private final map<JoinMetadata> joinMetadata = {
        profile: {entity: Profile, fieldName: "profile", refTable: "Profiles", refFields: ["id"], joinColumns: ["profileId"]},
        user: {entity: User, fieldName: "user", refTable: "Users", refFields: ["id"], joinColumns: ["userId"]}
    };

    private SQLClient persistClient;

    public function init() returns Error? {
        mysql:Client|sql:Error dbClient = new (host = host, user = user, password = password, database = database, port = port);
        if dbClient is sql:Error {
            return <Error>error(dbClient.message());
        }

        self.persistClient = check new (dbClient, self.entityName, self.tableName, self.keyFields, self.fieldMetadata, self.joinMetadata);
    }

    remote function create(MultipleAssociations value) returns MultipleAssociations|Error {
        if value.profile is Profile {
            ProfileClient profileClient = check new ProfileClient();
            boolean exists = check profileClient->exists(<Profile>value.profile);
            if !exists {
                value.profile = check profileClient->create(<Profile>value.profile);
            }
        }

        if value.user is User {
            UserClient userClient = check new UserClient();
            boolean exists = check userClient->exists(<User>value.user);
            if !exists {
                value.user = check userClient->create(<User>value.user);
            }
        }

        _ = check self.persistClient.runInsertQuery(value);
        return value;
    }

    remote function readByKey(int key, MultipleAssociationsRelations[] include = []) returns MultipleAssociations|Error {
        return <MultipleAssociations>check self.persistClient.runReadByKeyQuery(MultipleAssociations, key, include);
    }

    remote function read(MultipleAssociationsRelations[] include = []) returns stream<MultipleAssociations, Error?> {
        stream<anydata, sql:Error?>|Error result = self.persistClient.runReadQuery(MultipleAssociations, include);
        if result is Error {
            return new stream<MultipleAssociations, Error?>(new MultipleAssociationsStream((), result));
        } else {
            return new stream<MultipleAssociations, Error?>(new MultipleAssociationsStream(result));
        }
    }

    remote function execute(sql:ParameterizedQuery filterClause) returns stream<MultipleAssociations, Error?> {
        stream<anydata, sql:Error?>|Error result = self.persistClient.runExecuteQuery(filterClause, MultipleAssociations);
        if result is Error {
            return new stream<MultipleAssociations, Error?>(new MultipleAssociationsStream((), result));
        } else {
            return new stream<MultipleAssociations, Error?>(new MultipleAssociationsStream(result));
        }
    }

    remote function update(MultipleAssociations 'object) returns Error? {
        _ = check self.persistClient.runUpdateQuery('object);

        if 'object["profile"] is Profile {
            Profile profileEntity = <Profile>'object["profile"];
            ProfileClient profileClient = check new ProfileClient();
            check profileClient->update(profileEntity);
        }

        if 'object["user"] is User {
            User userEntity = <User>'object["user"];
            UserClient userClient = check new UserClient();
            check userClient->update(userEntity);
        }
    }

    remote function delete(MultipleAssociations 'object) returns Error? {
        _ = check self.persistClient.runDeleteQuery('object);
    }

    remote function exists(MultipleAssociations multipleAssociations) returns boolean|Error {
        MultipleAssociations|Error result = self->readByKey(multipleAssociations.id);
        if result is MultipleAssociations {
            return true;
        } else if result is InvalidKeyError {
            return false;
        } else {
            return result;
        }
    }

    function close() returns Error? {
        return self.persistClient.close();
    }

}

public enum MultipleAssociationsRelations {
    ProfileEntity = "profile",
    UserEntity = "user"
}

public class MultipleAssociationsStream {
    private stream<anydata, sql:Error?>? anydataStream;
    private Error? err;

    public isolated function init(stream<anydata, sql:Error?>? anydataStream, Error? err = ()) {
        self.anydataStream = anydataStream;
        self.err = err;
    }

    public isolated function next() returns record {|MultipleAssociations value;|}|Error? {
        if self.err is Error {
            return self.err;
        } else if self.anydataStream is stream<anydata, sql:Error?> {
            var anydataStream = <stream<anydata, sql:Error?>>self.anydataStream;
            var streamValue = anydataStream.next();
            if streamValue is () {
                return streamValue;
            } else if (streamValue is sql:Error) {
                return <Error>error(streamValue.message());
            } else {
                record {|MultipleAssociations value;|} nextRecord = {value: <MultipleAssociations>streamValue.value};
                return nextRecord;
            }
        } else {
            // Unreachable code
            return ();
        }
    }

    public isolated function close() returns Error? {
        if self.anydataStream is stream<anydata, sql:Error?> {
            var anydataStream = <stream<anydata, sql:Error?>>self.anydataStream;
            sql:Error? e = anydataStream.close();
            if e is sql:Error {
                return <Error>error(e.message());
            }
        }
    }
}
