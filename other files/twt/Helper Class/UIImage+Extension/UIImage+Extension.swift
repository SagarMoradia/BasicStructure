//
//  UIImage+Extension.swift
//  DELRentals
//
//  Created by Sweta Vani on 16/11/18.
//  Copyright © 2018 Sweta Vani. All rights reserved.
//

import Foundation

extension UIImage {
    
    convenience init?(withContentsOfUrl url: URL) throws {
        let imageData = try Data(contentsOf: url)
        
        self.init(data: imageData)
    }
    
    convenience init?(url: URL?) {
        guard let url = url else { return nil }
        
        do {
            let data = try Data(contentsOf: url)
            self.init(data: data)
        } catch {
            print("Cannot load image from url: \(url) with error: \(error)")
            return nil
        }
    }
}
