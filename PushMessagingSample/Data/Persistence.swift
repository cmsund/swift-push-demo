//
//  Persistence.swift
//  hfa
//

import Foundation


enum PersistenceMode{
    //    case mock
    case local
    case remote
}

enum PersistenceIOMode {
    case userDefaults
    case fileManagerAndBundle
}

enum PersistenceError: Error {
    case unimplementedMethod
    case none
    case fileNotFoundFromFileManager
    case couldNotDecodeFromFileManagerFile
    case fileNotFoundFromBundle
    case couldNotDecodeFromBundleFile
    case couldNotEncodeFile
}

typealias PersistenceErrorBlock = (_ error: Error) -> ()

@objc class Persistence: NSObject {
    
    static var mode: PersistenceMode = .local
    static var ioMode: PersistenceIOMode = .userDefaults
    static var onErrorBlock: PersistenceErrorBlock?
    
    public class func saveStringToUserDefaults(string: String, key: String) {
        let defaults = UserDefaults.standard
        defaults.set(string, forKey: key)
    }
    
    public class func loadStringFromUserDefaults(key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    public class func purgeStringFromUserDefaults(key: String) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
    }
    
    // MARK: Loading
    public class func loadDictionary(filename: String) -> [String:Any]? {
        // Update filename to be dynamic per mode
        guard let jsonData = loadData(filename: filename) else {
            return nil
        }
        do {
            let allData = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
            guard let allDataDictionary = allData as? [String:Any] else {
                return nil
            }
            return allDataDictionary
        } catch {
            return nil
        }
    }
    
    public class func saveDictionary<T: Codable>(_ dictionary:[String:T], filename: String) -> Error? {
        guard let allData = try? JSONEncoder().encode(dictionary) else {
            return PersistenceError.couldNotEncodeFile
        }
        saveData(allData, filename: filename)
        return nil
    }
    
    public class func loadArray(filename: String) -> [[String:Any]]? {
        // Update filename to be dynamic per mode
        guard let jsonData = loadData(filename: filename) else {
            return nil
        }
        do {
            let allData = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
            guard let result = allData as? [[String:Any]] else {
                return nil
            }
            return result
        } catch {
            return nil
        }
    }
    
    public class func loadArray<T: Decodable>(filename: String, type: T.Type) -> [T]? {
        // Update filename to be dynamic per mode
        guard let jsonData = loadData(filename: filename) else {
            return nil
        }
        do {
            let result = try JSONDecoder().decode([T].self, from: jsonData)
            return result
        } catch {
            return nil
        }
    }
    
    public class func loadData(filename: String) -> Data? {
        switch ioMode {
        case .fileManagerAndBundle:
            return loadDataFromFilemanagerThenBundle(filename:filename)
        default:
            return loadDataFromUserDefaultsFor(filename:filename)
        }
    }
    
    public class func loadDataFromUserDefaultsFor(filename: String) -> Data? {
        if let data = UserDefaults.standard.value(forKey: filename) as? Data {
            return data
        }
        guard let data = bundleDataFromJSON(filenameWithoutExtension: filename) else {
            // Filename does not exist
            return nil
        }
        saveDataToUserDefaults(data, filename: filename)
        return data
    }
    
    private class func loadDataFromFilemanagerThenBundle(filename: String) -> Data? {
        if let data = fileManagerDataFromJSON(filenameWithoutExtension: filename) {
            return data
        }
        guard let data = bundleDataFromJSON(filenameWithoutExtension: filename) else {
            // Filename does not exist
            return nil
        }
        saveDataToFilemanager(data, filename: filename)
        return data
    }
    
    public class func fileManagerDataFromJSON(filenameWithoutExtension filename: String) -> Data? {
        guard let path = pathForJSON(filename: filename) else {
            Log.error("Could not get URL path for filename:\(filename)")
            return nil
        }
        do {
            let data = try Data.init(contentsOf: path)
            return data
        } catch {
            return nil
        }
    }
    
    public class func bundleDataFromJSON(filenameWithoutExtension filename: String) -> Data? {
        guard let fileURL = Bundle.main.url(forResource: filename, withExtension: "json") else {
            return nil
        }
        guard let data = try? Data(contentsOf: fileURL) else {
            return nil
        }
        return data
    }
    
    // MARK: Saving
    
    
    // TODO: Error handling
    @discardableResult
    class func saveData(_ data: Data, filename: String) -> Bool {
        switch ioMode {
        case .fileManagerAndBundle:
            return saveDataToFilemanager(data, filename: filename)
        default:
            return saveDataToUserDefaults(data, filename: filename)
        }
        //        switch mode {
        //        case .mock:
        //            saveMockData(data, filename: filename)
        //        default:
        //            // TODO:
        //            return
        //        }
    }
    
    class func saveMockData(_ data: Data, filename: String) {
        if ioMode == .fileManagerAndBundle {
            saveDataToFilemanager(data, filename: filename)
            return
        }
        saveDataToUserDefaults(data, filename: filename)
    }
    
    @discardableResult
    public class func saveDataToFilemanager(_ data: Data, filename: String) -> Bool {
        guard let url = pathForJSON(filename: filename) else {
            return false
        }
        let path = url.absoluteString
        if FileManager.default.fileExists(atPath: path) == false {
            FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
            return true
        }
        
        return overwriteData(data, url: url)
    }
    
    @discardableResult
    public class func saveDataToUserDefaults(_ data: Data, filename: String) -> Bool {
        let defaults = UserDefaults.standard
        defaults.set(data, forKey: filename)
        guard let savedData = defaults.value(forKey: filename) as? Data else {
            return false
        }
        return savedData == data
    }
    
    class func overwriteData(_ data: Data, url: URL) -> Bool {
        do {
            try data.write(to: url)
            return true
        } catch {
            return false
        }
    }
    
    class func pathForJSON(filename: String) -> URL? {
        let filemanager = FileManager.default
        let basePath = filemanager.documentsDirectory()
        var path = basePath.appendingPathComponent(filename)
        path.appendPathExtension("json")
        return path
    }
    
    // MARK: PURGE
    class func purgeData(filename:String) {
        purgeUserDefaultsData(key: filename)
        purgeFileManagerData(filename: filename)
    }
    
    class func purgeFileManagerData(filename: String) {
        guard let url = pathForJSON(filename: filename) else {
            // TODO: Error handling
            return
        }
        let path = url.absoluteString
        do {
            let _ = try FileManager.default.removeItem(atPath: path)
        } catch let e {
            onErrorBlock?(e)
        }
    }
    
    class func purgeUserDefaultsData(key: String) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
    }
}

extension FileManager {
    
    func documentsDirectory() -> URL {
        let paths = self.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}
