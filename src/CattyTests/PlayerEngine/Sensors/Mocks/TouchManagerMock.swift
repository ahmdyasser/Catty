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

@testable import Pocket_Code
import UIKit

final class TouchManagerMock: TouchManagerProtocol {

    var touchRecognizer: UILongPressGestureRecognizer?
    var stage: Stage?
    var isScreenTouched = false
    var touches: [CGPoint] = []
    var lastPosition: CGPoint?
    var lastTouchMock: UITouch?

    var isStarted = false

    func startTrackingTouches(for stage: Stage) {
        isStarted = true
    }

    func stopTrackingTouches() {
        isStarted = false
    }

    func reset() {
    }

    func screenTouched() -> Bool {
        isScreenTouched
    }

    func screenTouched(for toucNumber: Int) -> Bool {
        isScreenTouched
    }

    func numberOfTouches() -> Int {
        touches.count
    }

    func lastPositionInScene() -> CGPoint? {
        lastPosition
    }

    func getPositionInScene(for touchNumber: Int) -> CGPoint? {
        if touchNumber <= 0 || touches.count < touchNumber {
            return nil
        }
        return touches[touchNumber - 1]
    }

    func lastTouch() -> UITouch? {
        lastTouchMock
    }
}
