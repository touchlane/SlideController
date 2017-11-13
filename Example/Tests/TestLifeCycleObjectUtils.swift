//
//  TestLifeCycleObjectUtils.swift
//  SlideController_Example
//
//  Created by Pavel Kondrashkov on 11/13/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import XCTest
import SlideController

final class TestLifeCycleObjectUtils {
    
    func assertOutsideScreenLifeCycleObject(object: TestableLifeCycleObject, shouldBeLoad: Bool) {
        XCTAssert(!object.didAppearTriggered)
        XCTAssert(!object.didDissapearTriggered)
        XCTAssert(shouldBeLoad ? object.viewDidLoadTriggered : !object.viewDidLoadTriggered)
        XCTAssert(!object.viewDidUnloadTriggered)
        XCTAssert(!object.didStartSlidingTriggered)
        XCTAssert(!object.didCancelSlidingTriggered)
    }
    
    func assertPresentedLifeCycleObject(object: TestableLifeCycleObject, wasSlided: Bool) {
        XCTAssert(object.didAppearTriggered)
        XCTAssert(!object.didDissapearTriggered)
        XCTAssert(object.viewDidLoadTriggered)
        XCTAssert(!object.viewDidUnloadTriggered)
        XCTAssert(wasSlided ? object.didStartSlidingTriggered : !object.didStartSlidingTriggered)
        XCTAssert(!object.didCancelSlidingTriggered)
    }
}
