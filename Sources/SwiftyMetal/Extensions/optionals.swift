import Foundation

public enum OptionalErrors: Error {
	case empty(file: String = #file,line: Int = #line)
}

extension OptionalErrors: LocalizedError {
	public var errorDescription: String? {
		switch self {
		case let .empty(file,line):
			return "optional value is nill in \(file) at line \(line)"
		}
	}
}

public extension Optional {
    func unWrapped(file: String = #file,line: Int = #line)throws->Wrapped {
        switch self {
        case .none:
			throw OptionalErrors.empty(file: file,line: line)
        case .some(let value):
            return value
        }
    }
}
