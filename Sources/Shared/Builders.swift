import Foundation

// MARK: - Given Builders

/// Builder returned by Given() for chaining stubbing behavior on non-throwing methods
public struct GivenBuilder<MockType: Mock, ReturnType> {
    private let mock: MockType
    private let stubFactory: (MockType, [StubProduct]) -> MockType.Given

    public init(
        mock: MockType,
        stubFactory: @escaping (MockType, [StubProduct]) -> MockType.Given
    ) {
        self.mock = mock
        self.stubFactory = stubFactory
    }

    /// Stub method to return specific values in sequence
    ///
    /// - Parameter values: Values to return on successive calls
    public func willReturn(_ values: ReturnType...) {
        let products = values.map { StubProduct.return($0 as Any) }
        let given = stubFactory(mock, products)
        mock.given(given)
    }

    /// Stub method using Stubber for complex scenarios
    ///
    /// - Parameter closure: Closure to configure the stubber
    public func willProduce(_ closure: (Stubber<ReturnType>) -> Void)
    where MockType.Given : StubbedMethod
    {
        let given = stubFactory(mock, [])
        let stubber = given.stub(for: ReturnType.self)
        closure(stubber)
        mock.given(given)
    }
}

/// Builder returned by Given() for chaining stubbing behavior on throwing methods
public struct ThrowingGivenBuilder<MockType: Mock, ReturnType> {
    private let mock: MockType
    private let stubFactory: (MockType, [StubProduct]) -> MockType.Given

    public init(
        mock: MockType,
        stubFactory: @escaping (MockType, [StubProduct]) -> MockType.Given
    ) {
        self.mock = mock
        self.stubFactory = stubFactory
    }

    /// Stub method to return specific values in sequence
    ///
    /// - Parameter values: Values to return on successive calls
    public func willReturn(_ values: ReturnType...) {
        let products = values.map { StubProduct.return($0 as Any) }
        let given = stubFactory(mock, products)
        mock.given(given)
    }

    /// Stub method to throw specific errors in sequence
    ///
    /// - Parameter errors: Errors to throw on successive calls
    public func willThrow(_ errors: Error...) {
        let products = errors.map { StubProduct.throw($0) }
        let given = stubFactory(mock, products)
        mock.given(given)
    }

    /// Stub method using StubberThrows for complex scenarios with both returns and throws
    ///
    /// - Parameter closure: Closure to configure the stubber
    public func willProduce(_ closure: (StubberThrows<ReturnType>) -> Void)
    where MockType.Given: StubbedMethod
    {
        let given = stubFactory(mock, [])
        let stubber = given.stubThrows(for: ReturnType.self)
        closure(stubber)
        mock.given(given)
    }
}

/// Extension to disable willReturn() for void throwing methods
extension ThrowingGivenBuilder where ReturnType == Void {
    /// Unavailable for void methods - use willThrow() instead
    @available(*, unavailable, message: "Cannot call willReturn() on void methods. Use willThrow() instead.")
    @discardableResult
    public func willReturn(_ values: ReturnType...) -> Self {
        fatalError("willReturn() is not available for void methods")
    }
}

// MARK: - Perform Builders

/// Builder returned by Perform() for chaining side effects on void methods
public struct PerformBuilder<MockType: Mock, ReturnType> {
    private let mock: MockType
    private let performFactory: (MockType, Any) -> MockType.Perform

    public init(
        mock: MockType,
        returning _: ReturnType.Type,
        performFactory: @escaping (MockType, Any) -> MockType.Perform
    ) {
        self.mock = mock
        self.performFactory = performFactory
    }

    /// Register a closure to execute when method is called
    ///
    /// - Parameter closure: Closure to execute
    public func will(_ closure: @escaping () -> Void) {
        let perform = performFactory(mock, closure)
        mock.perform(perform)
    }
}

/// Builder returned by Perform() for chaining side effects on methods with parameters
public struct ParameterizedPerformBuilder<MockType: Mock, ClosureType, ReturnType> {
    private let mock: MockType
    private let performFactory: (MockType, ClosureType) -> MockType.Perform

    public init(
        mock: MockType,
        returning _: ReturnType.Type,
        performFactory: @escaping (MockType, ClosureType) -> MockType.Perform
    ) {
        self.mock = mock
        self.performFactory = performFactory
    }

    /// Register a closure to execute when method is called
    ///
    /// - Parameter closure: Closure to execute with method parameters
    public func will(_ closure: ClosureType) {
        let perform = performFactory(mock, closure)
        mock.perform(perform)
    }
}

// MARK: - Verify Builder

/// Builder returned by Verify() for chaining verification assertions
public struct VerifyBuilder<MockType: Mock, ReturnType> {
    private let mock: MockType
    private let method: MockType.Verify

    public init(
        mock: MockType,
        method: MockType.Verify,
        returning _: ReturnType.Type,
        count: Count,
        file: StaticString,
        line: UInt
    ) {
        self.mock = mock
        self.method = method

        mock.verify(method, count: count, file: file, line: line)
    }
}
