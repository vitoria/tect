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

-- module TestCase where

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

readTestCasesFromFile :: IO [TestCase]
readTestCasesFromFile = do
    let filePath = "data/testCases.dat"
    if unsafePerformIO $ doesFileExist filePath
        then do
            content <- readFile filePath
            let testCasesStr = lines content
            return (deserializeTestCases testCasesStr)
        else do
            return []   

writeTestCaseInFile :: [TestCase] -> IO()
writeTestCaseInFile testCases = do
    let filePath = "data/testCases.dat"
    if not (unsafePerformIO $ doesDirectoryExist data_folder_path)
        then do
            createDirectory data_folder_path
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

generatecod :: String
generatecod = do
    let testCases = unsafePerformIO readTestCasesFromFile
    let size = length testCases
    if size == 0 then "1"
    else do
        let newcod = show (getcodFromTestCase (testCases!!(size - 1)) + 1)
        newcod

getCod :: String -> String
getCod "0" = generatecod
getCod cod = cod

createTestCase :: String -> IO()
createTestCase currentCod = do
    putStrLn name_const
    name <- getLine
    putStrLn goal
    goals <- getLine
    putStrLn preconditions
    preConditions <- getLine
    putStrLn case_steps_reading_header
    let cod = getCod currentCod
    createSteps 0 (createTestCaseType cod name goals "Nao executado" preConditions [])
    return ()

createSteps :: Int -> TestCase -> IO()
createSteps stepsQuantity (TestCase cod name goals status preConditions steps)  = do
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
            let testCases = listAppend (deleteCase (unsafePerformIO readTestCasesFromFile) cod) testCaseUpdated
            writeTestCaseInFile testCases
    else do
        createSteps (stepsQuantity + 1) testCaseUpdated
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

listTestCases :: IO()
listTestCases = do
    clearScreen
    printHeaderWithSubtitle test_case_header
    let testCases = unsafePerformIO readTestCasesFromFile
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

searchTestCase :: IO()
searchTestCase = do
    putStrLn "Informe o id do caso de teste: "
    cod <- getLine
    let tests = unsafePerformIO(readTestCasesFromFile)
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

deleteTestCase :: IO()
deleteTestCase = do
    printHeaderWithSubtitle test_case_header
    putStrLn "\nInforme o id do caso de teste: "
    cod <- getLine
    let tests = unsafePerformIO(readTestCasesFromFile)
    let contains = containsTests tests cod
    if contains then do
        showTest (searchCase tests cod)
        putStrLn "Tem certeza que deseja excluir esse caso de testes? (S/N)"
        resp <- getLine
        if resp == "S" || resp == "s" then do
            writeTestCaseInFile (deleteCase tests cod)
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

changeStatus :: [TestCase] -> TestCase -> Int -> IO()
changeStatus tests (TestCase cod name goals _ preConditions steps) idStatus = do
    print preConditions
    systemPause
    let test = (createTestCaseType cod name goals (getStatus idStatus) preConditions steps)
    print test
    let testsUpdated = listAppend (deleteCase tests cod) test
    print testsUpdated
    systemPause
    writeTestCaseInFile testsUpdated

menuChangeStatus :: [TestCase] -> TestCase -> IO()
menuChangeStatus tests (TestCase cod name goals status preConditions steps) = do
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
        menuChangeStatus tests (createTestCaseType cod name goals status preConditions steps)
    else do
        if option == 4 then do
            return ()
        else do
            changeStatus tests (createTestCaseType cod name goals status preConditions steps) option

    systemPause

menuEditTest :: String -> [TestCase] -> IO()
menuEditTest cod tests = do
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
            createTestCase cod 
        else do
            if option == 2 then do
                menuChangeStatus tests test
            else do
                return ()
    else do
        putStrLn "\nOpcao invalida!"
        systemPause
        menuEditTest cod tests

showEditTestCaseMenu :: IO()
showEditTestCaseMenu = do
    printHeaderWithSubtitle test_case_header
    putStrLn "Informe o id do Caso de Teste: "
    cod <- getLine

    let tests = unsafePerformIO(readTestCasesFromFile)
    let contains = containsTests tests cod

    if contains then do 
        menuEditTest cod tests
    else do
        putStrLn "Caso de Testes nao foi encontrado"
        systemPause
    return ()


isOptionValcod :: Int -> Bool
isOptionValcod option = option >= 1 && option <= 6

chooseProcedure :: Int -> IO()
chooseProcedure 1 = do createTestCase "0"
chooseProcedure 2 = do listTestCases
chooseProcedure 3 = do searchTestCase
chooseProcedure 4 = do showEditTestCaseMenu
chooseProcedure 5 = do deleteTestCase

showMenu :: IO()
showMenu = do 
    printHeaderWithSubtitle test_case_header
    putStrLn test_Case_Menu

menu :: IO()
menu = do
    showMenu
    option <- readOption
    if isOptionValcod option
        then do
            if option == 6 then return ()
            else do 
                chooseProcedure option
                systemPause
                menu
    else do
        systemPause
        menu

main = do
    menu
    print calculateStatiscs

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

calculateStatiscs :: Float
calculateStatiscs = do
    let tests = unsafePerformIO readTestCasesFromFile
    let executedTestsQuantity = getExecutedTests tests
    let passedTestsQuantity = getPassedTests tests
    if executedTestsQuantity == 0 then 0
    else (passedTestsQuantity / executedTestsQuantity)