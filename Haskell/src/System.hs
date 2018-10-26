module System where
    
    import Login
    import Constants
    import Cadastro
    import GeneralPrints
    import System.IO.Unsafe
    
    import Control.Monad
    import Control.DeepSeq
    import System.IO.Unsafe
    
    import Prelude hiding (readFile)
    import System.IO.Strict (readFile)
    
    running :: String -> IO ()
    running mode = do
        putStrLn "Pressione qualquer tecla para continuar..."
        lixo <- getLine
        let listUserLogin = unsafePerformIO $ readFileUsersLogin
        if (mode == "1")
            then
                return ()
        else 
            if (listUserLogin == [])
                then do
                    loginMenu
            else do
                systemMenu (head listUserLogin)
    
    loginMenu :: IO ()
    loginMenu = do 
                    printHeaderWithSubtitle (login_menu)
                    putStrLn ("\n" ++ choose_option)
                    option <- getLine
                    if (option /= "1" && option /= "2" && option /= "3")
                        then do
                            putStrLn invalid_option
                            systemPause
                            loginMenu
                    else 
                        if (option == "3")
                            then 
                                running "1" 
                                
                        else do
                            clearScreen
                            chooseOptionLogin option
                
    chooseOptionLogin :: String -> IO ()
    chooseOptionLogin "1" = do
        loginUser
        running "0"
    chooseOptionLogin "2" = do
        registerNewUser
        running "0"
    
    readFileUsersLogin :: IO [User]
    readFileUsersLogin = do
                    line <- getLine
                    logged <- readFile logged_user_file_path
        
                    let listlogged = logged
                    let linelogged = (lines listlogged)
                    return (stringsToUser linelogged)
    
    systemMenu :: User -> IO ()
    systemMenu user = do 
        printHeaderWithSubtitle (main_menu)
        putStrLn ("\n" ++ choose_option)
        option <- getLine
        if (option /= "1" && option /= "2" && option /= "3" && option /= "4" && option /= "5" && option /= "6" && option /= "7" && option /= "8")
            then do
                putStrLn invalid_option
                systemPause
                systemMenu user
        else 
            if (option == "8")
                then 
                    running "1"
            else do
                clearScreen
                chooseOptionMenu user option
    
    chooseOptionMenu :: User -> String -> IO ()
    chooseOptionMenu user "1" = myProfile  user
    chooseOptionMenu user "2" = putStrLn ("Falta fazer")
    chooseOptionMenu user "3" = putStrLn ("Falta fazer")
    chooseOptionMenu user "4" = putStrLn ("Falta fazer")
    chooseOptionMenu user "5" = putStrLn ("Falta fazer")
    chooseOptionMenu user "6" = putStrLn ("Falta fazer")
    chooseOptionMenu user "7" = do
        logoutUser
        running "0"
    
    logoutUser :: IO ()
    logoutUser = cleanFile logged_user_file_path
    
    myProfile :: User -> IO ()
    myProfile (User n u _) = do
                    printHeaderWithSubtitle (my_user_header)
                    putStrLn nome
                    putStrLn usuario
                    systemPause
                    where
                        nome = (name_const ++  n)
                        usuario = (username_const ++  u)
    
    cleanFile :: String -> IO ()
    cleanFile path = do
        rnf "" `seq` (writeFile path $ "")
    