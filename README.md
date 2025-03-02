# Alkilate  
**Peer-to-Peer Rental Marketplace**

![alkilate](https://github.com/user-attachments/assets/b0ce2869-1855-4950-a4c1-ed8816ff5e17)

Alkilate is a modern mobile application that connects people who want to rent out their items with those who need them temporarily. Built with Flutter and Firebase, this platform enables users to list products, manage availability with a calendar system, and process rental orders seamlessly.

---

## Features  
- **User Authentication**: Secure sign-up and login functionality  
- **Product Listings**: Browse, search, and filter available rental items  
- **Calendar Integration**: Dynamic availability calendar for rental products  
- **Location Services**: Map integration to show pickup locations  
- **Order Management**: Complete rental order processing system  
- **Admin Dashboard**: Moderation tools for approving/rejecting listings  
- **Responsive Design**: Works on Android  

---

## Technologies Used  
- **Frontend**: Flutter/Dart  
- **Backend**: Firebase (Firestore, Authentication)  
- **Maps**: Google Maps API  
- **Payment Processing**: Third-party payment integration  
- **State Management**: Provider pattern  

---

## Installation  

### Prerequisites  
- Flutter SDK (latest version)  
- Android Studio / VS Code  
- Firebase account  

### Steps  
1. Clone the repository:  
   ```bash
   git clone https://github.com/yourusername/alkilate.git
   cd alkilate
   ```

2. Install dependencies:  
   ```bash
   flutter pub get
   ```

3. Configure Firebase:  
   - Create a new Firebase project  
   - Add Android API keys to your project  
   - Download and add configuration files:  
     - `google-services.json` (Android)  

4. Run the app:  
   ```bash
   flutter run
   ```

---

## Usage  

### For Renters  
1. Register/Login to your account  
2. Browse available rental items  
3. Check item availability via the calendar  
4. Select dates and create an order  
5. Complete checkout via mercadopago
6. Collect and return items as scheduled  

### For Owners  
1. Register/Login to your account  
2. List items with photos and descriptions  
3. Set availability dates and pricing  
4. Manage rental requests and track income  

---

## Project Structure  
```plaintext
lib/
├── main.dart          # Entry point
├── views/             # UI screens and widgets
├── models/            # Data models
├── services/          # Backend services
└── shared/            # Shared components
```

---

**🚀 Start sharing and renting today!**  
```
