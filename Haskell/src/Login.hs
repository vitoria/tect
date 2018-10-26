module Login where

import Constants
import Cadastro
import Data.List
import System.IO.Unsafe
import GeneralPrints
import System.IO


loginUser :: IO ()
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
                            then do
                                putStrLn (success_login)                                
                                saveLoggedUser (User {name = (getNameUser (searchUserByUsername u listUser)), username = u, password = p})
                            else
                                putStrLn (password_incorrect)
                    else
                        putStrLn (user_not_registered)


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

saveLoggedUser :: User -> IO ()
saveLoggedUser (User n u p) = do
                            arq <- openFile logged_user_file_path WriteMode
                            hPutStr arq n
                            hPutStr arq "\n"
                            hPutStr arq u
                            hPutStr arq "\n"
                            hPutStr arq p
                            hPutStr arq "\n"
                            hFlush arq
                            hClose arq

