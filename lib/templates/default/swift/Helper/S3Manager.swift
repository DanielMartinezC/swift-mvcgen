//
//  S3Manager.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import UIKit
import AWSS3

class S3Manager: NSObject{
    
    // MARK: - Singleton
    static let sharedInstance = S3Manager()
    
    let transferManager = AWSS3TransferManager.default()
    
    private override init() {}
    
    func uploadToS3(url uploadingFileURL: URL, name key: String, completeBlock: @escaping (Bool) -> Void) {
        
        if let uploadRequest = AWSS3TransferManagerUploadRequest() {
            
            uploadRequest.bucket = Config.sharedInstance.s3BucketName()
            uploadRequest.key = key
            uploadRequest.body = uploadingFileURL
            self.transferManager.upload(uploadRequest).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
                
                if let error = task.error as NSError? {
                    if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                        switch code {
                        case .cancelled, .paused:
                            break
                        default:
                            print("Error uploading: \(uploadRequest.key!) Error: \(error)")
                        }
                    } else {
                        print("Error uploading: \(uploadRequest.key!) Error: \(error)")
                    }
                    completeBlock(false)
                    return nil
                }
                
                if let uploadOutput = task.result {
                    print("Upload complete for: \(uploadRequest.key!) - Output \(uploadOutput)")
                    completeBlock(true)
                }
                
                return nil
            })
        }
    }
    
    func downloadFromS3(downloadingFilename: String, name key: String, completeBlock: @escaping (String, Bool) -> Void) {
        if let downloadRequest = AWSS3TransferManagerDownloadRequest() {
            
            downloadRequest.bucket = Config.sharedInstance.s3BucketName()
            downloadRequest.key = key
            downloadRequest.downloadingFileURL = URL(fileURLWithPath: FilesManager.sharedInstance.fileInDocumentsDirectory(downloadingFilename))
            self.transferManager.download(downloadRequest).continueWith(executor: AWSExecutor.mainThread(), block: { (task: AWSTask<AnyObject>) -> Any? in
                if let error = task.error as NSError? {
                    if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                        switch code {
                        case .cancelled, .paused:
                            break
                        default:
                            print("Error downloading: \(downloadRequest.key!) Error: \(error)")
                        }
                    } else {
                        print("Error downloading: \(downloadRequest.key!) Error: \(error)")
                    }
                    completeBlock(downloadingFilename, false)
                    return nil
                }
                
                if let downloadOutput = task.result {
                    print("Download complete for: \(downloadRequest.key!) - Output \(downloadOutput)")
                    completeBlock(downloadingFilename, true)
                }
                return nil
            })
        }
    }
    
    func downloadFromS3Aux(downloadRequest: AWSS3TransferManagerDownloadRequest,downloadingFilename:String,completeBlock: @escaping (String, Bool) -> Void) {
       self.transferManager.download(downloadRequest).continueWith(executor: AWSExecutor.mainThread(), block: { (task: AWSTask<AnyObject>) -> Any? in
            if let error = task.error as NSError? {
                if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                    switch code {
                    case .cancelled, .paused:
                        break
                    default:
                        break
                        print("Error downloading: \(downloadRequest.key!) Error: \(error)")
                    }
                } else {
                    print("Error downloading: \(downloadRequest.key!) Error: \(error)")
                }
                completeBlock(downloadingFilename, false)
                return nil
            }
            print("Download complete for: \(downloadRequest.key!)")
            
            if let downloadOutput = task.result {
                print("Download complete for: \(downloadRequest.key!) - Output \(downloadOutput)")
                completeBlock(downloadingFilename, true)
            }
            return nil
        })
    }

}
