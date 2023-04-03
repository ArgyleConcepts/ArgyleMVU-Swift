//
//  ViewModel.swift
//  ArgyleMVU
//
//  Created by David Cyman on 5/20/23.
//

import Foundation

public protocol ViewModel<Msg> {
    
    associatedtype Msg
    
}

public extension ViewModel {
    
    func action(_ action: @escaping () -> Msg) -> Cmd<Msg> {
        return ActionCmd(action: action)
    }
    
    func task(_ perform: @escaping () async -> Msg) -> Cmd<Msg> {
        let task = Task {
            await perform()
        }
        
        return TaskCmd(task: task)
    }
    
    func detached(_ perform: @escaping () async -> Msg) -> Cmd<Msg> {
        let task = Task.detached {
            await perform()
        }
        
        return TaskCmd(task: task)
    }
    
    func batch(@BatchBuilder _ builder: () -> Cmd<Msg>) -> Cmd<Msg> {
        builder()
    }
    
}
