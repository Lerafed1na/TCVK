//
//  RootAssembly.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 07/04/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import Foundation

class RootAssembly {
    private lazy var coreAssembly: ICoreAssembly = CoreAssembly()
    lazy var presentationAssembly: IPresentationAssembly = PresentationAssembly(serviceAssembly: self.serviceAssembly)
    private lazy var serviceAssembly: IServiceAssembly = ServiceAssembly(coreAssembly: self.coreAssembly)
}
