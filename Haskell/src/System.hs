module System where
    
import Login
import Constants
import Cadastro
import GeneralPrints
import System.IO
import System.IO.Unsafe

running :: IO ()
running  = if ((length listUserLogin) /= 0)
            then do
                loginMenu
                running
            else do
                systemMenu (head listUserLogin)
                running

loginMenu :: IO ()
loginMenu = do 
                printHeaderWithSubtitle (login_menu)
                option <- getLine
                if (option /= "1" && option /= "2" && option /= "3")
                    then do
                        putStrLn invalid_option
                        systemPause
                        loginMenu
                else 
                    if (option == "3")
                        then 
                            return ()
                    else do
                        clearScreen
                        chooseOptionLogin option
            
chooseOptionLogin :: String -> IO ()
chooseOptionLogin "1" = loginUser
chooseOptionLogin "2" = registerNewUser

readFileUsersLogin :: IO [User]
readFileUsersLogin = do
                content <- readFile logged_user_file_path
    
                let listUser = content
                let lineUser = (lines listUser)
                return (stringsToUser lineUser)
    
listUserLogin :: [User]
listUserLogin = unsafePerformIO readFileUsersLogin

systemMenu :: User -> IO ()
systemMenu (User _ u _) = do 
    printHeaderWithSubtitle (main_menu)
    option <- getLine
    if (option /= "1" && option /= "2" && option /= "3" && option /= "4" && option /= "5" && option /= "6" && option /= "7" && option /= "8")
        then do
            putStrLn invalid_option
            systemPause
            loginMenu
    else 
        if (option == "8")
            then 
                return ()
        else do
            clearScreen
            chooseOptionLogin option