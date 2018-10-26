import Constants
import GeneralPrints
import Data.List.Split

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
createTestCaseType cod name goals preConditions status steps = TestCase {
    cod = cod,
    name = name,
    goals = goals,
    status = status,
    preConditions = preConditions,
    steps = steps
}

deserializeStep :: String -> Step
deserializeStep str = do
    let splitedStr = splitOn "Step {details = \"" str
    let splitedStr2 = splitOn "\", expectedResult = \"" (splitedStr!!1)
    let splitedStr3 = splitOn "\"}" (splitedStr2!!1)

    let details = (splitedStr2!!0)
    let expectedResult = (splitedStr3!!0)

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
    let splitedStr6 = splitOn "\", steps = [" (splitedStr5!!1)
    let splitedStr7 = splitOn "]}" (splitedStr6!!1)
    
    let cod = (splitedStr2!!0)
    let name = (splitedStr3!!0)
    let goals = (splitedStr4!!0)
    let status = (splitedStr5!!0)
    let preConditions = (splitedStr6!!0)

    createTestCaseType cod name goals preConditions status (deserializeSteps (removeLastElement splitedStr7))

deserializeTestCases :: [String] -> [TestCase]
deserializeTestCases [] = []
deserializeTestCases (current:body) = ((deserializeTestCase current):(deserializeTestCases body))

listAppend :: [TestCase] -> TestCase -> [TestCase]
listAppend [] test = [test]
listAppend (h:body) test = (h:(listAppend body test))

readTestCasesFromFile :: IO [TestCase]
readTestCasesFromFile = do
    content <- readFile "data/testCases.dat"
    let testCasesStr = lines content
    return (deserializeTestCases testCasesStr)

writeTestCaseInFile :: [TestCase] -> IO()
writeTestCaseInFile testCases = do
    rnf (show testCases) `seq` (writeFile "data/testCases.dat" $ (show testCases))
    return ()

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

createTestCase :: IO()
createTestCase = do
    putStrLn name_const
    name <- getLine
    putStrLn goal
    goals <- getLine
    putStrLn preconditions
    preConditions <- getLine
    putStrLn case_steps_reading_header
    let cod = generatecod
    createSteps 0 (createTestCaseType cod name goals "Nao executado" preConditions [])
    return ()

    -- Não passou, Passou, Não executado, Erro de execução

createSteps :: Int -> TestCase -> IO()
createSteps stepsQuantity (TestCase cod name goals preConditions status steps)  = do
    putStrLn ("Passo " ++ show (stepsQuantity + 1))
    putStrLn case_step_description
    caseDescription <- getLine
    putStrLn case_step_expected_result
    caseExpectedResult <- getLine
    let currentStep = createStep caseDescription caseExpectedResult
    let testCaseUpdated = createTestCaseType cod name goals preConditions status (currentStep:steps)
    putStrLn case_step_continue_message
    resp <- getLine
    if resp == "N" || resp == "n"
        then do
            let testCases = listAppend (unsafePerformIO readTestCasesFromFile) testCaseUpdated
            writeTestCaseInFile testCases
    else do
        createSteps (stepsQuantity + 1) testCaseUpdated
    return (())

showTestCase :: [TestCase] -> IO()
showTestCase [] = do
    return ()
showTestCase ((TestCase cod name goals preConditions status _):body) = do
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
        putStrLn "Not found"
        systemPause
        return ()

isOptionValcod :: Int -> Bool
isOptionValcod option = option >= 1 && option <= 6

chooseProcedure :: Int -> IO()
chooseProcedure 1 = do createTestCase
chooseProcedure 2 = do listTestCases
chooseProcedure 3 = do searchTestCase
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
    -- print (unsafePerformIO readTestCasesFromFile)