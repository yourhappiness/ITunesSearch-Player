//
//  Observer.swift
//  iOSArchitecturesDemo
//
//  Created by Stanislav Ivanov on 30.10.2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import Foundation


class Observable<Type> {
    
    var value: Type {
        didSet {
            self.didChanded(oldValue: oldValue, newValue: value)
        }
    }
    
    init(value: Type) {
        self.value = value
    }
    
    fileprivate class Observer<Type> {
        weak var object: AnyObject?
        var callback: ( (_ oldValue: Type, _ newValue: Type) -> Void )?
    }
    
    func addObserver(anyObject: AnyObject?, callback: @escaping ( (_ oldValue: Type, _ newValue: Type) -> Void )) {
        let observer = Observer<Type>()
        observer.object = anyObject
        observer.callback = callback
        self.observers.append(observer)
    }
    
    private var observers: [Observer<Type>] = []
    
    private func didChanded(oldValue: Type, newValue: Type) {
        
        self.observers.removeAll { (observer) -> Bool in
            return nil == observer.object
        }
        
        for observer in self.observers {
            guard let callback = observer.callback else { continue }
            
            callback(oldValue, newValue)
        }
    }
}
