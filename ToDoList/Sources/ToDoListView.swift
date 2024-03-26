import SwiftUI

struct ToDoListView: View {
    
    @StateObject var viewModel: ToDoListViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                // Filter selector
                // TODO: - Add a filter selector which will call the viewModel for updating the displayed data
                FilteringItemsPickerView(viewModel: viewModel)
                
                // List of tasks
                TasksListView(viewModel: viewModel)
                
                // Sticky bottom view for adding todos
                TodoAddingView(viewModel: viewModel)
            }
            .navigationBarTitle("To-Do List")
            .navigationBarItems(trailing: EditButton())
        }
    }
}

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView(
            viewModel: ToDoListViewModel(
                repository: ToDoListRepository()
            )
        )
    }
}

struct TasksListView: View {
    
    @StateObject var viewModel: ToDoListViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.toDoFilteredItems) { item in
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            viewModel.toggleTodoItemCompletion(item)
                        }
                    }) {
                        Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(item.isDone ? .green : .primary)
                    }
                    Text(item.title)
                        .font(item.isDone ? .subheadline : .body)
                        .strikethrough(item.isDone)
                        .foregroundColor(item.isDone ? .gray : .primary)
                }
            }
            .onDelete { indices in
                indices.forEach { index in
                    let item = viewModel.toDoFilteredItems[index]
                    viewModel.removeTodoItem(item)
                }
            }
        }
    }
}

struct TodoAddingView: View {
    
    @State private var newTodoTitle = ""
    @State private var isShowingAlert = false
    
    @State private var isAddingTodo = false
    
    @StateObject var viewModel: ToDoListViewModel
    
    var body: some View {
        if isAddingTodo {
            HStack {
                TextField("Enter Task Title", text: $newTodoTitle)
                    .padding(.leading)
                Spacer()
                Button(action: {
                    if newTodoTitle.isEmpty {
                        isShowingAlert = true
                    } else {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            viewModel.add(
                                item: .init(
                                    title: newTodoTitle
                                )
                            )
                            newTodoTitle = "" // Reset newTodoTitle to empty.
                            isAddingTodo = false // Close the bottom view after adding
                        }
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.horizontal)
            
        }
        Button(action: {
                isAddingTodo.toggle()
        }) {
            Text(isAddingTodo ? "Close" : "Add Task")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                .shadow(radius: 5)
        }
        .padding()
    }
}

struct FilteringItemsPickerView: View {
    
    @StateObject var viewModel: ToDoListViewModel
    
    var body: some View {
        // added picker to choose filter type
        Picker("", selection: $viewModel.filterStatus) {
            ForEach(FilterStatus.allCases, id: \.self) { status in
                Text(status.rawValue.capitalized).tag(status)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        .onChange(of: viewModel.filterStatus) {
            viewModel.applyFilter(for: $0)
        }
    }
}
