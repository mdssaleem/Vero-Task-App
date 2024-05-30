# iOS Application for Fetching and Displaying Tasks
This iOS application connects to a remote API to download a set of resources, displays them in a list, and provides basic search and filter functionalities. Additionally, the app includes a QR code scanning feature and supports offline usage.


# Features
- Fetch Resources: The app requests resources from the following endpoint: https://api.baubuddy.de/dev/index.php/v1/tasks/select.
- Offline Storage: Resources are stored locally to allow the application to function offline.
- List Display: All items are displayed in a list showing: Task, Title, Description
- A color-coded view based on the colorCode property
- Search Functionality: A search bar allows users to search for any property of the resources, even those not directly visible in the list.
- QR Code Scanning: The app includes a menu item for scanning QR codes. Upon a successful scan, the scanned text is used as the search query.
- Pull-to-Refresh: Users can refresh the data using pull-to-refresh functionality.

- ## Requirements

- iOS 14.0+
- Xcode 12.0+
- Swift 5.3+

## Installation

1. Clone the repository:
   ```bash
   git clone [https://github.com/yourusername/Vero-Task-App.git]

## Media

<img width="364" alt="Screenshot 2024-05-30 at 3 15 53 PM" src="https://github.com/mdssaleem/Vero-Task-App/assets/32189409/6cdf674e-6562-400c-b96c-086d6d5f2945">
<img width="363" alt="Screenshot 2024-05-30 at 3 15 06 PM" src="https://github.com/mdssaleem/Vero-Task-App/assets/32189409/8526bd5e-6047-4072-aaec-cb2d18a1676a">
<img width="371" alt="Screenshot 2024-05-30 at 3 13 40 PM" src="https://github.com/mdssaleem/Vero-Task-App/assets/32189409/f900b02f-b418-49d1-a6ed-90257fc0efb2">


## QR Codes For Testing

<img width="262" alt="Plane" src="https://github.com/mdssaleem/Vero-Task-App/assets/32189409/ae03444c-657a-4620-a205-af3cab6c66a5">
<img width="268" alt="40 Material" src="https://github.com/mdssaleem/Vero-Task-App/assets/32189409/dd60e37d-9257-4ffb-9fec-2cfe2f9cc3ab">
<img width="269" alt="10 Aufbau" src="https://github.com/mdssaleem/Vero-Task-App/assets/32189409/80735ae7-753c-49c6-a69b-b7bb3831259c">


   
