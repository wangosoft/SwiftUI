//
//  DataBaseUtility.swift
//  SwiftUIProject
//
//  Created by Onur GÜLER on 17.12.2021.
//

import Foundation
import CoreData
    
final class DatabaseUtility: NSObject {
    private static let sharedInstance: DatabaseUtility = DatabaseUtility()
        
    private var persistentStoreType: String = NSSQLiteStoreType
    
    static func getSharedInstance(persistentStoreType: String = NSSQLiteStoreType) -> DatabaseUtility {
        sharedInstance.persistentStoreType = persistentStoreType
        return sharedInstance
    }
             
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

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
            try persistentStoreCoordinator.addPersistentStore(ofType: self.persistentStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: nil)
        } catch let error {
            fatalError("Unable to Load Persistent Store \(error.localizedDescription)")
        }
        
        return persistentStoreCoordinator
    }()
    
    
    
    private func saveContext() {
        managedObjectContext.perform {
            if self.managedObjectContext.hasChanges {
                do {
                    try self.managedObjectContext.save()
                }
                catch let error {
                    print("error storing context \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func fetch(entity: DatabaseEntityTypes, predicate: NSPredicate? = nil) -> [Any]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.rawValue)
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let objects = try managedObjectContext.fetch(fetchRequest)
            return objects
        }
        catch let error {
            print("error fetch context \(error.localizedDescription)")
            return nil
        }
    }
    
    func storeObjects<T>(entity: DatabaseEntityTypes, objects: T) {
        deleteAllObjects(entity: entity) { // MARK: Tamamen silmek description alanlarını kaybetmek anlamına geliyor, burada varolanları update etmek, olmayanları eklemek ve silmek daha iyi bir yaklaşım olur.
            switch entity {
            case .fruits:
                let fruits = objects as? [FruitModel] ?? []
                for i in 0..<fruits.count {
                    let fruit = Fruits(context: self.managedObjectContext)
                    fruit.id = fruits[i].id
                    fruit.name = fruits[i].name
                    fruit.imageData = fruits[i].imageData
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
        completion()
    }
        
    func fetchObjects<T>(entity: DatabaseEntityTypes) -> T? {
        if let objects = fetch(entity: entity) {
            switch entity {
            case .fruits:
                var fruitsList: [FruitModel] = []
                for object in objects {
                    if let fruit = object as? Fruits {
                        if let id = fruit.id, let name = fruit.name {
                            fruitsList.append(FruitModel.init(id: id, name: name, price: Int(fruit.price), description: fruit.fruit_description, imageData: fruit.imageData))
                        }
                    }
                }
                return fruitsList as? T
            }
        }
        return nil
    }
        
    func fetchObjectsWithId<T>(entity: DatabaseEntityTypes, id: String) -> T? {
        if let objects = fetch(entity: entity, predicate: NSPredicate(format: Storage.Predicate.equalId, id)) {
            switch entity {
            case .fruits:
                if objects.count > .zero, let fruit = objects.first as? Fruits {
                    if let id = fruit.id, let name = fruit.name {
                        return FruitModel.init(id: id, name: name, price: Int(fruit.price), description: fruit.fruit_description, imageData: fruit.imageData) as? T
                    }
                }
            }
        }
        return nil
    }
    
    func update<T, K>(entity: DatabaseEntityTypes, theObject: T, with data: K, key: String) {
        switch entity {
        case .fruits:
            if let fruit = theObject as? FruitModel {
                batchUpdate(entity: entity, predicate: NSPredicate(format: Storage.Predicate.equalId, argumentArray: [fruit.id]), key: key, data: data)
            }
        }
    }
    
    private func batchUpdate<T>(entity: DatabaseEntityTypes, predicate: NSPredicate? = nil, key: String, data: T) {
        do {
            let request = NSBatchUpdateRequest(entityName: entity.rawValue)
            request.resultType = .updatedObjectIDsResultType
            request.propertiesToUpdate = [key: data]
            request.predicate = predicate
                
            let result = try managedObjectContext.execute(request) as? NSBatchUpdateResult
            let objectIDArray = result?.result as? [NSManagedObjectID]
            let changes = [NSUpdatedObjectsKey: objectIDArray]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes as [AnyHashable : Any], into: [managedObjectContext])
        } catch let error {
            print("batch update error \(error.localizedDescription)")
        }
    }
}
