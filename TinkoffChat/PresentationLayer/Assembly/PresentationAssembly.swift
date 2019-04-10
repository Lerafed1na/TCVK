//
//  PresentationAssembly.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 07/04/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import Foundation

protocol IPresentationAssembly {

}

class PresentationAssembly: IPresentationAssembly {

    var serviceAssembly: IServiceAssembly
    
    init(serviceAssembly: IServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
}
