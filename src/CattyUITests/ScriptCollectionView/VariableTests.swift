/**
 *  Copyright (C) 2010-2022 The Catrobat Team
 *  (http://developer.catrobat.org/credits)
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 *
 *  An additional term exception under section 7 of the GNU Affero
 *  General Public License, version 3, is available at
 *  (http://developer.catrobat.org/license_additional_term)
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program.  If not, see http://www.gnu.org/licenses/.
 */

import XCTest

class VariableTests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        app = launchApp()
    }

    private func createNewProjectAndAddSetVariableBrick(name: String) {
        createProject(name: name, in: app)

        app.tables.staticTexts[kLocalizedBackground].tap()
        app.tables.staticTexts[kLocalizedScripts].tap()

        addBrick(label: kLocalizedSetVariable, section: kLocalizedCategoryData, in: app)
    }

    func testDontShowVariablePickerWhenNoVariablesDefinedForObject() {
        createNewProjectAndAddSetVariableBrick(name: "Test Project")

        tapOnVariablePicker(of: kLocalizedSetVariable, in: app)
        XCTAssert(app.sheets[kUIFEActionVar].exists)
    }

    func testCreateVariableWithMaxLength() {
        createNewProjectAndAddSetVariableBrick(name: "Test Project")

        tapOnVariablePicker(of: kLocalizedSetVariable, in: app)
        XCTAssert(app.sheets[kUIFEActionVar].exists)

        app.buttons[kUIFEActionVarPro].tap()
        app.alerts[kUIFENewVar].textFields[kLocalizedEnterYourVariableNameHere].typeText(String(repeating: "i", count: 25))
        app.alerts[kUIFENewVar].buttons[kLocalizedOK].tap()
        XCTAssert(waitForElementToAppear(app.staticTexts[kLocalizedWhenProjectStarted]).exists)
    }

    func testCreateVariableWithMaxLengthPlusOne() {
        createNewProjectAndAddSetVariableBrick(name: "Test Project")

        tapOnVariablePicker(of: kLocalizedSetVariable, in: app)
        XCTAssert(app.sheets[kUIFEActionVar].exists)

        app.buttons[kUIFEActionVarPro].tap()
        app.alerts[kUIFENewVar].textFields[kLocalizedEnterYourVariableNameHere].typeText(String(repeating: "i", count: 25 + 1))
        app.alerts[kUIFENewVar].buttons[kLocalizedOK].tap()
        XCTAssert(waitForElementToAppear(app.alerts[kLocalizedPocketCode]).exists)
    }

    func testCreateAndSelectVariable() {
        let testVariable = ["testVariable1", "testVariable2"]

        createNewProjectAndAddSetVariableBrick(name: "Test Project")
        app.collectionViews.cells.otherElements.containing(.staticText, identifier: kLocalizedSetVariable).children(matching: .button).element.tap()
        XCTAssert(waitForElementToAppear(app.buttons[kLocalizedCancel]).exists)

        app.buttons[kUIFEData].tap()
        for variable in testVariable {
            app.navigationBars.buttons[kLocalizedAdd].tap()
            waitForElementToAppear(app.buttons[kUIFENewVar]).tap()
            waitForElementToAppear(app.buttons[kUIFEActionVarPro]).tap()

            let alert = waitForElementToAppear(app.alerts[kUIFENewVar])
            alert.textFields.firstMatch.typeText(variable)
            alert.buttons[kLocalizedOK].tap()
        }

        app.tables.staticTexts[testVariable[1]].tap()
        XCTAssertTrue(waitForElementToAppear(app.buttons[" \"" + testVariable[1] + "\" "]).exists)
    }

    func testEditMarkedTextVariableInFormularEditor() {
        let projectName = "Test Project"
        let testVariable = "TestVariable"

        createNewProjectAndAddSetVariableBrick(name: projectName)
        app.collectionViews.cells.otherElements.containing(.staticText, identifier: kLocalizedSetVariable).children(matching: .button).element.tap()
        XCTAssert(waitForElementToAppear(app.buttons[kLocalizedCancel]).exists)

        app.buttons[kUIFEAddNewText].tap()
        let alert = waitForElementToAppear(app.alerts[kUIFENewText])
        alert.textFields.firstMatch.typeText(testVariable)
        app.buttons[kLocalizedOK].tap()
        app.buttons[kLocalizedDone].firstMatch.tap()
        app.collectionViews.cells.otherElements.containing(.staticText, identifier: kLocalizedSetVariable).children(matching: .button).element.tap()
        waitForElementToAppear(app.buttons[kUIFEAddNewText]).tap()
        XCTAssertEqual(alert.textFields.firstMatch.value as! String, testVariable)
    }

    func testCreateVariableWithMarkedText() {
        let projectName = "Test Project"
        let testVariable = "TestVariable"

        createNewProjectAndAddSetVariableBrick(name: projectName)
        app.collectionViews.cells.otherElements.containing(.staticText, identifier: kLocalizedSetVariable).children(matching: .button).element.tap()
        XCTAssert(waitForElementToAppear(app.buttons[kLocalizedCancel]).exists)

        app.buttons[kUIFEAddNewText].tap()
        let newTextAlert = waitForElementToAppear(app.alerts[kUIFENewText])
        newTextAlert.textFields.firstMatch.typeText(testVariable)
        app.buttons[kLocalizedOK].tap()
        app.buttons[kLocalizedDone].firstMatch.tap()
        app.collectionViews.cells.otherElements.containing(.staticText, identifier: kLocalizedSetVariable).children(matching: .button).element.tap()
        waitForElementToAppear(app.buttons[kUIFEData]).tap()
        waitForElementToAppear(app.navigationBars.buttons[kLocalizedAdd]).tap()
        waitForElementToAppear(app.buttons[kUIFENewVar]).tap()
        waitForElementToAppear(app.buttons[kUIFEActionVarPro]).tap()
        let newVarAlert = waitForElementToAppear(app.alerts[kUIFENewVar])
        XCTAssertEqual(newVarAlert.textFields.firstMatch.value as! String, "")
    }

    func testDeleteVariableInFormulaEditor() {
        let testVariable = ["testVariable1", "testVariable2"]

        createNewProjectAndAddSetVariableBrick(name: "Test Project")
        app.collectionViews.cells.otherElements.containing(.staticText, identifier: kLocalizedSetVariable).children(matching: .button).element.tap()
        XCTAssert(waitForElementToAppear(app.buttons[kLocalizedCancel]).exists)

        app.buttons[kUIFEData].tap()

        for variable in testVariable {
            app.navigationBars.buttons[kLocalizedAdd].tap()
            waitForElementToAppear(app.buttons[kUIFENewVar]).tap()
            waitForElementToAppear(app.buttons[kUIFEActionVarPro]).tap()

            let alert = waitForElementToAppear(app.alerts[kUIFENewVar])
            alert.textFields.firstMatch.typeText(variable)
            alert.buttons[kLocalizedOK].tap()
        }

        app.tables.staticTexts[testVariable[0]].swipeLeft()
        app.tables.buttons[kLocalizedDelete].tap()

        XCTAssertTrue(app.tables.staticTexts[testVariable[1]].exists)
        XCTAssertFalse(app.tables.staticTexts[testVariable[0]].exists)
        app.tables.staticTexts[testVariable[1]].tap()

        XCTAssertTrue(waitForElementToAppear(app.buttons[" \"" + testVariable[1] + "\" "]).exists)
    }
}
