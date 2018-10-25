import Constants
import GeneralPrints
import Validation
import System.IO
import System.IO.Unsafe
import System.Directory
import System.FilePath
import Data.List
import Control.Monad
import Control.DeepSeq


data Suite = Suite {
    suiteId :: Int,
    name :: String,
    suiteDescription :: String,
    projectId :: Int
} deriving(Eq, Show)

-- readSuites :: Int -> [Suite]
-- readSuites projId = do
--     let suiteStrList = unsafePerformIO $ readSuitesToStr projId
--         suiteList = stringListToSuiteList suiteStrList
--     return suiteList

stringListToSuiteList :: [String] -> [Suite]
stringListToSuiteList [] = []
stringListToSuiteList (sId:(name:(sDes:(pId:strList)))) = (createSuite (read sId) name sDes (read pId)):(stringListToSuiteList strList)

suiteListToString :: [Suite] -> String
suiteListToString [] = []
suiteListToString (suite:list) = (suiteToString suite) ++ (suiteListToString list)


suiteListToStringList :: [Suite] -> [String]
suiteListToStringList suiteList = lines (suiteListToString suiteList)

readSuites :: Int -> IO [Suite]
readSuites projId = do
    let filePath = data_folder_path ++ "/" ++ (show projId) ++ "/" ++ suites_file_path
    if unsafePerformIO $ doesFileExist filePath
        then do
            -- handle <- openFile filePath ReadMode
            -- fileContents <- hGetContents handle
            -- hClose handle
            -- let contentsList = lines fileContents
            fileContents <- readFile filePath
            let contentsList = lines fileContents
            return (stringListToSuiteList contentsList)
        else do
            return []

writeSuites :: Int -> [Suite] -> IO()
writeSuites projId suites = do
    let filePath = data_folder_path ++ "/" ++ (show projId) ++ "/" ++ suites_file_path
    let projectFolderPath = data_folder_path ++ "/" ++ (show projId) ++ "/"
    let suitesToFile = (suiteListToString suites)

    if unsafePerformIO $ doesDirectoryExist data_folder_path
        then do
            if not (unsafePerformIO $ doesDirectoryExist projectFolderPath)
                then do
                    createDirectory projectFolderPath
                else do
                    putStrLn "Gravando suites de teste..."
        else do
            createDirectory (data_folder_path ++ "/")
            createDirectory projectFolderPath
    
    rnf suitesToFile `seq` (writeFile filePath $ suitesToFile)
    -- handle <- openFile filePath WriteMode
    -- hPutStr handle suitesToFile
    -- hClose handle

writeSuite :: Suite -> Int -> IO()
writeSuite suite projId = do
    let filePath = data_folder_path ++ "/" ++ (show projId) ++ "/" ++ suites_file_path
    let projectFolderPath = data_folder_path ++ "/" ++ (show projId) ++ "/"
    if unsafePerformIO $ doesFileExist filePath
        then do
            handle <- openFile filePath ReadMode
            fileContents <- hGetContents handle
            --fileContents <- readTextFile filePath
            let newSuitesStrings = fileContents ++ (suiteToString suite)
            hClose handle
            
            handle <- openFile filePath WriteMode
            hPutStr handle newSuitesStrings
            hClose handle
            --hClose tempHandle
            --removeFile filePath
            --renameFile tempName suites_file_path
        else do
            if unsafePerformIO $ doesDirectoryExist data_folder_path
                then do
                    if unsafePerformIO $ doesDirectoryExist projectFolderPath
                        then do
                            putStrLn("Diretório encontrado.")
                        else do
                            createDirectory projectFolderPath
                else do 
                    createDirectory (data_folder_path ++ "/")
                    createDirectory projectFolderPath
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

getSuiteId :: Suite -> Int
getSuiteId (Suite {suiteId = id}) = id

generateSuiteId :: [Suite] -> Int
generateSuiteId [] = 1
generateSuiteId suites = (getSuiteId (last suites)) + 1
                                                                       
createNewSuite :: Int -> IO()
createNewSuite projId = do
    let suites = unsafePerformIO $ readSuites projId
    putStrLn create_suite_header
    putStrLn "Informe o Nome da Suite: "
    nameInput <- getLine
    putStrLn "Informe a descricão da Suite: "
    descrInput <- getLine
    let newSuite = createSuite (generateSuiteId suites) nameInput descrInput projId
    let newSuites = suites ++ (newSuite:[])
    writeSuites projId newSuites
    putStrLn "Suite criada com sucesso!"


chooseProcedure :: Int -> Char -> IO()
chooseProcedure projId option
    | option == create_suite = do createNewSuite projId
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
    