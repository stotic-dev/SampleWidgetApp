//
//  RealmDb.swift
//  WeatherWatcher
//
//  Created by 佐藤汰一 on 2024/08/15.
//

import Foundation
import RealmSwift

protocol RealmAccessable: Sendable {
    
    /// 指定した型に紐ずくTBLからレコードを取得する
    /// - Parameter filter: 取得するレコードをフィルタリングする
    @RealmDb
    func readObject<Entity>(_ filter: (Entity) -> Bool) async throws -> [Entity] where Entity: Object
    
    /// 指定した型に紐づくTBLにレコードを挿入する
    /// - Parameter records: 挿入するレコード
    /// - Description: すでに存在するレコードを挿入対象に含めた場合は上書きする
    @RealmDb
    func insertObject<Entity>(_ records: [Entity]) async throws where Entity: Object
    
    @RealmDb
    func updateObject<Entity>(_ proc: ([Entity]) throws -> [Entity]) async throws -> [Entity] where Entity: Object
    
    /// トランザクションが張られたクロージャを提供する
    @RealmDb
    func transaction(_ proc: (RealmDb) throws -> Void) async throws
}

@globalActor actor RealmDb: GlobalActor, RealmAccessable {
    
    static let shared = RealmDb()
    
    private var realm: Realm?
    
    private init() {
        
        Task {
            
            await setupRealm()
        }
    }
    
    func readObject<Entity>(_ filter: (Entity) -> Bool = { _ in true }) throws -> [Entity] where Entity: Object {
        
        return try getRealm().objects(Entity.self).filter { [filter] in
            
            filter($0)
        }
    }
    
    func insertObject<Entity>(_ records: [Entity]) throws where Entity: Object {
        
        let realm = try getRealm()
        try realm.write {
            
            records.forEach { record in
                
                realm.add(record, update: .modified)
            }
        }
    }
    
    func updateObject<Entity>(_ proc: ([Entity]) throws -> [Entity]) throws -> [Entity] where Entity: Object {
        
        let realm = try getRealm()
        let objects = realm.objects(Entity.self)
        var results = [Entity]()
        try realm.write {
            
            results = try proc(objects.map { $0 })
        }
        
        return results
    }
    
    func transaction(_ proc: (RealmDb) throws -> Void) throws {
        
        let realm = try getRealm()
        realm.beginWrite()
        try proc(self)
        try realm.commitWrite()
    }
}

extension RealmDb {
    
    enum RealmError: Error {
        
        case noRealmObject
    }
}

private extension RealmDb {
    
    func setupRealm() async {
        
        do {
            var config = Realm.Configuration()
            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.taichi.satou.WeatherWatcher")
            config.fileURL = url?.appendingPathComponent("db.realm")
            self.realm = try await Realm(configuration: config, actor: self)
        }
        catch {
            
            assertionFailure("error: \(error)")
        }
    }
    
    func getRealm() throws -> Realm {
        
        guard let realm = realm else {
            
            throw RealmError.noRealmObject
        }
        return realm
    }
}
