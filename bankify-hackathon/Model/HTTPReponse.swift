//
//  HTTPReponse.swift
//  bankify-hackathon
//
//  Created by Robert Nguyen on 10/13/18.
//  Copyright © 2018 Robert Nguyen. All rights reserved.
//

import Arrow

struct HTTPReponse: ArrowParsable {
    init() {
        status = 200
        code = "SUCCESS"
    }
    
    var status: Int
    var item: JSON?
    var code: String
    
    mutating func deserialize(_ json: JSON) {
        status <-- json["static"]
        item = json["item"]
        code <-- json["code"]
    }
}
