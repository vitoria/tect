import Constants
import Cadastro
import Data.List
import System.IO
import System.IO.Unsafe
import GeneralPrints

loginUser :: IO User
loginUser = do  
                clearScreen
                printHeaderWithSubtitle (login_header)
                putStr (username_const)
                u <- getLine
                putStr (password_const)
                p <- getLine
                if (verifyExistingUser u listUser)
                    then 
                        if (verifingPassword u p listUser)
                            then
                                --putStrLn ("Login efetuado")
                                return User {name = (getNameUser (searchUserByUsername u listUser)), username = u, password = p}
                            else
                                --putStrLn (password_incorrect)
                                return User {name = "", username = "", password = password_incorrect}
                    else
                        --putStrLn (user_not_registered)
                        return User {name = user_not_registered, username = "", password = ""}


verifingPassword :: String -> String -> [User] -> Bool
verifingPassword u p l = if (verifingPasswordAux user p) 
                            then 
                                True
                            else
                                False
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

register :: IO ()
register = registerNewUser