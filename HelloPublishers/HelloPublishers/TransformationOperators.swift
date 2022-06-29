//
//  TransformationOperators.swift
//  HelloPublishers
//
//  Created by Luann Luna on 06/05/22.
//

import Foundation
import Combine

protocol Runner {
    func run()
}


var operators: [Runner] = []

class Collect: Runner {
    func run() {
        ["A", "B", "C", "D"].publisher.collect().sink { array in
            print(array)
        }
        
        
        ["A", "B", "C", "D", "E"].publisher.collect(3).sink { array in
            print(array)
            // ["A", "B", "C"]
            // ["D", "E"]
        }
    }
}

class Map: Runner {
    func run() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        
        [123, 45, 67].publisher.map {
            formatter.string(from: NSNumber(integerLiteral: $0)) ?? ""
        }.sink {
            print($0)
        }
        
        runMap()
    }
    
    struct Point {
        let x: Int
        let y: Int
    }
    
    func runMap() {
        
        let publisher = PassthroughSubject<Point, Never>()
        
        publisher.map(\.x, \.y).sink { x, y in
            print("X: \(x) - Y: \(y)")
        }
        
        publisher.send(Point(x: 2, y: 10))
    }
}



class FlatMap: Runner {
    struct School {
        let name: String
        let noOfStudents: CurrentValueSubject<Int, Never>
        
        init(name: String, noOfStudents: Int) {
            self.name = name
            self.noOfStudents = CurrentValueSubject(noOfStudents)
        }
    }
    
    func run() {
        let citySchool = School(name: "Fountain Head Schoold", noOfStudents: 100)
        
        let school = CurrentValueSubject<School, Never>(citySchool)
        
        school.flatMap {
            $0.noOfStudents
        }.sink {
            print($0)
        }
        
        let townSchool = School(name: "Town Head Schoold", noOfStudents: 45)
        
        school.value = townSchool
        
        citySchool.noOfStudents.value += 1
    }
}


class ReplaceNil: Runner {
    func run() {
        ["A", "B", nil, "C"].publisher.replaceNil(with: "*")
            .map { $0! } // no have problems because we replace nil values
            .sink {
                print($0)
            }
    }
}

class ReplaceEmpty: Runner {
    func run() {
        let empty = Empty<Int, Never>()
        
        empty
            .replaceEmpty(with: 1)
            .sink {
                print($0)
            } receiveValue: {
                print($0)
            }
    }
}


class Scan: Runner {
    func run() {
        let publisher = (1...10).publisher
        
        publisher.scan([]) { numbers, value -> [Int] in
            numbers + [value]
        }
        .sink { print($0) }
    }
}

class Filter: Runner {
    func run() {
        let numbers = (1...20).publisher
        
        numbers.filter { $0 % 2 == 0 }
        .sink { print($0) // 2 4 6 8 10 12 14 16 18 20
        }
    }
}

class RemoveDuplicates: Runner {
    func run() {
        let words = "apple apple fruit fruit apple mano watermelon apple".components(separatedBy: " ").publisher
        
        words
            .removeDuplicates()
            .sink {
                print($0) // apple fruit apple mano watermelon apple
            }
    }
}

class CompactMap: Runner {
    func run() {
        let strings = ["A", "1.24", "C", "3.45", "6.7"].publisher.compactMap { Float($0) }
            .sink {
                print($0) // 1.24 // 3.45 // 6.7
            }
    }
}

class IgnoreOutput: Runner {
    func run() {
        let numbers = (1...50000).publisher
        
        numbers
            .ignoreOutput()
            .sink(receiveCompletion: {
                print($0) }) { // finished
                    print($0) }
    }
}


class First: Runner {
    func run() {
        let numbers = (1...9).publisher
        
        numbers
            .first(where: { $0 % 2 == 0 })
            .sink {
                print($0) // 2
            }
    }
}

class Last: Runner {
    func run() {
        let numbers = (1...9).publisher
        
        numbers
            .last(where: { $0 % 2 == 0 })
            .sink {
                print($0) // 8
            }
    }
}

class DropFirst: Runner {
    func run() {
        let numbers = (1...10).publisher
        
        numbers.dropFirst(8)
            .sink {
                print($0) // 9 10
            }
    }
}

class DropWhile: Runner {
    func run() {
        let numbers = (1...10).publisher
        
        numbers.drop(while: { $0 % 3 != 0 })
            .sink {
                print($0) // 3 4 5 6 7 8 9 10
            }
    }
}

class DropUntil: Runner {
    func run() {
        let taps = PassthroughSubject<Int, Never>()
        
        let isReady = PassthroughSubject<Void, Never>()
        
        taps.drop(untilOutputFrom: isReady)
            .sink {
                print($0) // 4 5 6 7 8 9 10
            }
        
        (1...10).forEach { n in
            taps.send(n)
            
            if n == 3 {
                isReady.send()
            }
        }
    }
}


class Prefix: Runner {
    func run() {
        let numbers = (1...10).publisher
        
        numbers.prefix(2)
            .sink {
                print($0) // 1 2
            }
    }
}
