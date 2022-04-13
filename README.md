# Firestore App

Simple product management app, with Auth module made with Firebase Auth and Firebase Firestore ODM. You can login or signup with email or google account, create or update products even if you are offline, storing them in local storage with Firestore offline persistence the product's images are stored in Cloudinary so you must create and account for use the app, lastly the app have Firebase Push Notifications available so it can receive and react them.

Includes:

* Auth service with Firebase Auth, signin and signup with persistent session and unique email validation.
* Products service with Firebase Firestore, retrieve, create and update products with a unique index validation for avoid product's name duplicity.
* Firestore ODM, create typed reference of Firebase collections then you can make CRUD operations to Firestore with dart Objects, another advantage is the possibility to create query's to filter data by properties.
* FirestoreBuilder Widget work as StreamBuilder for Firebase ODM references changes.
* Cloudinary service for store images.
* Offline support with Firestore offline persistence, when you are connected again the products will upload to Firestore automatically.
* Connectivity listener with beauty popup over any screen.
* Google Sign in
* Firebase Push Notifications and Local Notifications

Demo: 

<table>
<thead>
	<tr>
		<th>Demo 1</th>
		<th>Demo 2</th>
		<th>Demo 3</th>
	</tr>
</thead>
<tbody>
	<tr>
		<td><img src="https://res.cloudinary.com/dwzr9lray/image/upload/v1649875722/flutter_repos/Firestore%20App/firestore_app_1.gif"></td>
		<td><img src="https://res.cloudinary.com/dwzr9lray/image/upload/v1649875722/flutter_repos/Firestore%20App/firestore_app_2.gif"></td>
		<td><img src="https://res.cloudinary.com/dwzr9lray/image/upload/v1649875722/flutter_repos/Firestore%20App/firestore_app_3.gif"></td>
	</tr>
</tbody>
</table>
<table>
<thead>
	<tr>
		<th>Demo 4</th>
		<th>Demo 5</th>
		<th></th>
	</tr>
</thead>
<tbody>
	<tr>
		<td><img src="https://res.cloudinary.com/dwzr9lray/image/upload/v1649875729/flutter_repos/Firestore%20App/firestore_app_4.gif"></td>
		<td><img src="https://res.cloudinary.com/dwzr9lray/image/upload/v1649875729/flutter_repos/Firestore%20App/firestore_app_5.gif"></td>
		<td><img src="https://res.cloudinary.com/dwzr9lray/image/upload/v1649648477/flutter_repos/transparent.png"></td>
	</tr>
</tbody>
</table>
