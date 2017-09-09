//
//  GetImageList.swift
//  MilkySpoon
//
//  Created by 友金輝幸 on 2017/09/09.
//  Copyright © 2017年 MilkySpoon. All rights reserved.
//

import Foundation

class GetImagelist {
    
    let session: URLSession = URLSession.shared

    // POST METHOD
    func post(url: URL, body: NSMutableDictionary, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) throws {
        var request: URLRequest = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        session.dataTask(with: request, completionHandler: completionHandler).resume()
    }
}
