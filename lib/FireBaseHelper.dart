import 'package:firebase_auth/firebase_auth.dart';

class FireBaseHelper{
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<dynamic> signUp(String email,String password,String username) async
  {
    try{
      UserCredential user = await auth.createUserWithEmailAndPassword(email: email, password: password);
      await auth.currentUser!.updateDisplayName(username);
      await auth.currentUser!.reload();
      if(user.user !=null)
        {
          return user.user;
        }
    }
    on FirebaseAuthException catch (e)
    {
      return e.message;
    }
  }

  Future<dynamic> signIn(String email,String password) async
  {
    try{
      UserCredential user = await auth.signInWithEmailAndPassword(email: email, password: password);
      if(user.user !=null)
      {
        return user.user;
      }
    }
    on FirebaseAuthException catch (e)
    {
      return e.message;
    }
  }

  Future<dynamic> signOut()async{
    await auth.signOut();
  }
}