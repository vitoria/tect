import Constants
import GeneralPrints
import Validation
import System.IO
import System.IO.Unsafe
import System.Directory
import Data.List


data Suite = Suite {
    suiteId :: Int,
    name :: String,
    suiteDescription :: String,
    projectId :: Int
} deriving(Eq, Show)

readSuitesToStr :: Int -> IO [String]
readSuitesToStr projId = do
    let filePath = data_folder_path ++ "/" ++ (show projId) ++ "/" ++ suites_file_path
    handle <- openFile filePath ReadMode
    fileContents <- hGetContents handle
    let contentsList = lines fileContents
    return contentsList

writeSuite :: Suite -> Int -> IO()
writeSuite suite projId = do
    let filePath = data_folder_path ++ "/" ++ (show projId) ++ "/" ++ suites_file_path
    let folderPath = data_folder_path ++ "/" ++ (show projId) ++ "/"
    if unsafePerformIO $ doesFileExist filePath
        then do
            handle <- openFile filePath ReadMode
            tempdir <- getTemporaryDirectory
            (tempName, tempHandle) <- openTempFile tempdir "temp"
            fileContents <- hGetContents handle
            let newSuitesStrings = fileContents ++ (suiteToString suite)
            hPutStr tempHandle newSuitesStrings
            hClose handle
            hClose tempHandle
            removeFile filePath
            renameFile tempName filePath
        else do
            if unsafePerformIO $ doesDirectoryExist data_folder_path
                then do createDirectory (data_folder_path ++ "/")
                else do 
                    createDirectory (data_folder_path ++ "/")
                    createDirectory folderPath
            --tempdir <- getTemporaryDirectory
            --(tempName, tempHandle) <- openTempFile tempdir "temp"
            tempHandle <- openFile filePath WriteMode
            let newSuitesStrings = suiteToString suite
            hPutStr tempHandle newSuitesStrings
            hClose tempHandle
            --renameFile tempName filePath



suiteToString :: Suite -> String
suiteToString (Suite suiteId name suiteDescription projectId) = (show suiteId) ++ "\n" ++ name ++ "\n" ++ suiteDescription ++ "\n" ++ (show projectId) ++ "\n"

createSuite :: Int -> String -> String -> Int -> Suite
createSuite idInput nameInput descriptionInput projectIdInput = Suite {suiteId = idInput,
                                                                       name = nameInput,
                                                                       suiteDescription = descriptionInput,
                                                                       projectId = projectIdInput}

chooseProcedure :: Int -> Char -> IO()
chooseProcedure projId option
    | option == create_suite = do
        putStrLn create_suite_header
        putStrLn "Informe o ID da Suite: "
        idInput <- getLine
        putStrLn "Informe o Nome da Suite: "
        nameInput <- getLine
        putStrLn "Informe a descricão da Suite: "
        descrInput <- getLine
        let newSuite = createSuite (read idInput) nameInput descrInput projId
        putStrLn(show newSuite)
        putStrLn "Tentando escrever suite no arquivo..."
        writeSuite newSuite projId

    | option == list_suites = do
        print "LIST SUITE"
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
                    clearScreen
                    chooseProcedure projId option
                    systemPause
                    suiteMenu projId
        else do
            putStrLn invalid_option
            systemPause
            suiteMenu projId

main :: IO()
main = do
    suiteMenu 1
    