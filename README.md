**To-Do App**
This is a To-Do application built using Flutter that allows users to manage their tasks effectively. The app includes several features such as authentication, task management, QR scanning, and camera integration. Below are the key features and functionalities.

Features
1. Authentication with Phone Number and Password
Users can register and log in using their phone number and password for secure access to their tasks.
2. Phone Number Validation Based on Country
The app ensures proper phone number validation based on the selected country, enhancing security and user experience.
3. Authorization with JWT Token
The app uses JWT (JSON Web Tokens) for authentication.
It handles token refresh, including:
HTTP Code 401: Not authorized, needs refresh.
HTTP Code 403: Refresh failed.
HTTP Code 200: Refresh successfully.
4. To-Do List Management
The to-do list includes the following states:
Loading State: Displays a loading indicator while fetching tasks.
Empty State: Displays a message when there are no tasks available.
Error State: Displays an error message if there's an issue fetching tasks.
Refresher: Allows users to refresh the list by pulling down.
Infinite Scroll: Loads more tasks as the user scrolls to the bottom.
5. Responsive Design
The app is designed to be responsive, ensuring that it looks and works well on various screen sizes and orientations.
6. QR Generation
A unique QR code is generated for each task on the details page, based on the Todo ID. This QR code can be scanned to open the task directly.
7. Camera Plugin Integration
Users can add images to tasks by capturing photos directly from the camera or selecting images from their device's gallery.
8. QR Scanner for Task Details
The app includes a QR scanner that allows users to scan a QR code to open the corresponding task details. It performs a GET request to /todos/:id to fetch the task details based on the scanned ID.
