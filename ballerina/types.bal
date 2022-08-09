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

public type FieldMetadata record {|
    string columnName;
    typedesc 'type;
    boolean autoGenerated = false;
|};

# Defines the entities of the table.
#
# + key - The primary key of the table
# + unique - The unique index of the table
# + tableName - The table name
public type EntityConfig record {|
    string[] key;
    string[][] unique?;
    string tableName?;
|};

# The annotation is used to represent entities such as primary keys, unique indexes, and table name.
public annotation EntityConfig Entity on type;

# Defines the auto-increment field configuration.
#
# + startValue - The starting value the field
# + increment - It is a positive integer, which is used to generate
#               the unique number in the field when the new row is entered
public type AutoIncrementConfig record {|
    int startValue = 1;
    int increment = 1;
|};

# The annotation is used to indicate the auto-increment field.
public annotation AutoIncrementConfig AutoIncrement on record field;

# Defines the configuration to indicate the associations of an entity.
#
# + key - The foreign key
# + reference - The primary key of the other table
# + cascadeDelete - If it is true, the corresponding records in the other table
#                   will be deleted when deleting a record from one table
# + cascadeUpdate - If it is true, the corresponding records in the other table
#                   will be updated when updating a record from one table
public type RelationConfig record {|
    string[] key;
    string[] reference = [];
    boolean cascadeDelete = false;
    boolean cascadeUpdate = true;
|};

# The annotation is used to indicate the associations of an entity.
public annotation RelationConfig Relation on field;
