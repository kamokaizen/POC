//
//  CGRect+Utils.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 10/11/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import UIKit

extension CGRect {
    var minEdge: CGFloat {
        return min(width, height)
    }
}
