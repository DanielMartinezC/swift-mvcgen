//
//  FilesManager.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class FilesManager: NSObject {
    
    static let sharedInstance = FilesManager()
    
    fileprivate override init() {
        super.init()
    }
    
    func getDocumentsURL() -> URL {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL
        
    }
    
    func fileInDocumentsDirectory(_ filename: String) -> String {
        
        let fileURL = self.getDocumentsURL().appendingPathComponent(filename)
        return fileURL.path
        
    }
    
    func fileModificationDate(_ filename: String) -> Date? {
        do {
            let path = self.fileInDocumentsDirectory(filename)
            let attr = try FileManager.default.attributesOfItem(atPath: path)
            return attr[FileAttributeKey.modificationDate] as? Date
        } catch {
            return nil
        }
    }
    
    func saveMedia(_ media: Data, filename: String ) -> Bool {
        let path = self.fileInDocumentsDirectory(filename)
        let result = (try? media.write(to: URL(fileURLWithPath: path), options: [.atomic])) != nil
        print("Save media at: \(self.fileInDocumentsDirectory(filename))")
        print("Result: \(result)")
        return result
    }

    func loadMedia(_ filename: String) -> Data? {
        
        let path = self.fileInDocumentsDirectory(filename)
        
        let media = try? Data(contentsOf: URL(fileURLWithPath: path))
        
        if media == nil {
            print("Missing media at: \(path)")
        }
        print("Loading media from path: \(path)")
        
        return media
    }
    
    func removeMedia(filename: String) -> Bool {
        let fileURL = fileInDocumentsDirectory(filename)
        do {
            try FileManager.default.removeItem(atPath: fileURL)
            return true
        } catch {
            print("Error removing media \(filename) error: \(error)")
            return false
        }
    }
    
    func removeAllAppLocalFiles() {
        do {
            let fileManager = FileManager.default
            let documentsPath = getDocumentsURL().path
            let fileNames = try fileManager.contentsOfDirectory(atPath: "\(documentsPath)")
            print("all files : \(fileNames)")
            
            for fileName in fileNames {
                let filePathName = "\(documentsPath)/\(fileName)"
                print(filePathName)
                try fileManager.removeItem(atPath: filePathName)
            }
            print("All app files cleared")
        } catch {
            print("Couldn't clear all files")
        }
    
    }
    
}
