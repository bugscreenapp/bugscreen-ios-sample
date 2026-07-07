import Foundation

/// The signed-in user. In a real app this comes from your auth/session layer; here it's static.
/// Its fields are the "who and what" context attached to every bug report (integration #3).
struct UserProfile: Hashable {
    let userId: String
    let displayName: String
    let email: String
    let plan: String
    let homeCity: String
    let memberSince: String
    let tripsPlanned: Int
    let countriesVisited: Int
}
