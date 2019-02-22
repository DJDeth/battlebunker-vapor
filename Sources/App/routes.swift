import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    struct PostgreSQLVersion: Codable {
        let version: String
    }
    
    router.get("sql") { req in
        return req.withPooledConnection(to: .psql) { conn in
            return conn.raw("SELECT version()")
                .all(decoding: PostgreSQLVersion.self)
            }.map { rows in
                return rows[0].version
        }
    }
    
    // GameListController
    let gameListController = GameListController()
    router.get("gameList", use: gameListController.get)
    router.post("gameList", use: gameListController.create)
    router.delete("gameList", GameModel.parameter, use: gameListController.delete)
    router.patch("gameList", GameModel.parameter, use: gameListController.update)

}
