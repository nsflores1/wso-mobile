# ViewModels
## Introduction
ViewModels serve an important architectural role in this app, just like in every other SwiftUI app every written (or really any app in general). The role of a ViewModel is simple: they pass state from the parsers / services / managers to the Views in order to render the content.

There's a loose interface that you should implement, although some edge cases won't work or need every interface, which is why I'm choosing to describe it here rather than define a strict formal interface. Your own best judgement about what any given interface needs is your best guide.

Not all Views need a ViewModel! A new View does not have to come with a dedicated ViewModel (reusing an existing one is often BENEFICIAL because they come with caching built-in)! If your View shows purely static data or doesn't implement a part of the WSO API not seen elsewhere, shocker: you don't need a new ViewModel!

## Interface
The interface is loosely defined as follows:
### @MainActor and @Observable
All of these need to run on the main thread unless you have a REALLY good reason not to and can live with potential data races. Don't question it; simply trust that it's almost always a bad idea. If you really need to run something in another thread, you have better mechanisms for that.

Oh, and they should be Observable, OBVIOUSLY. You want your views to automatically update with the right data, yes? Adding that annotation means the compiler literally writes the code for that for you. So don't forget that, since Swift won't warn you about it being missing.

### Core Variables
Each ViewModel must have at least the following `public` variables:
```swift
var data: (some type)? = nil
var isLoading: Bool = false
var error: WebRequestError?
private var hasFetched = false
```
You don't need data to be strictly optional, but it should always represent an empty state of some kind. 

### func fetchIfNeeded() async
This doesn't require you to get creative. Copy and paste this:
```swift
func fetchIfNeeded() async {
    guard !hasFetched else { return }
    hasFetched = true
    await loadStuff() // your data fetcher(s)
}
```

### func forceRefresh() async
Again, just mindlessly copy and paste, changing the names out: 
```swift
func forceRefresh() async {
    isLoading = true

    do {
        let data: (some type)? = try await loadStuff()
        self.data = data
        self.error = nil

        try await cache.save(data, to: "viewmodelstate_stuff.json")
    } catch let err as WebRequestError {
        self.error = err
        self.data = []
    } catch {
        self.error = WebRequestError.internalFailure
        self.data = []
    }

    isLoading = false
}
```
You should of course change out the types. Throwing as `WebRequestError` is important actually as it will give you helpful error messages to present on your View.

### func clearCache() async
Again, copy and paste, changing literally one word:
```swift
func clearCache() async {
    await cache.clear(path: "viewmodelstate_stuff.json")
    self.diningMenu = []
}
```
## Conclusion
Writing a ViewModel sounds scary, but the cache manager and this setup abstracts most of it away for you. Just focus on getting the data right in your parser. Note that the core idea of ViewModels is that they DON'T implement core data parsing stuff; that should go into another function elsewhere in the non-GUI part of the app (so that Swift's compiler can intelligently split it up across threads). 

Also, for the love of all that is holy, please don't add logging into these unless you know what you're doing. ViewModels are glue to handle data state, not your place to debug the underlying code. If you need to add logs to your ViewModel, it's too complex, and you could move whatever the hell it's doing into another file somewhere else. Doing so is a quick way to frustrate whoever's reading your code later on.
