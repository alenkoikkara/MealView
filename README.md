# MealView

MealView is a beautifully designed iOS application built with SwiftUI that helps users discover new recipes, explore meal categories, and find nearby restaurants. It leverages public APIs and native Apple frameworks to provide a comprehensive culinary companion app.

## Features

*   **🔍 Recipe Search:** Search for specific meals and recipes powered by [TheMealDB API](https://www.themealdb.com/).
*   **📂 Categories:** Browse a wide variety of meal categories to find exactly what you're craving.
*   **🎲 Random Meal:** Undecided? Get a random recipe suggestion with a single tap.
*   **📍 Nearby Restaurants:** Uses `MapKit` and `CoreLocation` to pinpoint your location and discover restaurants near you via `MKLocalSearch`.
*   **❤️ Favorites Manager:** Save and easily access your favorite recipes so you never lose track of a great meal.
*   **📱 Modern UI:** Uses SwiftUI for a declarative, reactive user interface with components like Tabs, NavigationLinks, and Maps.

## Technology Stack

*   **UI Framework:** SwiftUI
*   **Networking:** URLSession (Integration with TheMealDB REST API)
*   **Mapping & Location:** MapKit, CoreLocation
*   **Architecture:** MVVM (Model-View-ViewModel) approach with highly modular SwiftUI views.

## Project Structure

The project code is primarily located in the `Final_Project` directory:

*   `ContentView.swift`: Main entry point containing the `TabView` for navigating between the core features.
*   `RecipeSearchView.swift`: Handles fetching and displaying searched recipes.
*   `CategoriesView.swift` & `CategoryRecipesView.swift`: Manage the browsing of meals by their respective categories.
*   `RandomView.swift`: Fetches a random meal from the API.
*   `NearbyView.swift`: Integrates an interactive map displaying user location and surrounding restaurants.
*   `FavoritesView.swift` & `FavoritesManager.swift`: Handle the persistence and display of user-favorited meals.
*   `Models`: Includes `Recipe.swift` and `Category.swift` representing the data layer.

## Getting Started

### Prerequisites

*   Xcode 14.0 or later
*   iOS 16.0+ minimum deployment target
*   An active internet connection to fetch recipes and map data

### Installation

1.  Clone the repository:
    ```bash
    git clone https://github.com/alenkoikkara/MealView.git
    ```
2.  Open `Final_Project.xcodeproj` in Xcode.
3.  Select your target simulator or physically connected iOS device.
4.  Build and run the project (`Cmd + R`).

## Location Permissions

To use the **Nearby Restaurants** feature, the app requires location permissions:
*   The first time you access the "Nearby" tab, the app will prompt you for location access (`requestWhenInUseAuthorization`).
*   Ensure that testing on a simulator has a simulated location enabled (Features -> Location).

## Acknowledgements

*   Recipe data provided by [TheMealDB API](https://www.themealdb.com/).
*   Map and location services provided by Apple via `MapKit` and `CoreLocation`.
