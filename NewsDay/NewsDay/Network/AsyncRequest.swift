//
//  AsyncRequest.swift
//  NewsDay
//
//  Created by Norberto Taveras on 9/17/19.
//  Copyright © 2019 Norberto Taveras. All rights reserved.
//

import Foundation

class AsyncRequest {
    var result: AnyObject?
    var error: Error?
    
    // List of callbacks to make when the result is set
    // When the result has been set, pending is reset to nil
    var pending: [(AnyObject?, Error?) -> Void]?
    
    init() {
        pending = []
    }
    
    func setResult(result: AnyObject?, error: Error?) {
        print("setResult called")
        
        // Dispatch onto main queue to synchronize access to class data
        DispatchQueue.main.async {
            self.setResultMain(
                resultValue: result,
                resultError: error)
        }
    }
    
    func setResultMain(resultValue: AnyObject?, resultError: Error?) {
        print("setResult on main thread on instance \(self)")
        
        // Remember the result for future calls to withResult
        result = resultValue
        error = resultError
        
        guard let validPending = self.pending else {
            print("setResult called again, not calling pending")
            // Occurs if/when someone calls setResult again,
            // to update the data
            return
        }
        
        print("Calling \(validPending.count) callbacks")
        
        // Call all the callbacks that were requested too early
        // "Too early" means before setResult got called
        for callback in validPending {
            print("setResult calling callback")
            callback(result, error)
        }
        
        // No need for pending list anymore, we have the result
        pending = nil
    }
    
    func withResult(callback: @escaping (AnyObject?, Error?) -> Void) {
        // Dispatch onto main queue to synchronize access to class data
        DispatchQueue.main.async {
            if self.pending != nil {
                // Caller needed result, but too early
                // push their callback onto the pending list
                print("pushing callback onto pending list onto instance \(self)")
                self.pending!.append(callback)
            } else {
                // Have the result already, call callback ASAP
                print("calling callback ASAP")
                DispatchQueue.main.async {
                    print("calling callback")
                    callback(self.result, self.error)
                }
            }
        }
    }
}
