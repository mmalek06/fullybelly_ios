import Foundation
import Unbox

struct TermsAndConditions {
    let versionId: Int
    let text: String
}

extension TermsAndConditions: Unboxable {
    init(unboxer: Unboxer) throws {
        self.versionId = try unboxer.unbox(key: "id")
        self.text = try unboxer.unbox(key: "text")
    }
}
