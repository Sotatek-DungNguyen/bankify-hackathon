//
//  Confirmation.swift
//  bankify-hackathon
//
//  Created by Robert Nguyen on 10/13/18.
//  Copyright © 2018 Robert Nguyen. All rights reserved.
//

import Arrow

struct ConfirmationDto: ArrowParsable {
    init() {
        ownerId = 0
        debtUserId = 0
        amount = 0
        _ownerUsername = ""
        _debtUsername = ""
        isConfirm = false
    }
    
    init(ownerId: Int, debtUserId: Int, amount: Double, ownerUsername: String, deubtUsername: String, isConfirm: Bool) {
        self.ownerId = ownerId
        self.debtUserId = debtUserId
        self.amount = amount
        self._ownerUsername = ownerUsername
        self._debtUsername = deubtUsername
        self.isConfirm = isConfirm
    }
    
    private var _ownerUsername: String
    private var _debtUsername: String
    
    private(set) var ownerId: Int
    private(set) var debtUserId: Int
    var amount: Double
    
    var ownerUsername: String {
        return ownerId == Utils.shared.userId ? "You" : _ownerUsername
    }
    var debtUsername: String {
        return debtUserId == Utils.shared.userId ? "You" : _debtUsername
    }
    var isConfirm: Bool
    var isMyTransaction: Bool {
        return ownerId == Utils.shared.userId || debtUserId == Utils.shared.userId
    }
    var isMyOwe: Bool {
        return debtUserId == Utils.shared.userId
    }
    
    mutating func deserialize(_ json: JSON) {
        ownerId <-- json["to"]
        debtUserId <-- json["from"]
        amount <-- json["amount"]
        _ownerUsername <-- json["toName"]
        _debtUsername <-- json["fromName"]
    }
}
