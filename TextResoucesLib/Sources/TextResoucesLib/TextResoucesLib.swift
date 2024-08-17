// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public struct PlistReader {
    
    private var property: Dictionary<String, Any> = [:]
    
    public init?(_ path: String) {
        // App.plistをDictionary形式で読み込み
        let configurations = NSDictionary(contentsOfFile: path)
        guard let datasourceDictionary: [String : Any] = configurations as? [String : Any] else {
            
            return nil
        }
        
        property = datasourceDictionary
    }

    /// 指定されたキーの値を取得する
    /// - Parameter key: plistのキー
    public func getString(_ key: String) -> String? {
        guard let value: String = property[key] as? String else {
            return nil
        }
        return value
    }
}
