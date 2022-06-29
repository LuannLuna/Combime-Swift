//
//  ContentView.swift
//  HelloPublishers
//
//  Created by Luann Luna on 06/05/22.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    let center = NotificationCenter.default
    let notification = Notification.Name("myNotification")
    
    init() {
        //Map().run()
        Filter().run()
        
    }
    
    private func usingSubject() {
        let subscriber = StringSubscriber()
        
        let subject = PassthroughSubject<String, MyError>()
        
        subject.subscribe(subscriber)
        
        let subscription = subject.sink { completion in
            print("Received Completion from sink")
        } receiveValue: { value in
            print("Received Value from sink", value)
        }

        
        subject.send("A")
        subject.send("B")
        
        subscription.cancel()
        
        subject.send("C")
        subject.send("D")
    }
    
    private func simpleNotificationExample() {
        let publisher = center.publisher(for: notification, object: nil)
        
        let subscriber = publisher.sink { _ in
            print("Recevied")
        }
        
        center.post(name: notification, object: nil)
        
        subscriber.cancel()
        
        center.post(name: notification, object: nil)
    }
    
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
