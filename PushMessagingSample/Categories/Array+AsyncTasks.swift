//
//  Array+AsyncTasks.swift
//  FirstImpressionSwift
//
//  Created by Tealium User on 3/2/18.
//  Copyright © 2018 Jason Koo. All rights reserved.
//

import Foundation


typealias AsyncTask = (_ result: Any?, _ completion: @escaping AsyncTaskCompletion)->()
typealias AsyncTaskCompletion = (_ result: Any?)->()

enum AsyncTaskResult {
    case unknown
    case ended
}

extension Array {
    
    func runAsyncTasks() {
        runAsyncTask(index: 0,
                     state: nil)
    }
    
    func runAsyncTasks(loops: Int,
                       initialState: Any?,
                       completion: (()->())?) {
        let endState = runAsyncTask(index: 0,
                                    state: nil)
        let newLoops = loops - 1
        if newLoops == 0 {
            completion?()
            return
        }
        runAsyncTasks(loops: newLoops,
                      initialState: endState,
                      completion: completion)
    }
    
    @discardableResult
    internal func runAsyncTask(index: Int,
                               state: Any?) -> Any? {
        
        if index >= self.count {
            return state
        }
        
        let nextIndex = index + 1
        
        guard let task = self[index] as? AsyncTask else {
            // Not an async task, skip
            return runAsyncTask(index: nextIndex,
                                state: state )
        }
        
        task(state) { (nextState) in
            return self.runAsyncTask(index: nextIndex,
                                     state: nextState)
        }
        
        return state
    }
    
}
