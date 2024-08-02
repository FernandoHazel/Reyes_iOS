import Foundation
import SwiftUI

struct Game: Hashable, Codable, Identifiable {
    var id: Int
    var date: String
    var team: String
    var hour: String
    var location: String
    var reyesRecord: String
    var teamRecord: String
    var teamImageName: String
    
    // Detail view
    var qrt_1_reyes: Int
    var qrt_1_team: Int
    
    var qrt_2_reyes: Int
    var qrt_2_team: Int
    
    var qrt_3_reyes: Int
    var qrt_3_team: Int
    
    var qrt_4_reyes: Int
    var qrt_4_team: Int
    
    var resumeVideoLink: String
    var gameVideoLink: String
    var interviewVideoLink: String
}
