
//
//  Model.swift
//  URLsession
//
//  Created by Đỗ Hoàng Vũ on 3/23/18.
//  Copyright © 2018 Đỗ Hoàng Vũ. All rights reserved.
//

import Foundation
class List { // claas này bé hơn class City nên được khai bao trước theo thứ tự : TỪ BÉ ĐẾN LỚN
    var dt : TimeInterval
    var day : Double
    var description : String
    init?(dict : Dictionary<AnyHashable,Any>) {
        
        guard let dt = dict["dt"] as? TimeInterval else {return nil}
        guard let temp = dict["temp"] as? Dictionary<AnyHashable,Any> else {return nil}
        guard let day = temp["day"] as? Double else {return nil}
        guard let weather = dict["weather"] as? [Dictionary<AnyHashable, Any>] else {return nil}
        guard  let description = weather[0]["description"] as? String else {return nil}
        
        self.dt = dt
        self.day = day
        self.description = description
        
    }
}
class City  {
    var lists : [List] = []
    var name : String
    var country : String
    init?(dict: Dictionary<AnyHashable,Any>) {
        guard let city = dict["city"] as? Dictionary<AnyHashable,Any> else {return  nil}
        guard let name = city["name"] as? String else {return nil}
        guard let country = city["country"] as? String else {return nil}
        guard let listObject = dict["list"] as? [Dictionary<AnyHashable,Any>] else {return nil}// cú pháp khai bao một array để có thể ghi dữ liệu vào array
        for item in listObject {                                                              // lọc item chạy trong biến list để duyệt
            if let list = List(dict: item) {                                           // nếu có dữ liệu của list trong mảng dictionary kia thì nó sẽ thêm
                lists.append(list)                                                     // mảng _list để nó có thể chạy vào class List
            }
        }
        self.name = name
        self.country = country
    }
}

class DataSevrice  {
    static let shared : DataSevrice = DataSevrice()     //  this is SINGLETON
    //------------------------------------------------------------------------
    func startConnection() {
        guard let url = URL(string: "https://andfun-weather.udacity.com/weather") else {return}
        let _ = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let jsonObject =  try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) else {return}
            guard let json = jsonObject as? Dictionary<AnyHashable,Any> else {return}
            if let city = City(dict: json) {
                city.lists.forEach({ list in
                    print(list.description)
                    print(list.day)
                })
            }
            
            
        }.resume()
    }
}
