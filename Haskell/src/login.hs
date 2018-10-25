import Constants
import Cadastro
import Data.List
import System.IO
import System.IO.Unsafe

getUserPassword :: IO  User
getUserPassword = do
                    putStrLn (username_const)
                    u <- getLine
                    putStrLn (password_const)
                    p <- getLine
                    let isLogged = existingUserLogin u p
                    if (isLogged)
                        then 
                            return User {name = (getNameUser (searchUserByUsername u listUser)), username = u, password = p}
                        else
                            return Nothing

existingUserLogin :: String -> String -> Maybe Bool
existingUserLogin u p = do
                        if (verifyExistingUser u listUser)
                            then 
                                if (verifingPassword u p listUser)
                                    then
                                        return Just True
                                    else
                                        return Just False
                            else
                                return Just False
                        {-where
                            u = (unsafePerformIO getUserPassword ) !! 0
                            p = (unsafePerformIO getUserPassword ) !! 1-}


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

getNameUser :: User -> String
getNameUser (User name _ _) = name