//
//  CellInterface.swift
//  SwiftLearning
//
//  Created by qky on 16/11/1.
//  Copyright © 2016年 boostfield. All rights reserved.
//

import UIKit

public protocol CellInterface {
    associatedtype DataType
    static var id: String { get }
    static var cellNib: UINib { get }
    func bindData(data: DataType)
}

extension CellInterface {
    
    static var id: String {
        return String(describing: Self.self)
    }
    
    static var cellNib: UINib {
        return UINib(nibName: id, bundle: nil)
    }
    
}
