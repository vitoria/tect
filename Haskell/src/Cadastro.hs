module Cadastro where

import Constants
import System.IO
import System.IO.Unsafe
import Data.List
import GeneralPrints
import System.Directory
import System.FilePath

data User = User {
    name :: String,
    username :: String,
    password :: String
} deriving (Eq, Show, Read) 

registerNewUser :: IO ()
registerNewUser = do
                clearScreen
                printHeaderWithSubtitle (sign_up_header)
                putStrLn ("")
                putStr (name_const)
                n <- getLine
                u <- getUser
                putStr (password_const)
                p <- getLine
                verifySenha <- getPassword p
                putStrLn (user_registered)
                saveUser User {name = n, username = u, password = p}
                systemPause

getUser :: IO String
getUser = do
            putStr (username_const)
            u <- getLine
            let listUser = unsafePerformIO $ readFileUsers
            if (verifyExistingUser u listUser) 
                then do 
                putStrLn (user_already_registered)
                getUser
            else 
                return u


getPassword :: String -> IO String
getPassword x = do 
                putStr (confirmation_password)
                senha <- getLine
                if senha == x 
                    then 
                        return senha 
                    else do
                        putStrLn (passwords_not_match)
                        getPassword x

verifyExistingUser :: String -> [User] -> Bool
verifyExistingUser _ [] = False
verifyExistingUser a (x:xs) | verifyExistingUserAux a x == True = True
                            | otherwise = verifyExistingUser a xs

verifyExistingUserAux :: String -> User -> Bool
verifyExistingUserAux u (User _ a _) = if u == a then True else False

saveUser :: User -> IO ()
saveUser (User n u p)= do
    if not (unsafePerformIO $ doesDirectoryExist data_folder_path)
        then do
            createDirectory data_folder_path
        else do 
            putStrLn "Salvando dados..."
    arq <- openFile users_file_path AppendMode
    hPutStr arq n
    hPutStr arq "\n"
    hPutStr arq u
    hPutStr arq "\n"
    hPutStr arq p
    hPutStr arq "\n"
    hFlush arq
    hClose arq

readFileUsers :: IO [User]
readFileUsers = do
    if not (unsafePerformIO $ doesDirectoryExist data_folder_path)
        then do
            createDirectory data_folder_path
            readFileUsers
        else do 
            content <- readFile users_file_path
            let listUser = content
            let lineUser = (lines listUser)
            return (stringsToUser lineUser)


stringsToUser :: [String] -> [User]
stringsToUser [] = []
stringsToUser (x:(y:(z:xs))) = (User x y z) : stringsToUser xs



