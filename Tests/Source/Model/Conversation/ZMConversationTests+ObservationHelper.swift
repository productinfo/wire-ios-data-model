//
// Wire
// Copyright (C) 2017 Wire Swiss GmbH
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
//

import Foundation

@testable import WireDataModel

class ZMConversationObservationHelperTests: NotificationDispatcherTestBase {
    
    
    func testThatOnCreatedRemotelyIsCalledWhenRemoteIdentifierIsModified() {
        // given
        let createdRemotely = expectation(description: "Created remotely")
        let conversation = ZMConversation.insertNewObject(in: self.uiMOC)
        uiMOC.saveOrRollback()
        
        // expect
        var token = conversation.onCreatedRemotely {
            createdRemotely.fulfill()
        }
        
        // when
        conversation.remoteIdentifier = UUID.create()
        uiMOC.saveOrRollback()
        XCTAssertNotNil(token)
        waitForExpectations(timeout: 0.5, handler: nil)
        token = nil
    }
    
    func testTHatOnCreatedRemotelyIsCalledIfConversationAlreadyHasRemoteIdentifier() {
        // given
        let createdRemotely = expectation(description: "Created remotely")
        let conversation = ZMConversation.insertNewObject(in: self.uiMOC)
        conversation.remoteIdentifier = UUID.create()
        uiMOC.saveOrRollback()
        
        // expect
        var token = conversation.onCreatedRemotely {
            createdRemotely.fulfill()
        }
        
        XCTAssertNil(token)
        waitForExpectations(timeout: 0.5, handler: nil)
        token = nil
    }
    
}
