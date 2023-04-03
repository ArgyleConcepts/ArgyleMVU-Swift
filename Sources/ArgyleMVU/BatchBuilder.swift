//
//  BatchBuilder.swift
//  ArgyleMVU
//
//  Created by David Cyman on 5/20/23.
//

import Foundation

@resultBuilder
public struct BatchBuilder {
 
    public static func buildBlock<Msg>(_ cmds: Cmd<Msg>...) -> Cmd<Msg> {
        return BatchCmd(cmds: cmds)
    }
    
    public static func buildEither<Msg>(first component: Cmd<Msg>) -> Cmd<Msg> {
        return BatchCmd(cmds: [component])
    }
    
    public static func buildEither<Msg>(second component: Cmd<Msg>) -> Cmd<Msg> {
        return BatchCmd(cmds: [component])
    }
    
}
