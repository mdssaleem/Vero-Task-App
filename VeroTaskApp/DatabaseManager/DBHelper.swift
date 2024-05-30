//
//  DBHelper.swift
//  VeroTaskApp
//
//  Created by MOHD SALEEM on 29/05/24.
//

import Foundation
import SQLite3
import Alamofire



class DBHelper
{
    init()
    {
        db = openDatabase()
        createTable()
    }

    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS person(Id INTEGER PRIMARY KEY,name TEXT,overview TEXT,image TEXT,task TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("person table created.")
            } else {
                print("person table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func insert(id:Int, name:String, overview:String, image:String, task:String)
    {
        let insertStatementString = "INSERT INTO person (Id, name, overview, image, task) VALUES (?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            //sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_text(insertStatement, 2, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (overview as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (image as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (task as NSString).utf8String, -1, nil)

            if sqlite3_step(insertStatement) == SQLITE_DONE {
                //print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
   
    
    func read() -> [VeroModelClassOffline] {
        let queryStatementString = "SELECT * FROM person;"
        var queryStatement: OpaquePointer? = nil
        var psns : [VeroModelClassOffline] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let description = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let img = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let task = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                psns.append(VeroModelClassOffline(name: name, image: img, description: description, id: Int(id), task: task))
                //print("Query Result:")
                //print("\(id) | \(name) | \(description)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    func deleteAllTasks() {
        let deleteStatementString = "DELETE FROM person;"
        var deleteStatement: OpaquePointer?

        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                //print("Successfully deleted all rows.")
            } else {
                print("Could not delete rows.")
            }
        } else {
            print("DELETE statement could not be prepared.")
        }
        sqlite3_finalize(deleteStatement)
    }
   
}
