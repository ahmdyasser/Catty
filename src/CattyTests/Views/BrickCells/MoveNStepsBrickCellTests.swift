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

@testable import Pocket_Code

final class MoveNStepsBrickCellTests: XCTestCase {

    var brick: MoveNStepsBrick!
    var brickCell: MoveNStepsBrickCell!

    override func setUp() {
        super.setUp()

        brick = MoveNStepsBrick()
        brickCell = MoveNStepsBrickCell()
        brickCell.scriptOrBrick = brick
    }

    func testTitleSingular() {
        let expectedTitle = kLocalizedMove + " %@ " + kLocalizedStep

        brick.steps = Formula(double: 1)

        XCTAssertEqual(expectedTitle, brickCell.brickTitle(forBackground: true, andInsertionScreen: true))
        XCTAssertEqual(expectedTitle, brickCell.brickTitle(forBackground: false, andInsertionScreen: false))
    }

    func testTitlePlural() {
        let expectedTitle = kLocalizedMove + " %@ " + kLocalizedSteps

        brick.steps = Formula(double: 2)

        XCTAssertEqual(expectedTitle, brickCell.brickTitle(forBackground: true, andInsertionScreen: true))
        XCTAssertEqual(expectedTitle, brickCell.brickTitle(forBackground: false, andInsertionScreen: false))
    }
}
