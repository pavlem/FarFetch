//
//  FileHelper.swift
//  Opi
//
//  Created by Pavle Mijatovic on 7/27/17.
//  Copyright © 2017 Carnegie Technologies. All rights reserved.

import Foundation
import UIKit
import AVFoundation

let fileManager = FileManager.default

class FileHelper {
    
    class func fileExists(atPath path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    class func skipCloudBackup(path: String) -> Bool {
        let url: Foundation.URL = URL(fileURLWithPath: path)
        
        assert(FileManager.default.fileExists(atPath: path), "File \(path) does not exist")
        
        var success: Bool
        do {
            try (url as NSURL).setResourceValue(true, forKey: URLResourceKey.isExcludedFromBackupKey)
            success = true
        } catch let error as NSError {
            success = false
            print("Error excluding \(url.lastPathComponent) from backup \(error)")
        }
        
        return success
    }
    
    class func createDirectoryAtPath(_ path: String) {
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    class func removeDirectoryAtPath(_ path: String) {
        do {
            try FileManager.default.removeItem(atPath: path)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    class func removeFile(path: String) {
        removeDirectoryAtPath(path)
    }
    
    class func saveDataToFileSystem(_ data: Data, atFilePath filePath: String) {
        try? data.write(to: URL(fileURLWithPath: filePath), options: [.atomic])
    }
    
    class func getFile(atPath path: String) -> Data? {
        return FileManager.default.contents(atPath: path)
    }
    
    class func renameFile(atPath path: URL, newName: String) -> URL {
        let destinationPath = path.deletingLastPathComponent().appendingPathComponent(newName)
        do {
            try FileManager.default.moveItem(at: path, to: destinationPath)
            return destinationPath
        } catch {
            return path
        }
    }
    
    class func copyFile(atPath path: URL, newName: String) -> URL {
        let destinationPath = path.deletingLastPathComponent().appendingPathComponent(newName)
        do {
            try FileManager.default.copyItem(at: path, to: destinationPath)
            return destinationPath
        } catch let error {
            return path
        }
    }
    
    class func getFileNamesInFolder(path: String) -> [String]? {
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: path)
            return filePaths
            
        } catch let error as NSError {
            print("Could not clear temp folder: \(error.debugDescription)")
            return nil
        }
    }
    
    class func documentsDirectoryPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    }
    
    static var docDirectoryPath: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    }
    
    class func clearFolder(path: String) {
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: path)
            for filePath in filePaths {
                try fileManager.removeItem(atPath: path + "/" + filePath)
            }
        } catch let error as NSError {
            print("Could not clear temp folder: \(error.debugDescription)")
        }
    }
    
    class func clearTempFolder() {
        let tempFolderPath = NSTemporaryDirectory()
        clearFolder(path: tempFolderPath)
    }
}

// MARK: - OPI File System
extension FileHelper {
    static var mediaDirectory: String {
        return docDirectoryPath + "/Media"
    }
    
    class func save(img: UIImage, toPath localPath: URL) {
        do {
            try UIImageJPEGRepresentation(img, 1.0)?.write(to: localPath)
            print("file saved")
        } catch {
            print("error saving file")
        }
    }

}

extension FileManager {
    class func documentsDir() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
    
    class func cachesDir() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
}
