//
//  LocalFileManager.swift
//  CryptoTracker
//
//  Created by Sajad Abedi on 01.10.2022.
//

import Foundation
import SwiftUI

class LocalFileManager {
    
    static let instance = LocalFileManager()
    private init() {}
    
    // MARK: Save
    func saveImage(img: UIImage, imgName: String, folderName: String) {
        createFolderIfNeeded(name: folderName) // First, create folder if needed
        
        guard let data = img.pngData(),
              let url = getURLImage(imgName: imgName, folderName: folderName)
        else { return }

        do {
            try data.write(to: url)
        } catch let err {
            print("Error saving image. \(err)")
        }
    }
    // MARK: Create Folder
    private func createFolderIfNeeded(name: String) {
        guard let url = getURLFolder(folderName: name) else { return }
        
        if !FileManager.default.fileExists(atPath: url.path()) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            } catch let err {
                print("Error creating folder. \(err)")
            }
        }
    }
    
    func getImage(name: String, folder: String) -> UIImage? {
        guard let url = getURLImage(imgName: name, folderName: folder),
              FileManager.default.fileExists(atPath: url.path()) else { return nil }
        return UIImage(contentsOfFile: url.path())
    }
    
    private func getURLFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {return nil}
        return url.appendingPathComponent(folderName)
    }
    
    private func getURLImage(imgName: String, folderName: String) -> URL? {
        guard let folderURL = getURLFolder(folderName: folderName) else {return nil}
        return folderURL.appendingPathComponent(imgName + ".png")
    }
}
