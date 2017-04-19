//
//  Article.swift
//  FirebaseTask
//
//  Created by 劉仲軒 on 2017/3/14.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import Foundation

class Article {
    static let title = "Sed faucibus mattis turpis, sit amet hendrerit velit eleifend pharetra."
    static let article = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque bibendum, mauris non dictum luctus, mauris sapien aliquet purus, ac hendrerit enim magna sit amet sem. Aenean porta, dolor quis lobortis varius, mi libero ullamcorper massa, a accumsan tortor metus ut arcu. Suspendisse a augue leo. Nulla varius, nisi sit amet euismod finibus, magna augue porta eros, ornare iaculis leo neque ut lorem. In semper sem quis molestie pretium. Donec pharetra, lectus ultricies tincidunt tempor, nibh lectus pretium diam, ut iaculis justo sem nec nunc. Fusce vitae lacinia est, molestie pulvinar tortor. Etiam eget feugiat felis, eu sodales tellus. Donec vel egestas mauris. Suspendisse et magna quis nisi fringilla pharetra. Morbi at orci porttitor, bibendum arcu a, lacinia turpis. Maecenas interdum ex odio, eget placerat diam hendrerit sit amet. Nam velit orci, hendrerit at fringilla vel, tincidunt commodo velit. Cras et orci ultricies, volutpat sapien id, elementum felis."
    static let date = "2017 / 03 / 14"

    let title: String!
    let article: String!
    let date: Int!
    let author: String!
    var likes: Int!
    let uid: String!
    let key: String!
    
    init(title: String, article: String, date: Int, author: String, likes: Int, uid: String, key: String) {
        self.title = title
        self.article = article
        self.date = date
        self.author = author
        self.likes = likes
        self.uid = uid
        self.key = key
    }
    
}
