//
//  GameModel.swift
//  App
//
//  Created by Hexa-desmond.tham on 22/02/2019.
//

import Vapor
import PostgreSQL
import FluentPostgreSQL

final class GameModel: PostgreSQLModel {
    var id: Int?
    var name: String
    var description: String
    
    init(id: Int? = nil, name: String, description: String) {
        self.id = id
        self.name = name
        self.description = description
    }
}

extension GameModel: Migration { }

extension GameModel: Content { }

extension GameModel: Parameter { }
