//
//  TasksView.swift
//  MagicToDo
//
//  Created by Hung-Chun Tsai on 2021-01-11.
//

import SwiftUI

struct TasksView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @State var newTaskTitle = ""
    
    @FetchRequest(entity: ToDoItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ToDoItem.createdAt, ascending: false)], predicate: NSPredicate(format: "taskDone = %d", false), animation: .default)
    
    var fectchedItems: FetchedResults<ToDoItem>
    
    var sampleTasks = [
        "Task One", "Task Two", "Task Three"
    ]
    
    var rowHeight: CGFloat = 50
    
    var body: some View {
        
        NavigationView {
            
            List {
                ForEach(fectchedItems, id: \.self) { item in
                    HStack {
                        Text(item.taskTitle ?? "Empty")
                        Spacer()
                        Image(systemName: "circle")
                            .imageScale(.large)
                            .foregroundColor(.gray)
                            //onTapGesture try to modify to Button {} .buttonStyle(BorderlessButtonStyle())
                            .onTapGesture {
                                markTaskDone(locate: fectchedItems.firstIndex(of: item)!)
                                print("Task Done")
                            }
                        
                    }
                    //To-Do's (dynamic row(s))
                }
                .frame(height: rowHeight)
                
                //Row for adding a new task (static row)
                HStack {
                    TextField("Add task...", text: $newTaskTitle, onCommit: {saveTask()})
                    ZStack{
                        Button(action: {
                            saveTask()
                        }) {
                        Image(systemName: "plus")
                            .imageScale(.large)
                        }
                    }
                }
                .frame(height: rowHeight)
                
                //Row for navigating to the view containing accomplished tasks (static row)
                NavigationLink(destination: TasksDoneView()) {
                    Text("Tasks done")
                        .frame(height: rowHeight)
                }
            }
                .listStyle(GroupedListStyle())
            .navigationTitle("To-Do")
        }
    }
    
    func saveTask() {
        guard self.newTaskTitle != "" else {
            return
        }
            
        let newToDoItem = ToDoItem(context: viewContext)
        newToDoItem.taskTitle = newTaskTitle
        newToDoItem.createdAt = Date()
        newToDoItem.taskDone = false
        
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
        newTaskTitle = ""
    }
    
    func markTaskDone(locate index: Int) {
        let item = fectchedItems[index]
        item.taskDone = true
        //resace our updated ToDoItem
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
