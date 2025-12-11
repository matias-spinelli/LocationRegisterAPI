import Vapor
import MongoKitten

extension Application {
    struct MongoDBKey: StorageKey {
        typealias Value = MongoDatabase
    }

    var mongoDB: MongoDatabase {
        get { self.storage[MongoDBKey.self]! }
        set { self.storage[MongoDBKey.self] = newValue }
    }
}

public func configure(_ app: Application) async throws {

    let mongoURL = Environment.get("MONGODB_URI")
        ?? "mongodb://localhost:27017/LocationRegisterDB"

    print("🔍 Trying to connect to Mongo at: \(mongoURL)")

    var connected = false

    for attempt in 1...10 {
        do {
            let db = try await MongoDatabase.connect(to: mongoURL)
            app.mongoDB = db
            connected = true
            print("✅ Connected to MongoDB on attempt \(attempt)")
            break
        } catch {
            print("⚠️ MongoDB not ready (attempt \(attempt)): \(error)")
            try await Task.sleep(nanoseconds: 1_000_000_000)
        }
    }

    if !connected {
        fatalError("❌ Could not connect to MongoDB")
    }

    try routes(app)
}
