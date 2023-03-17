import Foundation
class TransactionModel {
    var trns: [Transaction] = []

    init() {
        getJsDt()
    }
    
    func getJsDt() {
        guard let url = URL(string: Bundle.main.object(forInfoDictionaryKey: "REST_endpoint_URL") as! String) else { return }
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        DispatchQueue.main.async {
            URLSession.shared.dataTask(with: req, completionHandler: { data,response,error in
                if let data=data {
                    do {
                        self.trns = []
                        let trj = try JSONSerialization.jsonObject(with: data,options: []) as? [Any]
                        for elm in trj! {
                            let e = elm as! [String:Any]
                            var tm = Transaction()
                            for (k,v) in e {
                                switch (k) {
                                case "brand":
                                    tm.brand=v as! String
                                case "color":
                                    tm.color=v as! String
                                case "tktInc":
                                    tm.tktInc=v as! String
                                case "tktOut":
                                    tm.tktOut=v as? String
                                case "tktSer":
                                    tm.tktSer=v as! String
                                case "trnId":
                                    tm.trnId=String(v as! Int)
                                case "tsInc":
                                    tm.tsInc=v as! String
                                case "tsOut":
                                    tm.tsOut=v as? String
                                case "type":
                                    tm.type=v as! String
                                default:
                                    break
                                }
                            }
                            self.trns.append(tm)
                        }
                    } catch {
                        print("Error in JSON Serialization")
                    }
                } else {
                    print("GET response: \(response)")
                    print("GET error: \(error)")
                }
            }).resume()
        }
    }
    
    
    func mdlFltr(_ type: Int? = nil,_ ky: String? = "") -> [Transaction] {
        guard let type=type else { return trns }
        switch(type) {
        case 0:     // full history
            return trns
        case 1:     // currently in lot
            return trns.filter { $0.tktOut!.isEmpty }
        case 2:     // for a plate ky
            return trns.filter { $0.type == ky }
        case 3:     // for brand
            return trns.filter { $0.brand == ky }
        default:
            break
        }
        return trns
    }
}
