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
        deubtUserId = 0
        amount = 0
        _ownerUsername = ""
        _deubtUsername = ""
        isConfirm = false
    }
    
    init(owerId: Int, deubtUserId: Int, amount: Double, ownerUsername: String, deubtUsername: String, isConfirm: Bool) {
        self.ownerId = owerId
        self.deubtUserId = deubtUserId
        self.amount = amount
        self._ownerUsername = ownerUsername
        self._deubtUsername = deubtUsername
        self.isConfirm = isConfirm
    }
    
    private var _ownerUsername: String
    private var _deubtUsername: String
    
    private var ownerId: Int
    private var deubtUserId: Int
    private(set) var amount: Double
    
    var ownerUsername: String {
        return ownerId == Utils.shared.userId ? "You" : _ownerUsername
    }
    var deubtUsername: String {
        return deubtUserId == Utils.shared.userId ? "You" : _deubtUsername
    }
    var isConfirm: Bool
    var isMyTransaction: Bool {
        return ownerId == Utils.shared.userId || deubtUserId == Utils.shared.userId
    }
    
    mutating func deserialize(_ json: JSON) {
        
    }
}
