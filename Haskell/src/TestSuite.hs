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

suiteToString :: Suite -> String
suiteToString (Suite suiteId name suiteDescription projectId) = (show suiteId) ++ "\n" ++ name ++ "\n" ++ suiteDescription ++ "\n" ++ (show projectId) ++ "\n"

createSuite :: Int -> String -> String -> Int -> Suite
createSuite idInput nameInput descriptionInput projectIdInput = Suite {suiteId = idInput,
                                                                       name = nameInput,
                                                                       suiteDescription = descriptionInput,
                                                                       projectId = projectIdInput}

getSuiteId :: Suite -> Int
getSuiteId (Suite {suiteId = id}) = id

getSuiteName :: Suite -> String
getSuiteName (Suite {name = sName}) = sName

generateNewSuiteId :: [Suite] -> Int
generateNewSuiteId [] = 1
generateNewSuiteId suites = (getSuiteId (last suites)) + 1
                                                                       
createNewSuite :: Int -> IO()
createNewSuite projId = do
    let suites = unsafePerformIO $ readSuites projId
    putStrLn create_suite_header
    putStrLn "Informe o Nome da Suite: "
    nameInput <- getLine
    putStrLn "Informe a descricão da Suite: "
    descrInput <- getLine
    let newSuite = createSuite (generateNewSuiteId suites) nameInput descrInput projId
    let newSuites = suites ++ (newSuite:[])
    writeSuites projId newSuites
    putStrLn "Suite criada com sucesso!"

suitesToStringShow :: [Suite] -> String
suitesToStringShow [] = []
suitesToStringShow ((Suite {suiteId = id, name = sName}):suites) = (" " ++ (show id) ++ " - " ++ sName ++ "\n") ++ (suitesToStringShow suites)

showSuites :: Int -> IO()
showSuites projId = do
    let suites = unsafePerformIO $ readSuites projId
    putStrLn suite_list_header
    putStrLn "ID - Nome da Suite"
    putStrLn (suitesToStringShow suites)

searchSuite :: Int -> IO()
searchSuite projId = do
    let suites = unsafePerformIO $ readSuites projId
    putStrLn search_suite_header
    putStrLn "Selecione o parâmetro de pesquisa:\n(1) ID\n(2) Nome da Suite\n"
    searchParameter <- getLine

    if isOptionValid searchParameter '1' '2'
        then do
            if (searchParameter !! 0) == '1'
                then do
                    putStrLn "Informe o ID da Suite:"
                    suiteId <- getLine
                    if isStringNumeric suiteId
                        then do
                            if isSuiteOnListId (read suiteId) suites
                                then do
                                    let foundSuite = searchSuiteId (read suiteId) suites
                                    clearScreen
                                    putStrLn search_suite_header
                                    putStrLn("Suite encontrada:\n" ++ showSuite foundSuite)
                                else do putStrLn "A suite com o ID informado não foi encontrada."
                        else do putStrLn "ID da Suite inválido."
                else do
                    putStrLn "Informe o Nome da Suite:"
                    suiteName <- getLine
                    if isSuiteOnListName suiteName suites
                        then do
                            let foundSuite = searchSuiteName suiteName suites
                            clearScreen
                            putStrLn search_suite_header
                            putStrLn("Suite encontrada:\n" ++ showSuite foundSuite)
                        else do putStrLn "A suite com o nome informado não foi encontrada."
        else do
            putStrLn "Opção de seleção inválida!"

showSuite :: Suite -> String
showSuite (Suite suiteId name suiteDescription projectId) = "Suite ID " ++ show suiteId ++ "\nNome: " ++ name ++ "\nDescrição: " ++ suiteDescription ++ "\nID Projeto da Suite: " ++ show projectId ++ "\n"

searchSuiteId :: Int -> [Suite] -> Suite
searchSuiteId suiteId [] = (Suite {suiteId = -1, name = "NOT FOUND", suiteDescription = "NOT FOUND", projectId = -1})
searchSuiteId suiteId (suite:suites)
    | (getSuiteId suite) == suiteId = suite
    | otherwise = searchSuiteId suiteId suites

searchSuiteName :: String -> [Suite] -> Suite
searchSuiteName suiteName [] = (Suite {suiteId = -1, name = "NOT FOUND", suiteDescription = "NOT FOUND", projectId = -1})
searchSuiteName suiteName (suite:suites)
    | (getSuiteName suite) == suiteName = suite
    | otherwise = searchSuiteName suiteName suites

editSuite :: Int -> IO()
editSuite projId = do
    let suites = unsafePerformIO $ readSuites projId
    putStrLn edit_suite_header
    putStrLn "Informe o ID da Suite:"
    suiteId <- getLine
    if isStringNumeric suiteId
        then do
            if isSuiteOnListId (read suiteId) suites
                then do
                    let foundSuite = searchSuiteId (read suiteId) suites
                    clearScreen
                    putStrLn edit_suite_header
                    putStrLn("Dados atuais da Suite:\n" ++ showSuite foundSuite)
                    putStrLn "\n"
                    putStrLn "Informe o novo Nome da Suite: "
                    nameInput <- getLine
                    putStrLn "Informe a nova descricão da Suite: "
                    descrInput <- getLine
                    let editedSuite = generateEditedSuite foundSuite nameInput descrInput
                        newSuites = swapEditedSuite editedSuite suites
                    writeSuites projId newSuites
                    putStrLn "Suite editada com sucesso."
                else do putStrLn "A suite com o ID informado não foi encontrada."
        else do putStrLn "ID da Suite inválido."

generateEditedSuite :: Suite -> String -> String -> Suite
generateEditedSuite (Suite {suiteId = sId, projectId = pId}) newName newDescription = (Suite sId newName newDescription pId)

swapEditedSuite :: Suite -> [Suite] -> [Suite]
swapEditedSuite editedSuite [] = []
swapEditedSuite editedSuite (suite:suites)
    | (getSuiteId editedSuite) == (getSuiteId suite) = editedSuite:suites
    | otherwise = suite:(swapEditedSuite editedSuite suites)

deleteSuiteFromList :: Int -> [Suite] -> [Suite]
deleteSuiteFromList suiteId [] = []
deleteSuiteFromList suiteId (suite:suites)
    | (getSuiteId suite) == suiteId = suites
    | otherwise = suite:(deleteSuiteFromList suiteId suites)

isSuiteOnListName :: String -> [Suite] -> Bool
isSuiteOnListName suiteName [] = False
isSuiteOnListName suiteName (suite:suites)
    | (getSuiteName suite) == suiteName = True
    | otherwise = isSuiteOnListName suiteName suites

isSuiteOnListId :: Int -> [Suite] -> Bool
isSuiteOnListId suiteId [] = False
isSuiteOnListId suiteId (suite:suites)
    | (getSuiteId suite) == suiteId = True
    | otherwise = isSuiteOnListId suiteId suites

deleteSuiteFromSystem :: Int -> Int -> IO()
deleteSuiteFromSystem projId suiteId = do
    let suites = unsafePerformIO $ readSuites projId
    if isSuiteOnListId suiteId suites
        then do
            let newSuites = deleteSuiteFromList suiteId suites
            writeSuites projId newSuites
            putStrLn "Suite excluída com sucesso."
        else do
            putStrLn "ID inválido, suite não cadastrada."

deleteSuite :: Int -> IO()
deleteSuite projId = do
    putStrLn delete_suite_header
    putStrLn "Informe o ID da Suite a ser deletada:"
    idToDelete <- getLine
    deleteSuiteFromSystem projId (read idToDelete)


chooseProcedure :: Int -> Char -> IO()
chooseProcedure projId option
    | option == create_suite = do createNewSuite projId
    | option == list_suites = do showSuites projId
    | option == search_suite = do searchSuite projId
    | option == edit_suite = do editSuite projId
    | option == delete_suite = do deleteSuite projId
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