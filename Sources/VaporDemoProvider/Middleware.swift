//
//  DebugMiddleware.swift
//  vapor
//
//  Created by MATTHEW CLARKSON on 27/9/16.
//
//

import HTTP

public final class Middleware: HTTP.Middleware {

    public init() {}

    public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        let response = try next.respond(to: request)

        response.headers["DemoProvider"] = "Installed"

        return response
    }

}
