//
//  Cmd.swift
//  ArgyleMVU
//
//  Created by David Cyman on 4/3/23.
//

import Foundation

public class Cmd<Msg> {
    
    // MARK: Methods
    
    func callAsFunction() async -> [Msg] {
        return []
    }
    
    // MARK: Public Methods
    
    public func map<NewMsg>(_ transform: @escaping (Msg) -> NewMsg) -> Cmd<NewMsg> {
        return MapCmd(cmd: self, transform: transform)
    }
    
}

// MARK: - ActionCmd

final class ActionCmd<Msg>: Cmd<Msg> {
    
    // MARK: Properties
    
    private let action: () -> Msg
    
    // MARK: Init
    
    init(action: @escaping () -> Msg) {
        self.action = action
    }
    
    // MARK: Cmd
    
    override func callAsFunction() async -> [Msg] {
        let msg = await withCheckedContinuation { continuation in
            let result = action()
            continuation.resume(returning: result)
        }
        
        return [msg]
    }
    
}

// MARK: - TaskCmd

final class TaskCmd<Msg>: Cmd<Msg> {
    
    // MARK: Properties
    
    private let task: Task<Msg, Never>
    
    // MARK: Init
    
    init(task: Task<Msg, Never>) {
        self.task = task
    }
    
    // MARK: Cmd
    
    override func callAsFunction() async -> [Msg] {
        [await task.value]
    }
    
}

// MARK: - BatchCmd

final class BatchCmd<Msg>: Cmd<Msg> {
    
    // MARK: Properties
    
    private let cmds: [Cmd<Msg>]
    
    // MARK: Init
    
    init(cmds: [Cmd<Msg>]) {
        self.cmds = cmds
    }
    
    // MARK: Cmd
    
    override func callAsFunction() async -> [Msg] {
        return await withTaskGroup(of: [Msg].self) { taskGroup in
            for cmd in cmds {
                taskGroup.addTask { await cmd() }
            }
            
            return await taskGroup.reduce(into: []) { partialResult, result in
                partialResult.append(contentsOf: result)
            }
        }
    }
    
}

// MARK: - MapCmd

final class MapCmd<Msg, OldMsg>: Cmd<Msg> {
    
    // MARK: Properties
    
    private let cmd: Cmd<OldMsg>
    private let transform: (OldMsg) -> Msg
    
    // MARK: Init
    
    init(cmd: Cmd<OldMsg>, transform: @escaping (OldMsg) -> Msg) {
        self.cmd = cmd
        self.transform = transform
    }
    
    override func callAsFunction() async -> [Msg] {
        let value = await cmd()
        return value.map(transform)
    }
    
}
