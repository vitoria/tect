module TestCase where

    import Constants
    import GeneralPrints
    import Data.List.Split

    import System.FilePath
    import System.Directory

    import Control.Monad
    import Control.DeepSeq
    import System.IO.Unsafe

    import Prelude hiding (readFile)
    import System.IO.Strict (readFile)

    data Step = Step {
        details :: String,
        expectedResult :: String
    } deriving (Eq, Show, Read) 

    data TestCase = TestCase {
        cod :: String,
        name :: String,
        goals :: String,
        status :: String,
        preConditions :: String,
        steps :: [Step]
    } deriving (Eq, Show, Read) 

    removeLastElement :: [t] -> [t]
    removeLastElement [] = []
    removeLastElement [_] = []
    removeLastElement (h:body) = (h:(removeLastElement body))

    createStep :: String -> String -> Step
    createStep details expectedResult = Step {
        details = details,
        expectedResult = expectedResult
    }

    createTestCaseType :: String -> String -> String -> String -> String -> [Step] -> TestCase
    createTestCaseType cod name goals status preConditions steps = TestCase {
        cod = cod,
        name = name,
        goals = goals,
        status = status,
        preConditions = preConditions,
        steps = steps
    }

    deserializeStep :: String -> Step
    deserializeStep str = do
        let splitedStr = splitOn "\", expectedResult = \"" str
        let details = splitedStr!!0
        let expectedResult = splitedStr!!1
        createStep details expectedResult

    deserializeSteps :: [String] -> [Step]
    deserializeSteps [] = []
    deserializeSteps (head:body) = ((deserializeStep head):(deserializeSteps body))

    deserializeTestCase :: String -> TestCase
    deserializeTestCase str = do
        let splitedStr = splitOn "TestCase {cod = \"" str
        let splitedStr2 = splitOn "\", name = \"" (splitedStr!!1)
        let splitedStr3 = splitOn "\", goals = \"" (splitedStr2!!1)
        let splitedStr4 = splitOn "\", status = \"" (splitedStr3!!1)
        let splitedStr5 = splitOn "\", preConditions = \"" (splitedStr4!!1)
        let splitedStr6 = (splitOn "\", steps = [Step {details = \"" (splitedStr5!!1))
        let splitedStr7 = removeLastElement (splitOn "\"}]}" (splitedStr6!!1))
        let splitedStr8 = splitOn "\"},Step {details = \"" ((splitedStr7)!!0)
        
        let cod = (splitedStr2!!0)
        let name = (splitedStr3!!0)
        let goals = (splitedStr4!!0)
        let status = (splitedStr5!!0)
        let preConditions = (splitedStr6!!0)

        createTestCaseType cod name goals status preConditions (deserializeSteps splitedStr8)

    deserializeTestCases :: [String] -> [TestCase]
    deserializeTestCases [] = []
    deserializeTestCases (current:body) = ((deserializeTestCase current):(deserializeTestCases body))

    listAppend :: [TestCase] -> TestCase -> [TestCase]
    listAppend [] test = [test]
    listAppend (h:body) test = (h:(listAppend body test))

    readTestCasesFromFile :: Int -> Int -> IO [TestCase]
    readTestCasesFromFile projectId suiteId = do
        let filePath = "data/" ++ show projectId ++ "/" ++ show suiteId ++ ".dat"
        if unsafePerformIO $ doesFileExist filePath
            then do
                content <- readFile filePath
                let testCasesStr = lines content
                return (deserializeTestCases testCasesStr)
            else do
                return []   

    writeTestCaseInFile :: [TestCase] -> Int -> Int -> IO()
    writeTestCaseInFile testCases projectId suiteId = do
        let filePath = "data/" ++ show projectId ++ "/" ++ show suiteId ++ ".dat"
            fileFolder = "data/" ++ show projectId ++ "/"
        if not (unsafePerformIO $ doesDirectoryExist data_folder_path)
            then do
                createDirectory data_folder_path
                createDirectory fileFolder
            else do
                if not (unsafePerformIO $ doesDirectoryExist fileFolder)
                    then do
                        createDirectory fileFolder
                    else do
                        putStrLn "Salvando dados..."

        let testCasesToFileStr = testCaseListToString testCases
        rnf testCasesToFileStr `seq` (writeFile filePath $ testCasesToFileStr)

    testCaseListToString :: [TestCase] -> String
    testCaseListToString [] = []
    testCaseListToString (testCase:list) = (show testCase) ++ "\n" ++ testCaseListToString list

    getcodFromTestCase :: TestCase -> Int
    getcodFromTestCase (TestCase cod _ _ _ _ _) = do
        let codInt = read cod :: Int
        codInt

    generatecod :: Int -> Int -> String
    generatecod projectId suiteId = do
        let testCases = unsafePerformIO $ readTestCasesFromFile projectId suiteId
        let size = length testCases
        if size == 0 then "1"
        else do
            let newcod = show (getcodFromTestCase (testCases!!(size - 1)) + 1)
            newcod

    getCod :: String -> Int -> Int -> String
    getCod "0" projectId suiteId = generatecod projectId suiteId
    getCod cod projectId suiteId = cod

    createTestCase :: String -> Int -> Int -> IO()
    createTestCase currentCod projectId suiteId = do
        putStrLn name_const
        name <- getLine
        putStrLn goal
        goals <- getLine
        putStrLn preconditions
        preConditions <- getLine
        putStrLn case_steps_reading_header
        let cod = getCod currentCod projectId suiteId
        createSteps 0 (createTestCaseType cod name goals "Nao executado" preConditions []) projectId suiteId
        return ()

    createSteps :: Int -> TestCase -> Int -> Int -> IO()
    createSteps stepsQuantity (TestCase cod name goals status preConditions steps) projectId suiteId  = do
        putStrLn ("Passo " ++ show (stepsQuantity + 1))
        putStrLn case_step_description
        caseDescription <- getLine
        putStrLn case_step_expected_result
        caseExpectedResult <- getLine
        let currentStep = createStep caseDescription caseExpectedResult
        let testCaseUpdated = createTestCaseType cod name goals status preConditions (currentStep:steps)
        putStrLn case_step_continue_message
        resp <- getLine
        if resp == "N" || resp == "n"
            then do
                let testCases = listAppend (deleteCase (unsafePerformIO $ readTestCasesFromFile projectId suiteId) cod) testCaseUpdated
                writeTestCaseInFile testCases projectId suiteId
        else do
            createSteps (stepsQuantity + 1) testCaseUpdated projectId suiteId
        return (())

    showTestCase :: [TestCase] -> IO()
    showTestCase [] = do
        return ()
    showTestCase ((TestCase cod name goals status preConditions _):body) = do
        putStrLn (cod ++ " | " ++ name ++ " | " ++ status)
        putStrLn test_case_table_line
        showTestCase body

    showSteps :: [Step] -> Int -> IO()
    showSteps [] _ = do
        return ()
    showSteps ((Step details expectedResult):body) num = do
        putStrLn ("\n   - Passo " ++ (show (num + 1)))
        putStrLn ("Detalhes: " ++ details)
        putStrLn ("Resultado esperado: " ++ expectedResult)
        showSteps body (num + 1)

    showTest :: TestCase -> IO()
    showTest (TestCase cod name goals status preConditions steps) = do
        putStrLn ("Id: " ++ cod)
        putStrLn ("Nome: " ++ name)
        putStrLn ("Objetivos: " ++ goals)
        putStrLn ("Pre-condicoes: " ++ preConditions)
        putStrLn ("Status: " ++ status)

        showSteps steps 0

    listTestCases :: Int -> Int -> IO()
    listTestCases projectId suiteId = do
        let testCases = unsafePerformIO $ readTestCasesFromFile projectId suiteId
        clearScreen
        printHeaderWithSubtitle test_case_header
        -- print testCases
        putStrLn ""
        putStrLn test_case_table_line
        putStrLn test_case_table_header
        putStrLn test_case_table_line
        showTestCase testCases

    searchCase :: [TestCase] -> String -> TestCase
    searchCase ((TestCase cod name goals status preConditions steps):body) codSearch = do
        if cod == codSearch then do
            createTestCaseType cod name goals status preConditions steps
        else searchCase body codSearch

    containsTests :: [TestCase] -> String -> Bool
    containsTests [] _ = False
    containsTests ((TestCase cod _ _ _ _ _):body) codSearch = do
        if cod == codSearch then do
            True
        else do
            let result = containsTests body codSearch
            result

    searchTestCase :: Int -> Int -> IO()
    searchTestCase projectId suiteId = do
        putStrLn "Informe o id do caso de teste: "
        cod <- getLine
        let tests = unsafePerformIO(readTestCasesFromFile projectId suiteId)
        let contains = containsTests tests cod
        if contains then do
            printHeaderWithSubtitle test_case_header
            showTest (searchCase tests cod)
            return ()
        else do
            putStrLn "Caso de Testes nao encontrado"
            systemPause
            return ()

    deleteCase :: [TestCase] -> String -> [TestCase]
    deleteCase [] _ = []
    deleteCase ((TestCase cod a b c d e) : body) codDelete = do
        if cod == codDelete then deleteCase body codDelete
        else ((createTestCaseType cod a b c d e) : (deleteCase body codDelete))

    deleteTestCase :: Int -> Int -> IO()
    deleteTestCase projectId suiteId = do
        let tests = unsafePerformIO $ readTestCasesFromFile projectId suiteId
        printHeaderWithSubtitle test_case_header
        putStrLn "\nInforme o id do caso de teste: "
        cod <- getLine
        
        let contains = containsTests tests cod
        if contains then do
            showTest (searchCase tests cod)
            putStrLn "Tem certeza que deseja excluir esse caso de testes? (S/N)"
            resp <- getLine
            if resp == "S" || resp == "s" then do
                writeTestCaseInFile (deleteCase tests cod) projectId suiteId
                putStrLn "\nCaso de testes exluido com sucesso!"
                systemPause
                return ()
            else do
                putStrLn "\nCaso de testes nao foi excluido!"
                systemPause
                return ()
        else do
            putStrLn "Caso de testes nao encontrado!"
            systemPause
            return ()
        return ()

    getStatus :: Int -> String
    getStatus 1 = "Passou"
    getStatus 2 = "Nao passou"
    getStatus 3 = "Erro na execucao"

    changeStatus :: [TestCase] -> TestCase -> Int -> Int -> Int -> IO()
    changeStatus tests (TestCase cod name goals _ preConditions steps) idStatus projectId suiteId = do
        print preConditions
        systemPause
        let test = (createTestCaseType cod name goals (getStatus idStatus) preConditions steps)
        print test
        let testsUpdated = listAppend (deleteCase tests cod) test
        print testsUpdated
        systemPause
        writeTestCaseInFile testsUpdated projectId suiteId

    menuChangeStatus :: [TestCase] -> TestCase -> Int -> Int -> IO()
    menuChangeStatus tests (TestCase cod name goals status preConditions steps) projectId suiteId = do
        printHeaderWithSubtitle test_case_header
        putStrLn ("- Editando Caso de Testes\n")
        putStrLn "-- Estado atual"
        showTest (createTestCaseType cod name goals status preConditions steps)

        putStrLn "\n-- Alterar status do Caso de Testes"
        putStrLn "(1) Passou"
        putStrLn "(2) Nao passou"
        putStrLn "(3) Erro na execucao"
        putStrLn "(4) Voltar"

        option <- readOption

        if option < 1 || option > 4 then do
            putStrLn "Opcao invalida!"
            systemPause
            menuChangeStatus tests (createTestCaseType cod name goals status preConditions steps) projectId suiteId
        else do
            if option == 4 then do
                return ()
            else do
                changeStatus tests (createTestCaseType cod name goals status preConditions steps) option projectId suiteId

        systemPause

    menuEditTest :: String -> [TestCase] -> Int -> Int -> IO()
    menuEditTest cod tests projectId suiteId = do
        printHeaderWithSubtitle test_case_header

        putStrLn "(1) Editar Dados do Caso de Teste"
        putStrLn "(2) Editar Status do Caso de Teste"
        putStrLn "(3) Voltar"

        option <- readOption

        let test = searchCase tests cod

        if option == 1 || option == 2 || option == 3 then do
            if option == 1 then do
                printHeaderWithSubtitle test_case_header
                putStrLn ("- Editando Caso de Testes\n")
                putStrLn "-- Estado atual"
                showTest test
                putStrLn "\n-- Estado novo"
                createTestCase cod projectId suiteId
            else do
                if option == 2 then do
                    menuChangeStatus tests test projectId suiteId
                else do
                    return ()
        else do
            putStrLn "\nOpcao invalida!"
            systemPause
            menuEditTest cod tests projectId suiteId

    showEditTestCaseMenu :: Int -> Int -> IO()
    showEditTestCaseMenu projectId suiteId = do
        let tests = unsafePerformIO(readTestCasesFromFile projectId suiteId)
        printHeaderWithSubtitle test_case_header
        putStrLn "Informe o id do Caso de Teste: "
        cod <- getLine

        let contains = containsTests tests cod

        if contains then do 
            menuEditTest cod tests projectId suiteId
        else do
            putStrLn "Caso de Testes nao foi encontrado"
            systemPause
        return ()


    isOptionValcod :: Int -> Bool
    isOptionValcod option = option >= 1 && option <= 6

    chooseProcedure :: Int -> Int -> Int -> IO()
    chooseProcedure 1 projectId suiteId = do createTestCase "0" projectId suiteId
    chooseProcedure 2 projectId suiteId = do listTestCases projectId suiteId
    chooseProcedure 3 projectId suiteId = do searchTestCase projectId suiteId
    chooseProcedure 4 projectId suiteId = do showEditTestCaseMenu projectId suiteId
    chooseProcedure 5 projectId suiteId = do deleteTestCase projectId suiteId

    showMenu :: IO()
    showMenu = do 
        printHeaderWithSubtitle test_case_header
        putStrLn test_Case_Menu

    caseMenu :: Int -> Int -> IO()
    caseMenu projectId suiteId = do
        showMenu
        option <- readOption
        if isOptionValcod option
            then do
                if option == 6 then return ()
                else do 
                    chooseProcedure option projectId suiteId
                    systemPause
                    caseMenu projectId suiteId
        else do
            systemPause
            caseMenu projectId suiteId

    -- Statistics
    getExecutedTests :: [TestCase] -> Float
    getExecutedTests [] = 0
    getExecutedTests ((TestCase _ _ _ status _ _): body) = do
        if status == "Nao executado" then getExecutedTests body
        else 1 + (getExecutedTests body)

    getPassedTests :: [TestCase] -> Float
    getPassedTests [] = 0
    getPassedTests ((TestCase _ _ _ status _ _): body) = do
        if status == "Passou" then 1 + getPassedTests body
        else getPassedTests body

    calculateStatiscs :: Int -> Int -> Float
    calculateStatiscs projectId suiteId = do
        let tests = unsafePerformIO $ readTestCasesFromFile projectId suiteId
        let executedTestsQuantity = getExecutedTests tests
        let passedTestsQuantity = getPassedTests tests
        if executedTestsQuantity == 0 then 0
        else ((passedTestsQuantity / executedTestsQuantity) * 100.0)