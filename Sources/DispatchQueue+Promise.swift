import Dispatch

/**
 ```
 DispatchQueue.global().promise {
     try md5(input)
 }.then { md5 in
     //…
 }
 ```

 - Parameter body: The closure that resolves this promise.
 - Returns: A new promise resolved by the result of the provided closure.
*/
extension DispatchQueue {
    @available(*, unavailable, message: "TODO URL")
    public func promise<T>(group: DispatchGroup? = nil, qos: DispatchQoS = .default, flags: DispatchWorkItemFlags = [], execute body: () throws -> T) -> Promise<T> {
        abort()
    }

    public func promise<T>(group: DispatchGroup? = nil, qos: DispatchQoS = .default, flags: DispatchWorkItemFlags = [], execute body: () throws -> Promise<T>) -> Promise<T> {

        return Promise(sealant: { resolve in
            async(group: group, qos: qos, flags: flags) {
                do {
                    try body().state.pipe(resolve)
                } catch {
                    resolve(Resolution(error))
                }
            }
        })
    }
}
