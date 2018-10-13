//
//  GroupDto.swift
//  bankify-hackathon
//
//  Created by Robert Nguyen on 10/13/18.
//  Copyright © 2018 Robert Nguyen. All rights reserved.
//

import Arrow

struct GroupDto: ArrowParsable {
    var name: String
    var members: [MemberDto]
    
    init() {
        name = ""
        members = []
    }
    
    mutating func deserialize(_ json: JSON) {
        name <-- json["name"]
        members <-- json["member"]
    }
}

struct MemberDto: ArrowParsable {
    var id: Int
    var name: String
    var index: Int
    var amount: Double
    var debts: [Debt]
    
    init() {
        id = 0
        name = ""
        index = 0
        amount = 0
        debts = []
    }
    
    mutating func deserialize(_ json: JSON) {
        id <-- json["id"]
        name <-- json["name"]
        index <-- json["index"]
        var rawDebts: [Debt] = []
        rawDebts <-- json["debts"]
        debts = rawDebts.filter { $0.amount > 0 }
        amount <-- json["amount"]
    }
}

struct Debt: ArrowParsable {
    mutating func deserialize(_ json: JSON) {
        id <-- json["id"]
        amount <-- json["amount"]
    }
    
    var id: Int
    var amount: Double
    
    init() {
        id = -1
        amount = 0
    }
}
