import UIKit

final class DeeplinkRemindDetailBuilder {
    
    private let deeplinkBaseURL = "healthReminder://"
    
    private lazy var jsonEncoder: JSONEncoder = {
        JSONEncoder()
    }()
    
    func buildRemindDetailDeeplink(for remind: Remind) -> URL? {
        guard
            let data = try? jsonEncoder.encode(remind),
            let jsonString = String(data: data, encoding: .utf8)
        else { return nil }
        
        guard
            let queryParams = convertJsonStringIntoQueryParams(jsonString: jsonString)
        else { return nil }
        
        return URL(string: deeplinkBaseURL + "remind?" + queryParams)
    }
}

private extension DeeplinkRemindDetailBuilder {
    
    func convertJsonStringIntoQueryParams(jsonString: String) -> String? {
        guard
            let jsonData = jsonString.data(using: .utf8)
        else { return nil }
        
        guard
            let jsonDictionary = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any]
        else { return nil }
        
        var urlComponents = URLComponents()
        var queryItems = [URLQueryItem]()
        
        jsonDictionary.forEach {
            queryItems.append(URLQueryItem(name: $0, value: "\($1)"))
        }
        
        urlComponents.queryItems = queryItems
        return urlComponents.percentEncodedQuery
    }
}
