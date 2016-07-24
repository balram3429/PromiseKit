import CoreBluetooth
import Foundation
#if !COCOAPODS
import PromiseKit
#endif


private class CentralManager: CBCentralManager, CBCentralManagerDelegate {
  
  let (promise, fulfill, reject) = CentralManagerPromise.deferred()

  @objc private func centralManagerDidUpdateState(_ central: CBCentralManager) {
    if central.state != .unknown {
      fulfill(central)
    }
  }
}

extension CBCentralManager {
  
  public class func promise() -> CentralManagerPromise {
    let manager = CentralManager(delegate: nil, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: false])
    manager.delegate = manager
    manager.promise.always {
      manager.delegate = nil
    }
    return manager.promise
  }
}

public class CentralManagerPromise: Promise<CBCentralManager> {
  
  private let (parentPromise, fulfill, reject) = Promise<CBCentralManager>.pending()
  
  private class func deferred() -> (CentralManagerPromise, (CBCentralManager) -> Void, (Error) -> Void) {
    var fullfill: ((CBCentralManager) -> Void)!
    var reject: ((Error) -> Void)!
    let promise = CentralManagerPromise { fullfill = $0; reject = $1 }
    promise.parentPromise.then(on: zalgo, execute: fullfill)
    promise.parentPromise.catch(on: zalgo, execute: reject)
    return (promise, promise.fulfill, promise.reject)
  }
}
