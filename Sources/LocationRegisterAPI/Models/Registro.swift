//
//  Registro.swift
//  LocationRegisterAPI
//
//  Created by Matías Spinelli on 10/12/2025.
//

import Vapor
import MongoKitten

struct Registro: Codable, Content {
    var id: ObjectId?
    var timestamp: Date
    var tipo: String
    var sucursalID: String
    var userID: String
}
