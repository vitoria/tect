import Constants
import GeneralPrints
import Validation

data Suite = Suite {
    id :: Int,
    name :: String,
    description :: String,
    projectId :: Int
} deriving(Eq, Show)

chooseProcedure :: Char -> IO()
chooseProcedure option
    | option == create_suite = do print "CREATE SUITE"
    | option == list_suites = do print "LIST SUITE"
    | option == search_suite = do print "SEARCH SUITE"
    | option == edit_suite = do print "EDIT SUITE"
    | option == delete_suite = do print "DELETE SUITE"
    | option == manage_test_cases = do print "MANAGE CASES"
    | option == go_back = do print "GO BACK"
    | otherwise = do print invalid_option

showSuiteMenu :: IO()
showSuiteMenu = do
    printHeaderWithSubtitle suite_menu

suiteMenu :: Int -> IO()
suiteMenu projId = do
    showSuiteMenu
    putStrLn choose_option
    input <- getLine
    if isOptionValid input create_suite go_back
        then do
            let option = input !! 0
            if option == go_back
                then systemPause
                else do
                    chooseProcedure option
                    systemPause
                    suiteMenu projId
        else do
            putStrLn invalid_option
            systemPause
            suiteMenu projId

main :: IO()
main = do
    suiteMenu 1
    