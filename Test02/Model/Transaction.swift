import Foundation
struct Transaction: Codable {
    var brand: String=""        // car brand
    var color: String=""        // car color
    var tktInc: String=""       // ticket incoming time stamp
    var tktOut: String?=""      // ticket outgoing time stamp
    var tktSer: String=""       // ticket serial tag
    var trnId: String=""        // transaction id
    var tsInc: String=""        // transaction incoming time stamp
    var tsOut: String?=""       // transaction outgoing time stamp
    var type: String=""         // car plate tag
}
