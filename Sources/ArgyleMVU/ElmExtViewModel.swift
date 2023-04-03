//
//  ElmExtViewModel.swift
//  ArgyleMVU
//
//  Created by David Cyman on 5/20/23.
//

import Foundation

public protocol ExtViewModelDelegate<Model, ExtMsg>: AnyObject {
    
    associatedtype Model
    associatedtype ExtMsg
    
    func didUpdate(to model: Model, extMsg: ExtMsg)
    
}

@MainActor
open class ElmExtViewModel<Model, Msg, ExtMsg>: ObservableObject, ViewModel {
    
    // MARK: Properties
    
    @Published public private(set) var model: Model
    
    public weak var delegate: (any ExtViewModelDelegate<Model, ExtMsg>)?
    
    // MARK: Init
    
    public init(model: Model, delegate: (any ExtViewModelDelegate<Model, ExtMsg>)) {
        self.model = model
        self.delegate = delegate
    }
    
    // MARK: Methods
    
    open func update(msg: Msg) -> (Model, Cmd<Msg>?, ExtMsg?) {
        assertionFailure("This should be overridden by subclasses")
        
        return (model, nil, nil)
    }
    
    public final func update(_ msg: Msg) {
        Task {
            await update(msg)
        }
    }
    
    public final func update(_ msg: Msg) async {
        let (model, cmd, extMsg) = update(msg: msg)
        self.model = model
        
        if let extMsg {
            delegate?.didUpdate(to: model, extMsg: extMsg)
        }
        
        if let cmd {
            for result in await CmdExecutor.shared.execute(cmd) {
                await update(result)
            }
        }
    }
    
}
