# Example Vapor Provider

Great web frameworks make it simple to develop third party plugins that can be
easily added to any project.

The [Vapor](http://vapor.codes) Swift web framework is no exception and allows
developers to create and share plugins called `Providers`

This example demonstrates how to create a `Vapor Provider` with functionality
that would be required by real Providers, such as Admin backends, Debug toolbars
and Job Queue management, including:

- Default configuration with optional overrides using `json`
- Example Route that returns a view using the [Leaf](https://github.com/vapor/leaf)
Swift templating language.
- Example Middleware.

The purpose of this repo is simply is to provide some guidance on how to build
Providers that extend Vapor's core functionality.

# Adding the Example Provider

To add this example provider to a Vapor project include it as a dependency in
your `Packages.swift` file.

```swift
let package = Package(
    name: "MyApp",
    dependencies: [
   	    .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1),
        .Package(url: "https://github.com/mpclarkson/vapor-demo-provider.git", majorVersion: 1),
    ]
)
```

Then enable the provider in `main.swift`:

```swift
import Vapor
import VaporDemoProvider

let drop = Droplet(providers: [
     VaporDemoProvider.Provider.self
  ]
)

drop.run()
```

Then run `vapor build && vapor run` and visit `http://127.0.0.1:8080/_demo` to
see the providers welcome page.

## Configuration Example

This provider includes a basic view that is available at `/_demo`.

This route can be overridden by simply adding a `demo_provider.json` file in the
`Config` folder of a Vapor project, which contains a `path` key, as follows:

```json
{
  "path": "/mypath",
}
```

Then run `vapor build && vapor run` and visit `http://127.0.0.1:8080/mypath` to
see the HTML page.

## Middleware Example

This demo provider also includes middleware that simply adds a header
`DemoProvider: Installed` to all responses.

Currently it does not seem possible for a provider to enable middleware automatically - you must
do this manually.

```swift
//Other config

let drop = Droplet(
  availableMiddleware: [
    "demoprovider" : VaporDemoProvider.Middleware()
  ],
  providers: [
    VaporDemoProvider.Provider.self
  ]
)

drop.run()
```

Then enable the middleware in your `Config/middleware.json` file:

```json
{
    "server": [
        ...
        "demoprovider"
    ],
    ...
}
```

Then run `vapor build && vapor run`.

## Thoughts

While building this demo, a few things came to mind that could help make it easier
for the community to build Providers.

- The Vapor toolkit could be extended to allow the creation of skeletons, for example
 `vapor generate provider`
- Currently middleware can only be initialized in the `Droplet` and is a `let`
constant. This means that third party middleware cannot be added when the providers
are initialized. It would be nice to be able to do something like
`drop.middleware.append(["demoprovider" : DemoProvider.Middleware()])`
- Many third party packages in popular frameworks include routes and views. I may
have missed something, but the only way I can see how a Provider can (easily)
return views is to copy the Provider views into the `drop.resourcesDir`. Perhaps
Providers could have a default resource dir of their own, which could be overridden
on `init` to allow custom templates to be used in there place?

## Next Steps

Creating a Vapor Provider is pretty straightforward and the core team deserves
kudos for making this so simple at this early stage in the framework's development.

Now, let's build a vibrant Vapor community by crafting some truly useful Providers.

Get Forking!
