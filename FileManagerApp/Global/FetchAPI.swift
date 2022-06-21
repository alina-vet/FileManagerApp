//
//  FetchAPI.swift
//  FileManagerApp
//
//  Created by Алина Бондарчук on 12.06.2022.
//

import Foundation
import Alamofire

class FetchAPI {
    
    static let sharedApi = FetchAPI()
    
    func fetchAPI(completion: @escaping([File]?, Error?) -> Void) {
        
        guard let url = Constants.keyURL else { return }
        
        AF.request(url, method: .get)
            .responseDecodable(of: SpreadSheetValues.self) { response in
                switch response.result {
                case .success(let value):
                    completion(value.parseFiles(), nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
}
