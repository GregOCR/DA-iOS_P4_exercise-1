import SwiftUI

final class ToDoListViewModel: ObservableObject {
    // MARK: - Private properties

    private let repository: ToDoListRepositoryType
    
    private var index = 1                                           // added

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
            applyFilter(at: index)                                           // added
        }
    }
    
    @Published var toDoFilteredItems: [ToDoItem] = []                                           // added

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
    func applyFilter(at index: Int) {                                              // modified
        // TODO: - Implement the logic for filtering
        
        self.index = index
                
        switch index {
        case 1:
            toDoFilteredItems = toDoItems.filter { !$0.isDone }
        case 2:
            toDoFilteredItems = toDoItems.filter { $0.isDone }
        default:
            toDoFilteredItems = toDoItems
        }
    }
}
