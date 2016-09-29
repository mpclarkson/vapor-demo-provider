//
//  DebugProvider.swift
//  vapor
//
//  Created by MATTHEW CLARKSON on 27/9/16.
//
//

import Vapor
import HTTP
import Foundation

public final class Provider: Vapor.Provider {

    public let provided: Providable

    private let path: String

    public enum Error: Swift.Error {
        case config(String)
    }

    /**
        Creates a Demo provider from an optional `demo_provider.json`
        config file that overrides the default configuration.

        The file should contain JSON as follows:

            {
                "path": "my_custom_path",
            }
    */
    public convenience init(config: Config) throws {
        let config = config["demo_provider"]?.object

        if config == nil {
            try self.init(path: "_demo") //Default path
        }
        else {
            guard let path = config?["path"]?.string else {
                throw Error.config("No 'path' string key in demo_provider.json")
            }

            try self.init(path: path)
        }
    }

    /**
           Sets the path and flags the provider as having been initialized.
           - parameter path: The base path
       */
    public init(path: String) throws {
        self.path = path
        self.provided = Providable()
    }

    /**
           Called after the Droplet has completed
           initialization. Copies Provider views to the
           DemoProvider namespace in the `drop.resourcesDir`
           and loads the Provider route.
    */
    public func afterInit(_ drop: Droplet) {

        let currentDir = #file.components(separatedBy: "/").dropLast().joined(separator: "/")
        let viewDir = URL(fileURLWithPath: currentDir + "/../../Resources/Views")
        let destinationDir = URL(fileURLWithPath: drop.resourcesDir + "Views/DemoProvider")

        let fileManager = FileManager.default

        try? fileManager.removeItem(at: destinationDir)

        do {
          try fileManager.copyItem(at: viewDir, to: destinationDir)
        }
        catch {
            drop.log.error("VaporDemoProvider was not initialized properly - \(error.localizedDescription)")
            return
        }

        drop.get("\(path)") { req in
            return try drop.view.make("DemoProvider/index.leaf")
        }
    }

    /**
           Called before the Droplet begins serving
           which is @noreturn.
    */
    public func beforeRun(_ drop: Droplet) {

    }
}
