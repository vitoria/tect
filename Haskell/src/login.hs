import Constants
import Cadastro
import Data.List
import System.IO
import System.IO.Unsafe

getUserPassword :: IO [String]
getUserPassword = do
                    putStrLn (username_const)
                    u <- getLine
                    putStrLn (password_const)
                    p <- getLine
                    return [u, p]

existingUserLogin :: Maybe Bool
existingUserLogin = do
                        if (verifyExistingUser u listUser)
                            then 
                                if (verifingPassword u p listUser)
                                    then
                                        return True
                                    else
                                        return False
                            else
                                return False
                        where
                            u = (unsafePerformIO getUserPassword ) !! 0
                            p = (unsafePerformIO getUserPassword ) !! 1


verifingPassword :: String -> String -> [User] -> Bool
verifingPassword u p l = (verifingPasswordAux user p) 
                        where 
                            user = searchUserByUsername u l


verifingPasswordAux :: User -> String -> Bool
verifingPasswordAux (User _ _ p) s = if s == p then True else False

searchUserByUsername :: String -> [User] -> User
searchUserByUsername u (x:xs) | searchUserByUsernameAux u x == True = x
                              | otherwise = searchUserByUsername u xs

searchUserByUsernameAux :: String -> User -> Bool
searchUserByUsernameAux s (User _ u _) = if s == u then True else False

msgIncorrectPassword :: IO ()
msgIncorrectPassword = do
                        putStrLn (password_incorrect)