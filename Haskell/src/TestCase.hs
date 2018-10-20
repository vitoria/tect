import Constants
import GeneralPrints
-- module TestCase where

isOptionValid :: Int -> Bool
isOptionValid option = option >= 1 && option <= 6

chooseProcedure :: Int -> IO()
chooseProcedure 1 = do print "CREATE"
chooseProcedure 2 = do print "CREATE"
chooseProcedure 3 = do print "CREATE"
chooseProcedure 4 = do print "CREATE"
chooseProcedure 5 = do print "CREATE"
chooseProcedure 6 = do print "CREATE"
chooseProcedure option = do print "NOT CREATE"

showMenu :: IO()
showMenu = do 
    printHeaderWithSubtitle test_case_header
    putStrLn test_Case_Menu

menu :: IO()
menu = do
    showMenu
    putStrLn choose_option
    input <- getLine
    let option = read input :: Int
    if isOptionValid option
        then chooseProcedure option
    else do
        systemPause
        menu

main = do
    menu