//
//  Publishers.swift
//  HelloPublishers
//
//  Created by Luann Luna on 06/05/22.
//

import Foundation
import Combine

let publisher = PassthroughSubject<Int, Never>().eraseToAnyPublisher()

