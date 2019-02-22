import Vapor
import PostgreSQL
import FluentPostgreSQL

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentPostgreSQLProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
    
    // Configure a database
    let dbConfig: PostgreSQLDatabaseConfig
    if let url = Environment.get("DATABASE_URL"), let psqlConfig = PostgreSQLDatabaseConfig(url: url) {
        dbConfig = psqlConfig
    } else {
        dbConfig = PostgreSQLDatabaseConfig(hostname: "localhost", port: 5432, username: "hexa-desmond.tham", database: "BattleBunker", password: nil)
    }
    let postgresql = try PostgreSQLDatabase(config: dbConfig)
    
    /// Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: postgresql, as: .psql)
    services.register(databases)
    
    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: GameModel.self, database: .psql)
    services.register(migrations)
    
    let serverConfigure = NIOServerConfig.default(hostname: "localhost", port: 9090)
    services.register(serverConfigure)
}
