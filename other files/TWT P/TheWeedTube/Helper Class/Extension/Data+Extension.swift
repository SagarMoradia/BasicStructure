//
//  Data+Extension.swift
//  Created by bviadmin on 11/07/18.
//  Copyright © 2018 BV. All rights reserved.
//

import UIKit

extension Data
{
    func toString() -> String
    {
        return String(data: self, encoding: .utf8)!
    }
}
