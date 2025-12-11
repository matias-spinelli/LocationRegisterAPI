//
//  LocationRegisterController.swift
//  LocationRegisterAPI
//
//  Created by Matías Spinelli on 10/12/2025.
//

import Vapor
import MongoKitten

struct LocationRegisterController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        let api = routes.grouped("api")

        api.get("sucursales", use: getSucursales)
        api.post("sucursales", use: createSucursal)

        api.post("registros", use: createRegistro)
        api.get("registros", use: getRegistros)
        
        api.post("initSucursales", use: initSucursales)
    }

    func getSucursales(req: Request) async throws -> [Sucursal] {
        var results: [Sucursal] = []

        let cursor = req.application.mongoDB["sucursales"]
            .find()
            .decode(Sucursal.self)

        for try await doc in cursor {
            results.append(doc)
        }

        return results
    }

    func createSucursal(req: Request) async throws -> Sucursal {
        var sucursal = try req.content.decode(Sucursal.self)

        if sucursal.id == nil {
            sucursal.id = ObjectId()
        }

        try await req.application.mongoDB["sucursales"].insertEncoded(sucursal)

        return sucursal
    }

    func createRegistro(req: Request) async throws -> Registro {
        var registro = try req.content.decode(Registro.self)

        if registro.id == nil {
            registro.id = ObjectId()
        }

        try await req.application.mongoDB["registros"].insertEncoded(registro)

        return registro
    }

    func getRegistros(req: Request) async throws -> [Registro] {
        var results: [Registro] = []

        let cursor = req.application.mongoDB["registros"]
            .find()
            .decode(Registro.self)

        for try await doc in cursor {
            results.append(doc)
        }

        return results
    }
    
    func initSucursales(req: Request) async throws -> String {
        struct RawSucursal: Codable {
            var id: String?
            var name: String
            var address: String
            var latitude: Double
            var longitude: Double
        }

        let path = req.application.directory.resourcesDirectory + "sucursales.json"
        req.logger.info("📁 Loading sucursales from: \(path)")

        let data: Data
        do {
            data = try Data(contentsOf: URL(fileURLWithPath: path))
        } catch {
            req.logger.error("🛑 Could not read sucursales.json: \(error.localizedDescription)")
            throw Abort(.internalServerError, reason: "Could not read resources/sucursales.json: \(error.localizedDescription)")
        }

        let rawList: [RawSucursal]
        do {
            rawList = try JSONDecoder().decode([RawSucursal].self, from: data)
        } catch {
            req.logger.error("🧨 JSON decode failed: \(error.localizedDescription)")
            throw Abort(.internalServerError, reason: "Invalid JSON format in sucursales.json: \(error.localizedDescription)")
        }

        let collection = req.application.mongoDB["sucursales"]

        var inserted = 0
        for raw in rawList {
            // Always create a proper ObjectId for the DB document.
            // If you really want to preserve the JSON id you'd need to validate and
            // convert it to an ObjectId (24 hex chars) — otherwise skip it.
            var suc = Sucursal(
                id: ObjectId(),
                name: raw.name,
                address: raw.address,
                latitude: raw.latitude,
                longitude: raw.longitude
            )

            do {
                try await collection.insertEncoded(suc)
                inserted += 1
            } catch {
                // log and continue with next item so a single bad doc doesn't stop the whole import
                req.logger.error("⚠️ Could not insert sucursal '\(raw.name)': \(error.localizedDescription)")
            }
        }

        req.logger.info("✅ Loaded \(inserted) sucursales (from \(rawList.count) in file)")
        return "OK - Loaded \(inserted) sucursales"
    }
}

