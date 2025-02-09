/*
 * Copyright (c) 2022, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerina.stdlib.persist.compiler.plugin;

import io.ballerina.projects.DiagnosticResult;
import io.ballerina.projects.Package;
import io.ballerina.projects.ProjectEnvironmentBuilder;
import io.ballerina.projects.directory.BuildProject;
import io.ballerina.projects.environment.Environment;
import io.ballerina.projects.environment.EnvironmentBuilder;
import io.ballerina.stdlib.persist.compiler.DiagnosticsCodes;
import io.ballerina.tools.diagnostics.Diagnostic;
import io.ballerina.tools.diagnostics.DiagnosticInfo;
import io.ballerina.tools.diagnostics.DiagnosticSeverity;
import org.testng.Assert;
import org.testng.annotations.Test;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Tests the persist compiler plugin.
 */
public class CompilerPluginTest {

    private static ProjectEnvironmentBuilder getEnvironmentBuilder() {
        Path distributionPath = Paths.get("../", "target", "ballerina-runtime")
                .toAbsolutePath();
        Environment environment = EnvironmentBuilder.getBuilder().setBallerinaHome(distributionPath).build();
        return ProjectEnvironmentBuilder.getBuilder(environment);
    }

    private Package loadPackage(String path) {
        Path projectDirPath = Paths.get("src", "test", "resources", "test-src", "plugin").
                toAbsolutePath().resolve(path);
        BuildProject project = BuildProject.load(getEnvironmentBuilder(), projectDirPath);
        return project.currentPackage();
    }

    @Test
    public void testEntityAnnotation1() {
        testDiagnostic("package_01", "invalid key: the given key is not in the record definition",
                DiagnosticsCodes.PERSIST_102.getCode(), 2);
    }
    @Test
    public void testEntityAnnotation2() {
        testDiagnostic("package_02", "invalid key: the given key is not in the record definition",
                DiagnosticsCodes.PERSIST_102.getCode(), 2);
    }

    @Test
    public void testPrimaryKeyMarkReadOnly() {
        testDiagnostic("package_03", "invalid initialization: the field is not specified as " +
                        "read-only", DiagnosticsCodes.PERSIST_106.getCode(), 2);
    }

    @Test
    public void testMultipleAutoIncrementAnnotation() {
        testDiagnostic("package_04", "duplicate annotation: the entity does not allow " +
                        "multiple field with auto increment annotation",
                DiagnosticsCodes.PERSIST_107.getCode(), 1);
    }

    @Test
    public void testAutoIncrementAnnotation1() {
        testDiagnostic("package_05", "invalid value: the value only supports positive integer",
                DiagnosticsCodes.PERSIST_103.getCode(), 1);
    }

    @Test
    public void testRelationAnnotationMismatchReference() {
        testDiagnostic("package_06", "mismatch reference: the given key count is mismatched " +
                "with reference key count", DiagnosticsCodes.PERSIST_109.getCode(), 1);
    }

    @Test
    public void testOptionalField() {
        testDiagnostic("package_07", "invalid field type: the persist client does not " +
                        "support the union type", DiagnosticsCodes.PERSIST_101.getCode(), 1);
    }

    @Test
    public void testOptionalField2() {
        testDiagnostic("package_08", "invalid field type: the persist client does not " +
                        "support the union type", DiagnosticsCodes.PERSIST_101.getCode(), 1);
    }

    @Test
    public void testOptionalField3() {
        testDiagnostic("package_09", "invalid field type: the persist client does not " +
                        "support the union type", DiagnosticsCodes.PERSIST_101.getCode(), 1);
    }

    @Test
    public void testAutoIncrementField() {
        testDiagnostic("package_10", "invalid initialization: auto increment field " +
                        "must be defined as a key", DiagnosticsCodes.PERSIST_108.getCode(), 1);
    }

    @Test
    public void testRecordType() {
        testDiagnostic("package_11", "invalid initialization: the entity should be public",
                DiagnosticsCodes.PERSIST_111.getCode(), 1);
    }

    @Test
    public void testRecordType1() {
        testDiagnostic("package_12", "invalid initialization: the entity should be public",
                DiagnosticsCodes.PERSIST_111.getCode(), 1);
    }

    @Test
    public void testTableName() {
        testDiagnostic("package_13", "duplicate table name: the table name is already " +
                        "used in another entity", DiagnosticsCodes.PERSIST_113.getCode(), 1);
    }

    @Test
    public void testTableName1() {
        testDiagnostic("package_20", "duplicate table name: the table name is already used " +
                        "in another entity", DiagnosticsCodes.PERSIST_113.getCode(), 1);
    }

    @Test
    public void testInvalidInitialisation() {
        testDiagnostic("package_14", "invalid entity initialisation: the associated entity of " +
                "this[Item] does not have the field with the relationship type",
                DiagnosticsCodes.PERSIST_115.getCode(), 2);
    }

    @Test
    public void testInvalidInitialisation1() {
        testDiagnostic("package_15", "invalid entity initialisation: the relation annotation " +
                        "should only be added to the relationship owner for one-to-one and one-to-many associations",
                DiagnosticsCodes.PERSIST_116.getCode(), 2);
    }

    @Test
    public void testInvalidInitialisation2() {
        testDiagnostic("package_16", "invalid entity initialisation: the relation annotation " +
                        "should only be added to the relationship owner for one-to-one and one-to-many associations",
                DiagnosticsCodes.PERSIST_116.getCode(), 2);
    }

    @Test
    public void testUnSupportedFeature() {
        testDiagnostic("package_17", "unsupported features: many-to-many association is not " +
                        "supported yet", DiagnosticsCodes.PERSIST_114.getCode(), 2);
    }

    @Test
    public void testUnSupportedFeature1() {
        testDiagnostic("package_22", "unsupported features: array type is not supported",
                DiagnosticsCodes.PERSIST_120.getCode(), 1);
    }
    
    @Test
    public void testUnSupportedFeature2() {
        testDiagnostic("package_23", "unsupported features: array type is not supported",
                DiagnosticsCodes.PERSIST_120.getCode(), 1);
    }

    @Test
    public void testUnSupportedFeature3() {
        testDiagnostic("package_24", "unsupported features: json type is not supported",
                DiagnosticsCodes.PERSIST_121.getCode(), 1);
    }

    @Test
    public void testUnSupportedFeature4() {
        testDiagnostic("package_25", "unsupported features: json type is not supported",
                DiagnosticsCodes.PERSIST_121.getCode(), 2);
    }

    @Test
    public void testInvalidAnnotation() {
        testDiagnostic("package_18",  "invalid annotation attachment: the `one-to-many` relation " +
                "annotation can not be attached to the array entity record field",
                DiagnosticsCodes.PERSIST_118.getCode(), 1);
    }

    @Test
    public void testInvalidAnnotation1() {
        testDiagnostic("package_19",  "invalid annotation attachment: The relation " +
                "annotation can only be attached to the entity record field",
                DiagnosticsCodes.PERSIST_117.getCode(), 1);
    }

    @Test
    public void testEntityName1() {
        testDiagnostic("package_21", "duplicate entity names are not allowed: the specified name " +
                "is already used in another entity", DiagnosticsCodes.PERSIST_119.getCode(), 2);
    }

    private void testDiagnostic(String packageName, String msg, String code, int count) {
        DiagnosticResult diagnosticResult = loadPackage(packageName).getCompilation().diagnosticResult();
        List<Diagnostic> errorDiagnosticsList = diagnosticResult.diagnostics().stream().
                filter(r -> r.diagnosticInfo().severity().equals(DiagnosticSeverity.ERROR)).
                collect(Collectors.toList());
        long availableErrors = errorDiagnosticsList.size();
        Assert.assertEquals(availableErrors, count);
        DiagnosticInfo error = errorDiagnosticsList.get(0).diagnosticInfo();
        Assert.assertEquals(error.code(), code);
        Assert.assertEquals(error.messageFormat(), msg);
    }
}
