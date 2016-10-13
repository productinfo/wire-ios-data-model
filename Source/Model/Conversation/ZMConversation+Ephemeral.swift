//
// Wire
// Copyright (C) 2016 Wire Swiss GmbH
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


@objc public enum ZMConversationMessageDestructionTimeout : Int {
    case none, fiveSeconds, fifteenSeconds, oneMinute, fiveMinutes, fifteenMinutes
}

public extension ZMConversationMessageDestructionTimeout {
    
    public var timeInterval : TimeInterval {
        switch self {
        case .none:
            return 0
        case .fiveSeconds:
            return 5
        case .fifteenSeconds:
            return 15
        case .oneMinute:
            return 60
        case .fiveMinutes:
            return 300
        case .fifteenMinutes:
            return 1500
        }
    }
    
    public static func closestTimeout(for timeout: TimeInterval) -> TimeInterval {
        if timeout < 0 {
            return 0.0
        }
        var start : Int = 1
        var lastTimeout : TimeInterval = 0
        while let currentTimeout = ZMConversationMessageDestructionTimeout(rawValue: start)?.timeInterval {
            start += 1
            if currentTimeout == timeout {
                return timeout
            }
            if currentTimeout < timeout {
                lastTimeout = currentTimeout
            } else {
                if (currentTimeout - timeout) < (timeout - lastTimeout) {
                    return currentTimeout
                }
            }
        }
        return lastTimeout
    }
}

public extension ZMConversation {

    /// Sets messageDestructionTimeout
    /// @param timeout The timeout after which an appended message should "self-destruct"
    public func updateMessageDestructionTimeout(timeout : ZMConversationMessageDestructionTimeout) {
        if (conversationType != .oneOnOne) {
            return
        }
        messageDestructionTimeout = timeout.timeInterval
    }

}

