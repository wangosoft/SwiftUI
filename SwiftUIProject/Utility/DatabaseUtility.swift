//
//  DataBaseUtility.swift
//  SwiftUIProject
//
//  Created by Onur GÜLER on 17.12.2021.
//

import Foundation
import CoreData

final class DatabaseUtility {
    static let shared = DatabaseUtility()
        
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()

    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: Storage.database, withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        
        return managedObjectModel
    }()

    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)

        let fileManager = FileManager.default
        let storeName = "\(Storage.database).sqlite"

        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)

        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: nil)
        } catch {
            fatalError("Unable to Load Persistent Store")
        }
        
        return persistentStoreCoordinator
    }()

    private func saveContext() {
        do {
            try managedObjectContext.save()
        }
        catch {
            print("error storing context")
        }
    }
    
    private func fetch(entity: DatabaseEntityTypes, predicate: NSPredicate? = nil) -> [Any]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.rawValue)
        do {
            let objects = try managedObjectContext.fetch(fetchRequest)
            return objects
        }
        catch let error {
            print("error fetch context \(error.localizedDescription)")
            return nil
        }
    }
    
    func storeObjects(entity: DatabaseEntityTypes, fruits: [FruitModel]) {
        deleteAllObjects(entity: entity) {
            switch entity {
            case .fruits:
                for i in 0..<fruits.count {
                    let fruit = Fruits.init(context: self.managedObjectContext)
                    fruit.id = fruits[i].id
                    fruit.name = fruits[i].name
                    fruit.image = fruits[i].image
                    fruit.fruit_description = fruits[i].description
                    fruit.price = Int32(fruits[i].price)
                }
            }

            self.saveContext()
        }
    }
    
    private func deleteAllObjects(entity: DatabaseEntityTypes, completion: @escaping () -> Void) {
        if let objects = fetch(entity: entity) {
            for object in objects {
                if let objectData = object as? NSManagedObject {
                    managedObjectContext.delete(objectData)
                }
            }
        }
    }
    
    func fetchObjects<T>(entity: DatabaseEntityTypes) -> T? {
        if let objects = fetch(entity: entity) {
            switch entity {
            case .fruits:
                var fruitsList: [FruitModel] = []
                for object in objects {
                    if let fruit = object as? Fruits {
                        if let id = fruit.id, let name = fruit.name, let image = fruit.image {
                            fruitsList.append(FruitModel.init(id: id, name: name, price: Int(fruit.price), image: image, description: fruit.fruit_description))
                        }
                    }
                }
                return fruitsList as? T
            }
        }
        return nil
    }
    
    func update<T>(entity: DatabaseEntityTypes, withObject: T) {
        switch entity {
        case .fruits:
            if let fruit = withObject as? FruitModel, let objects = fetch(entity: entity, predicate: NSPredicate(format: Storage.Predicate.equalId, argumentArray: [fruit.id])) {
                if objects.count > .zero, let firstObject = objects.first as? NSManagedObject {
                    firstObject.setValue(fruit.description, forKey: "fruit_description")
                }
            }
        }
        saveContext()
    }
        
    func fetchObjectsWithId<T>(entity: DatabaseEntityTypes, id: String) -> T? {
        if let objects = fetch(entity: entity, predicate: NSPredicate(format: Storage.Predicate.equalId, argumentArray: [id])) {
            switch entity {
            case .fruits:
                if objects.count > .zero, let fruit = objects.first as? Fruits {
                    if let id = fruit.id, let name = fruit.name, let image = fruit.image {
                        return FruitModel.init(id: id, name: name, price: Int(fruit.price), image: image, description: fruit.fruit_description) as? T
                    }
                }
            }
        }
        return nil
    }
    
}
