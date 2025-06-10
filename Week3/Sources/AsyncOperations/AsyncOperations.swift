import Foundation

// MARK: - Async Counter
public actor AsyncCounter {
    private var count: Int
    
    public init(initialValue: Int = 0) {
        self.count = initialValue
    }
    
    public func increment() {
        count += 1
    }
    
    public func decrement() {
        count -= 1
    }
    
    public func getCount() -> Int {
        count
    }
}

// MARK: - Image Loader
public actor ImageLoader {
    private var cache: [URL: Data] = [:]
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func loadImage(from url: URL) async throws -> Data {
        if let cachedData = cache[url] {
            return cachedData
        }
        
        let (data, _) = try await session.data(from: url)
        cache[url] = data
        return data
    }
    
    public func clearCache() {
        cache.removeAll()
    }
}

// MARK: - Task Manager
public class TaskManager {
    private var tasks: [String: Task<Void, Error>] = [:]
    
    public func startTask(id: String, operation: @escaping () async throws -> Void) {
        let task = Task {
            try await operation()
        }
        tasks[id] = task
    }
    
    public func cancelTask(id: String) {
        tasks[id]?.cancel()
        tasks.removeValue(forKey: id)
    }
    
    public func cancelAllTasks() {
        tasks.values.forEach { $0.cancel() }
        tasks.removeAll()
    }
}

// MARK: - Async Sequence
public struct AsyncCountdown: AsyncSequence {
    public typealias Element = Int
    
    private let start: Int
    
    public init(start: Int) {
        self.start = start
    }
    
    public func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator(start: start)
    }
    
    public struct AsyncIterator: AsyncIteratorProtocol {
        private var current: Int
        
        init(start: Int) {
            self.current = start
        }
        
        public mutating func next() async -> Int? {
            guard current > 0 else { return nil }
            let value = current
            current -= 1
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
            return value
        }
    }
}

// MARK: - Async Stream
public struct AsyncStreamExample {
    public static func createCountdownStream(from start: Int) -> AsyncStream<Int> {
        AsyncStream { continuation in
            Task {
                for i in (0...start).reversed() {
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    continuation.yield(i)
                }
                continuation.finish()
            }
        }
    }
}

// MARK: - Async Operation
public class AsyncOperation: Operation {
    private var task: Task<Void, Error>?
    
    public override func start() {
        task = Task {
            try await main()
        }
    }
    
    public override func cancel() {
        task?.cancel()
        super.cancel()
    }
    
    public func main() async throws {
        // Override this method in subclasses
    }
}

// MARK: - Async Operation Queue
public class AsyncOperationQueue {
    private let queue: OperationQueue
    
    public init(maxConcurrentOperations: Int = OperationQueue.defaultMaxConcurrentOperationCount) {
        queue = OperationQueue()
        queue.maxConcurrentOperationCount = maxConcurrentOperations
    }
    
    public func addOperation(_ operation: AsyncOperation) {
        queue.addOperation(operation)
    }
    
    public func cancelAllOperations() {
        queue.cancelAllOperations()
    }
} 