//
//  GameListController.swift
//  App
//
//  Created by Hexa-desmond.tham on 22/02/2019.
//

import Vapor

final class GameListController {
    func get(_ req: Request) throws -> Future<[GameModel]> {
        return GameModel.query(on: req).all()
    }
    
    func create(_ req: Request) throws -> Future<GameModel> {
        return try req.content.decode(GameModel.self).flatMap { gameModel in
            return gameModel.save(on: req)
        }
    }
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(GameModel.self).flatMap { gameModel in
            return gameModel.delete(on: req)
            }.transform(to: .ok)
    }
    
    func update(_ req: Request) throws -> Future<GameModel> {
        return try req.parameters.next(GameModel.self).flatMap { gameModel in
            return try req.content.decode(GameModel.self).flatMap { newGameModel in
                gameModel.name = newGameModel.name
                gameModel.description = newGameModel.description
                return gameModel.save(on: req)
            }
        }
    }
}
