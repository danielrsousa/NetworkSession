//
//  MyViewClass.swift
//  NetworkSession
//
//  Created by Daniel Rocha de Sousa on 02/12/20.
//  Copyright © 2020 Daniel Rocha. All rights reserved.
//

import UIKit

@objc
public class MyViewClass: UIView {
    
    @objc
    public init(teste: String) {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
