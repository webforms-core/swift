# WebForms Core for Swift

WebForms Core is a server-side UI manipulation technology created by **Elanat**.

**WebForms Core for Swift** provides the WebForms Core server-side library for Swift and the **Vapor framework**.

## How to work with WebForms Core in Swift (Vapor framework)

Add WebForms Core to your Swift project using Swift Package Manager.

In your `Package.swift` file, add WebForms Core to the `dependencies` section:

```swift
dependencies: [
    .package(
        url: "https://github.com/webforms-core/swift.git",
        from: "2.1.0"
    )
]
```

Then add `WebFormsCore` to the target dependencies:

```swift
.product(
    name: "WebFormsCore",
    package: "swift"
)
```

Import WebForms Core in your Swift file:

```swift
import Vapor
import WebFormsCore
```

You can then use the `WebForms` class in your Vapor application.

```swift
import Vapor
import WebFormsCore

struct FormData: Content {
    var txt_Name: String
    var txt_BackgroundColor: String
    var txt_FontSize: Int
}

func routes(_ app: Application) throws {
    app.post { req -> Response in
        guard let data = try? req.content.decode(FormData.self) else {
            throw Abort(.badRequest)
        }

        let name = data.txt_Name
        let backgroundColor = data.txt_BackgroundColor
        let fontSize = data.txt_FontSize

        let form = WebForms()

        form.setFontSize(InputPlace.tag("form"), fontSize)
        form.setBackgroundColor(InputPlace.tag("form"), backgroundColor)
        form.setDisabled(InputPlace.name("btn_SetBodyValue"), true)

        form.addTag(InputPlace.tag("form"), "h3")
        form.setText(InputPlace.tag("h3"), "Welcome \(name)!")

        var headers = HTTPHeaders()
        headers.contentType = HTTPMediaType(
            type: "text",
            subType: "plain",
            parameters: ["charset": "utf-8"]
        )

        return Response(
            status: .ok,
            headers: headers,
            body: .init(string: form.response())
        )
    }

    app.get { req in
        var headers = HTTPHeaders()
        headers.contentType = HTTPMediaType(
            type: "text",
            subType: "html",
            parameters: ["charset": "utf-8"]
        )

        return Response(
            status: .ok,
            headers: headers,
            body: .init(string: renderForm())
        )
    }
}

func renderForm() -> String {
    return """
    <!DOCTYPE html>
    <html>
    <head>
      <title>Using WebForms Core</title>
      <script type="module" src="/script/web-forms.js"></script>
    </head>
    <body>
        <form method="post" action="/">
            <label for="txt_Name">Your Name</label>
            <input name="txt_Name" id="txt_Name" type="text" />
            <br>
            <label for="txt_FontSize">Set Font Size</label>
            <input name="txt_FontSize" id="txt_FontSize" type="number" value="16" min="10" max="36" />
            <br>
            <label for="txt_BackgroundColor">Set Background Color</label>
            <input name="txt_BackgroundColor" id="txt_BackgroundColor" type="text" />
            <br>
            <input name="btn_SetBodyValue" type="submit" value="Click to send data" />
        </form>
    </body>
    </html>
    """
}

public func configure(_ app: Application) throws {
    try routes(app)
}

@main
struct WebFormsApp {
    static func main() async throws {
        var env = try Environment.detect()
        try LoggingSystem.bootstrap(from: &env)

        let app = try await Application.make(env)

        do {
            try configure(app)
            try await app.execute()
        } catch {
            app.logger.report(error: error)
            try? await app.asyncShutdown()
            throw error
        }

        try await app.asyncShutdown()
    }
}
```

In the example above, when the form is submitted, the server creates an instance of the `WebForms` class, executes the WebForms Core commands, and returns the WebForms Core response to the browser.

When the submit button has not been clicked and the requester makes the initial request, the complete HTML page is returned.

The WebFormsJS script is added to the HTML page and executes the WebForms Core commands returned by the server.

The latest version of WebFormsJS is available here:

https://github.com/elanatframework/Web_forms/blob/elanat_framework/web-forms.js

## Created by Elanat

WebForms Core is created and maintained by **Elanat**.

Elanat: https://elanat.net

WebForms Core: https://github.com/webforms-core

WebForms Core for Swift: https://github.com/webforms-core/swift
