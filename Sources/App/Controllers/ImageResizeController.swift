//
//  ImageResizeController.swift
//  ImageResizer
//
//  Created by BinaryBoy on 4/3/19.
//

import Vapor
import SwiftGD

final class ImageResizeController: RouteCollection {
    func boot(router: Router) throws {
        let routes = router.grouped("resize")
        routes.get(use: index)

    }

    func index(_ req: Request) throws -> Future<Response> {
        
            let urlString = try req.query.get(String.self, at: "url")
            let width = try req.query.get(Int.self, at: "width")
            let height = try req.query.get(Int.self, at: "height")
            
            let fileName = URL(fileURLWithPath: urlString).lastPathComponent
            if isFound(fileName: fileName) {
                return req.future(req.redirect(to: fileName))
            }
            let client = try req.make(Client.self)
            let response = client.get(urlString)
            let data = response.map(to:  Data.self, { respo -> Data in
                return respo.http.body.data!
                
            }).map({ [weak self] data -> Response  in
                guard let self = self else {
                    return req.response()
                }
                let destination = self.getImagePath(fileName: fileName)
                var image = try Image.init(data: data)
                if  width > 0 && height > 0 {
                    image = image.resizedTo(width: width, height: height)!
                }else {
                    image = image.resizedTo(width: 70, height: 70)!
                }
                
                image.write(to: destination)
                return req.redirect(to: fileName)
                
            })
            return data

    }
    
    func getImagePath(fileName:String) -> URL{
        
        let directory = DirectoryConfig.detect()
        let workingDirectory = directory.workDir
        let workingDirectoryPath = URL(fileURLWithPath:workingDirectory)
        let destination = workingDirectoryPath.appendingPathComponent("Public/\(fileName)")
        return destination
    }
    
    func isFound(fileName:String) -> Bool{
        let destination = getImagePath(fileName: fileName)
        return  FileManager().fileExists(atPath: destination.path)
    }
}
