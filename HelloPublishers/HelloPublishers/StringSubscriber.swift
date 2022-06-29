//
//  StringSubscriber.swift
//  HelloPublishers
//
//  Created by Luann Luna on 06/05/22.
//

import Foundation
import Combine

enum MyError: Error {
    case defaultError
}

class StringSubscriber: Subscriber {
    
    typealias Input = String
    typealias Failure = MyError
    
    func receive(subscription: Subscription) {
        print("Received Subscription")
        subscription.request(.max(3)) //backpressure
    }
    
    func receive(_ input: String) -> Subscribers.Demand {
        print("Received Value", input)
        
        return .max(1)
    }
    
    func receive(completion: Subscribers.Completion<MyError>) {
        print("Completed")
    }
}
