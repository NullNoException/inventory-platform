import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:inventory_app/core/errors/failures.dart';
import 'package:inventory_app/features/authentication/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// Sign in with email and password
  Future<UserModel> signIn({required String email, required String password});

  /// Create a new user account
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  });

  /// Sign out the current user
  Future<void> signOut();

  /// Get current user details
  Future<UserModel?> getCurrentUser();

  /// Send password reset email
  Future<void> resetPassword({required String email});

  /// Update user profile
  Future<UserModel> updateUserProfile({
    required String userId,
    String? name,
    String? email,
  });

  /// Change user password
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Account _account;
  final Databases _databases;
  final String _usersCollectionId;
  final String _databaseId;

  AuthRemoteDataSourceImpl({
    required Account account,
    required Databases databases,
    required String usersCollectionId,
    required String databaseId,
  }) : _account = account,
       _databases = databases,
       _usersCollectionId = usersCollectionId,
       _databaseId = databaseId;

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // Create a session with Appwrite
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      // Get account information
      final accountInfo = await _account.get();

      // Get additional user details from database
      final userData = await _getUserData(accountInfo.$id);

      return userData;
    } on AppwriteException catch (e) {
      throw AuthenticationFailure(
        message: 'Authentication failed: ${e.message}',
      );
    } catch (e) {
      throw UnexpectedFailure(message: 'Sign in failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Create user account
      final user = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );

      // Create a session for the new user
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      // Create user profile in database with default role
      final newUser = await _createUserProfile(user.$id, name, email, [
        'staff',
      ]);

      return newUser;
    } on AppwriteException catch (e) {
      throw AuthenticationFailure(message: 'Registration failed: ${e.message}');
    } catch (e) {
      throw UnexpectedFailure(message: 'Sign up failed: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      // Delete current session
      await _account.deleteSession(sessionId: 'current');
    } on AppwriteException catch (e) {
      throw AuthenticationFailure(message: 'Sign out failed: ${e.message}');
    } catch (e) {
      throw UnexpectedFailure(message: 'Sign out failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      // Check if there is an active session
      final account = await _account.get();

      // Get user data from the database
      final userData = await _getUserData(account.$id);

      return userData;
    } on AppwriteException {
      // No active session or error in fetching data
      return null;
    } catch (e) {
      throw UnexpectedFailure(
        message: 'Error getting current user: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await _account.createRecovery(
        email: email,
        url:
            'https://yourapp.com/reset-password', // Replace with your actual URL
      );
    } on AppwriteException catch (e) {
      throw AuthenticationFailure(
        message: 'Password reset failed: ${e.message}',
      );
    } catch (e) {
      throw UnexpectedFailure(
        message: 'Password reset failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<UserModel> updateUserProfile({
    required String userId,
    String? name,
    String? email,
  }) async {
    try {
      // Update account info if email is provided
      if (email != null) {
        await _account.updateEmail(email: email, password: 'current-password');
      }

      // Update name in account if provided
      if (name != null) {
        await _account.updateName(name: name);
      }

      // Update user data in database
      final updatedUser = await _databases.updateDocument(
        databaseId: _databaseId,
        collectionId: _usersCollectionId,
        documentId: userId,
        data: {
          if (name != null) 'name': name,
          if (email != null) 'email': email,
          'updatedAt': DateTime.now().toIso8601String(),
        },
      );

      return _convertDocumentToUserModel(updatedUser);
    } on AppwriteException catch (e) {
      throw AuthenticationFailure(
        message: 'Profile update failed: ${e.message}',
      );
    } catch (e) {
      throw UnexpectedFailure(
        message: 'Profile update failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await _account.updatePassword(
        password: newPassword,
        oldPassword: oldPassword,
      );
    } on AppwriteException catch (e) {
      throw AuthenticationFailure(
        message: 'Password change failed: ${e.message}',
      );
    } catch (e) {
      throw UnexpectedFailure(
        message: 'Password change failed: ${e.toString()}',
      );
    }
  }

  // Helper method to get user data from database
  Future<UserModel> _getUserData(String userId) async {
    try {
      final document = await _databases.getDocument(
        databaseId: _databaseId,
        collectionId: _usersCollectionId,
        documentId: userId,
      );

      return _convertDocumentToUserModel(document);
    } on AppwriteException {
      // User profile doesn't exist in database, create it
      final account = await _account.get();
      return await _createUserProfile(userId, account.name, account.email, [
        'staff',
      ]);
    }
  }

  // Helper method to create user profile in database
  Future<UserModel> _createUserProfile(
    String userId,
    String name,
    String email,
    List<String> roles,
  ) async {
    final document = await _databases.createDocument(
      databaseId: _databaseId,
      collectionId: _usersCollectionId,
      documentId: userId,
      data: {
        'name': name,
        'email': email,
        'roles': roles,
        'createdAt': DateTime.now().toIso8601String(),
        'isActive': true,
      },
    );

    return _convertDocumentToUserModel(document);
  }

  // Helper method to convert document to user model
  UserModel _convertDocumentToUserModel(Document document) {
    final data = document.data;
    data['id'] = document.$id;

    return UserModel.fromJson(data);
  }
}
