# Step Into Vision Example Code

This repo is my workspace for Example Code for [Step Into Vision]([url](https://stepinto.vision)).

-  All labs are posted as articles on the site: [https://stepinto.vision/category/labs/](https://stepinto.vision/category/example-code/)
-  To see the code for a given example, look in `Step Into Examples/Examples`
-  Some examples require full Xcode project. Those are in another repo: https://github.com/radicalappdev/Step-Into-Example-Projects

I'm not currently accepting pull requests. If you would like to suggest an example, please contact me. Links are in ny GitHub profile.

Support my work

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/C0C51CD3LH)

## Auto-generating the Example list

The huge switch and `ModelData` array are now generated from the example files themselves.

Each example already has a short metadata header the generator reads:

```swift
//  Title: Example150
//  Subtitle: Something cool
//  Description: A short description
//  Type: Volume   // Window | Window Alt | Volume | Space | Space Full
//  Featured: false
//  Success: true
```

Regenerate the registry (`App/Generated/ExampleRegistry.swift`) any time you add or change examples:

```bash
xcrun swift Tools/generate_examples.swift
```

If you want Xcode to do this automatically, add a “Run Script” build phase before “Compile Sources” with:

```bash
xcrun swift "$SRCROOT/Tools/generate_examples.swift"
```
