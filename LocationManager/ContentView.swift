//
//  ContentView.swift
//  LocationManager
//
//  Created by 41nyaa on 2021/09/01.
//

import SwiftUI
import CoreData
import MapKit

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @EnvironmentObject var location: LocationService

    var body: some View {
        VStack {
            Text("Location")
            if self.location.locations.count > 0 {
                Text(String(self.location.locations.last!.coordinate.latitude))
                Text(String(self.location.locations.last!.coordinate.longitude))
            } else {
                Text("Updating...")
            }
            HStack {
                Button(action: {
                    self.location.locations = []
                    self.location.request()
                }, label: {
                    Text("Update")
                })
                Button(action: {
                    self.addItem()
                }, label: {
                    Text("Regist")
                })
            }
        }
        List {
            ForEach(items) { item in
                if item.location != nil {
                    Text(String(item.location!.coordinate.latitude) +  String(item.location!.coordinate.longitude))
                        .onTapGesture(perform: {
                            let map = MKMapItem(placemark: MKPlacemark(coordinate: item.location!.coordinate))
                            map.name = "Item"
                            map.openInMaps(launchOptions: nil)
                        })
                }
            }
            .onDelete(perform: deleteItems)
        }
        .toolbar {
            #if os(iOS)
            EditButton()
            #endif

            Button(action: addItem) {
                Label("Add Item", systemImage: "plus")
            }
        }
    }

    private func addItem() {
        guard let location = self.location.locations.last else{
            return
        }
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.location = location

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
