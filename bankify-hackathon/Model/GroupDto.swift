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
    var credits: [Credit]
    
    init() {
        name = ""
        members = []
        credits = []
    }
    
    mutating func deserialize(_ json: JSON) {
        name <-- json["name"]
        members <-- json["member"]
        credits <-- json["credits"]
        
        let dict = Dictionary(grouping: credits, by: { $0.id })
        var oMembers: [MemberDto] = []
        for member in members {
            var _member = member
            _member.amount = dict[member.id]?[0].amount ?? 0
            oMembers.append(_member)
        }
        members = oMembers
    }
}

struct MemberDto: ArrowParsable {
    var id: Int
    var name: String
    var index: Int
    var amount: Double
    var ethAddress: String
    var ethAmount: Double
    var debts: [Debt]
    
    init() {
        id = 0
        name = ""
        index = 0
        amount = 0
        ethAmount = 0
        debts = []
        ethAddress = ""
    }
    
    mutating func deserialize(_ json: JSON) {
        id <-- json["id"]
        name <-- json["name"]
        index <-- json["index"]
        var rawDebts: [Debt] = []
        rawDebts <-- json["debts"]
        ethAddress = Utils.eth[id - 1]
        debts = rawDebts.filter { $0.amount > 0 }
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

struct Credit: ArrowParsable {
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
