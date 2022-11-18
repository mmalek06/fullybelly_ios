import Foundation

extension String {
    func localized(uppercase: Bool = false) -> String {
        var localizedString = NSLocalizedString(self, comment: "")
        if uppercase {
            localizedString = localizedString.uppercased()
        }
        return localizedString
    }
}
