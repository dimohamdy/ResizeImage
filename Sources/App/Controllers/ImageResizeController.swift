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
        
            //get url from request
            let urlString = try req.query.get(String.self, at: "url")
            //get width from request
            let width = try req.query.get(Int.self, at: "width")
            //get height from request
            let height = try req.query.get(Int.self, at: "height")
        
        let fileName = FilesHelper.geNewFileName(urlString: urlString, width: width, height: height)
            //check image is found
            if FilesHelper.isFound(fileName: fileName) {
                //return image if it found in folder
                //redirect to image to make it downloadable
                return req.future(req.redirect(to: fileName))
            }
        
            //get client from current request
            let client = try req.make(Client.self)
            //try to download image from url
            let response = client.get(urlString)
        
            let data = response.map(to:  Data.self, { respo -> Data in
                return respo.http.body.data!
                
            }).map({ [weak self] data -> Response  in
                guard self != nil else {
                    return req.response()
                }
                
                
                let destination = FilesHelper.getImagePath(fileName: fileName)
                var image = try Image.init(data: data)//convert Data to Image Object
                
                if  width > 0 && height > 0 {
                    //resize image to new width and height
                    image = image.resizedTo(width: width, height: height)!
                }else {
                    image = image.resizedTo(width: 70, height: 70)!
                }
                //save image to new destination
                image.write(to: destination)
                //redirect to image to make it downloadable
                return req.redirect(to: fileName)
                
            })
            return data

    }

}
