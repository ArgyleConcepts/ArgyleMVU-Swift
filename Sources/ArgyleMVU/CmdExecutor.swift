//
//  CmdExecutor.swift
//  ArgyleMVU
//
//  Created by David Cyman on 4/3/23.
//

import Foundation

final class CmdExecutor {
    
    // MARK: Static Properties
    
    static let shared = CmdExecutor()
    
    // MARK: Methods
    
    func execute<Msg>(_ cmd: Cmd<Msg>) async -> [Msg] {
        return await cmd()
    }
    
}
