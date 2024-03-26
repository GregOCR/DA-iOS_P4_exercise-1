import SwiftUI

final class ToDoListViewModel: ObservableObject {
    // MARK: - Private properties
    
    private let repository: ToDoListRepositoryType
    
    @Published var filterStatus: FilterStatus = .toDo // define the first filtered items list to view
    
    // MARK: - Init
    
    init(repository: ToDoListRepositoryType) {
        self.repository = repository
        self.toDoItems = repository.loadToDoItems()
    }
    
    // MARK: - Outputs
    
    /// Publisher for the list of to-do items.
    @Published var toDoItems: [ToDoItem] = [] {
        didSet {
            repository.saveToDoItems(toDoItems)
            applyFilter(for: filterStatus) // updating the filtered list or items after updating items
        }
    }
    
    @Published var toDoFilteredItems: [ToDoItem] = [] // filtered items only
    
    // MARK: - Inputs
    
    // Add a new to-do item with priority and category
    func add(item: ToDoItem) {
        toDoItems.append(item)
    }
    
    /// Toggles the completion status of a to-do item.
    func toggleTodoItemCompletion(_ item: ToDoItem) {
        if let index = toDoItems.firstIndex(where: { $0.id == item.id }) {
            toDoItems[index].isDone.toggle()
        }
    }
    
    /// Removes a to-do item from the list.
    func removeTodoItem(_ item: ToDoItem) {
        toDoItems.removeAll { toDoItem in
            toDoItem.id == item.id }
    }
    
    /// Apply the filter to update the list.
    func applyFilter(for filter : FilterStatus) { // filtering logic implementation switching on FilterStatus cases
        // TODO: - Implement the logic for filtering
        
        self.filterStatus = filter
        
        switch filter {
        case .all:
            toDoFilteredItems = toDoItems
        case .toDo:
            toDoFilteredItems = toDoItems.filter { !$0.isDone }
        case .done:
            toDoFilteredItems = toDoItems.filter { $0.isDone }
        }
    }
}
