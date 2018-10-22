import Constants
import GeneralPrints
import Project

isOptionValid :: Int -> Bool
isOptionValid option = option >= 1 && option <= 8

chooseProcedure :: Int -> IO()
chooseProcedure 1 = do print "CREATE"
chooseProcedure 2 = do 
    criarProjeto
    print creation_success
chooseProcedure 3 = do print "CREATE"
chooseProcedure 4 = do print "CREATE"
chooseProcedure 5 = do print "CREATE"
chooseProcedure 6 = do print "CREATE"
chooseProcedure 7 = do print "CREATE"
chooseProcedure 8 = do print "CREATE"
chooseProcedure option = do print "NOT CREATE"

showUserMenu :: IO()
showUserMenu = do 
    printHeaderWithSubtitle main_header
    putStrLn main_menu

menu :: IO()
menu = do
    showUserMenu
    putStrLn choose_option
    input <- getLine
    let option = read input :: Int
    if isOptionValid option
        then do
            chooseProcedure option
            systemPause
            menu
    else do
        putStrLn invalid_option
        systemPause
        menu
    
main = do
    menu