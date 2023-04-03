//
//  ElmViewModel.swift
//  ArgyleMVU
//
//  Created by David Cyman on 4/3/23.
//

import Foundation

@MainActor
open class ElmViewModel<Model, Msg>: ObservableObject, ViewModel {
    
    // MARK: Properties
    
    @Published public private(set) var model: Model
    
    // MARK: Init
    
    public init(model: Model) {
        self.model = model
    }
    
    // MARK: Methods
    
    open func update(msg: Msg) -> (Model, Cmd<Msg>?) {
        assertionFailure("This should be overridden by subclasses")
        
        return (model, nil)
    }
    
    public final func update(_ msg: Msg) {
        Task {
            await update(msg)
        }
    }
    
    public final func update(_ msg: Msg) async {
        let (model, cmd) = update(msg: msg)
        self.model = model
        
        guard let cmd else { return }
        
        for result in await CmdExecutor.shared.execute(cmd) {
            await update(result)
        }
    }

}
