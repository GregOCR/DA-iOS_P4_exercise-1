//
//  ToDoStatus.swift
//  ToDoList
//
//  Created by Greg on 25/03/2024.
//

enum FilterStatus: String, CaseIterable, Identifiable { // added enum for filtering mode
    
    case all, toDo, done
    
    var id: Self { self }
}
