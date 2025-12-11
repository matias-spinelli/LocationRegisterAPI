//
//  Sucursal.swift
//  LocationRegisterAPI
//
//  Created by Matías Spinelli on 10/12/2025.
//

import Vapor
import MongoKitten

struct Sucursal: Codable, Content {
    var id: ObjectId?
    var name: String
    var address: String
    var latitude: Double
    var longitude: Double
}

