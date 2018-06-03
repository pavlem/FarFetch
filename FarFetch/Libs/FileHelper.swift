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
    
    class func documentsDir() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
}
