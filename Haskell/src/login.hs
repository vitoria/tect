import Constants
import Cadastro

existingUserLogin :: User -> Bool
existingUserLogin (User _ u p) = do
                                if (verifyExistingUser u (unsafePerformIO readFileUsers))
                                    then 
                                        if 


