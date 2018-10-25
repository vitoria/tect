import Constants
import GeneralPrints
import Data.List.Split

import System.IO
import System.IO.Unsafe

data Step = Step {
    details :: String,
    expectedResult :: String
} deriving (Eq, Show, Read) 

data TestCase = TestCase {
    name :: String,
    goals :: String,
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

createTestCaseType :: String -> String -> String -> [Step] -> TestCase
createTestCaseType name goals preConditions steps = TestCase {
    name = name,
    goals = goals,
    preConditions = preConditions,
    steps = steps
}

-- readTestCasesFromFile :: IO [TestCase]
-- readTestCasesFromFile = do
--     content <- readFile "data/testCases.dat"
--     let testCasesPerLine = lines content
--     return (tes)

writeTestCaseInFile :: TestCase -> IO()
writeTestCaseInFile testCase = do
    file <- openFile "data/testCases.dat" AppendMode
    hPrint file testCase
    hFlush file
    hClose file 

createTestCase :: IO()
createTestCase = do
    putStrLn name_const
    name <- getLine
    putStrLn goal
    goals <- getLine
    putStrLn preconditions
    preConditions <- getLine
    putStrLn case_steps_reading_header
    createSteps 0 (createTestCaseType name goals preConditions [])
    return ()

createSteps :: Int -> TestCase -> IO()
createSteps stepsQuantity (TestCase name goals preConditions steps)  = do
    putStrLn ("Passo " ++ show (stepsQuantity + 1))
    putStrLn case_step_description
    caseDescription <- getLine
    putStrLn case_step_expected_result
    caseExpectedResult <- getLine
    let currentStep = createStep caseDescription caseExpectedResult
    let testCaseUpdated = createTestCaseType name goals preConditions (currentStep:steps)
    putStrLn case_step_continue_message
    resp <- getLine
    if resp == "N" || resp == "n"
        then do
            print "Saving the test case into the file..."
            -- let waza = createTestCaseType testCase (currentStep:steps)
            writeTestCaseInFile testCaseUpdated
            print "Saved!"

    else do
        createSteps (stepsQuantity + 1) testCaseUpdated
    return (())

isOptionValid :: Int -> Bool
isOptionValid option = option >= 1 && option <= 6

chooseProcedure :: Int -> IO()
chooseProcedure 1 = do createTestCase
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
    option <- readOption
    if isOptionValid option
        then chooseProcedure option
    else do
        systemPause
        menu

stringToStep :: String -> Step
stringToStep str = do
    let splitedStr = splitOn "Step {details = \"" str
    let splitedStr2 = splitOn "\", expectedResult = \"" (splitedStr!!1)
    let splitedStr3 = splitOn "\"}" (splitedStr2!!1)

    let details = (splitedStr2!!0)
    let expectedResult = (splitedStr3!!0)

    createStep details expectedResult

stringsToSteps :: [String] -> [Step]
stringsToSteps [] = []
stringsToSteps (head:body) = ((stringToStep head):(stringsToSteps body))

stringToTestCase :: String -> TestCase
stringToTestCase str = do
    let splitedStr = splitOn "TestCase {name = " str
    let splitedStr2 = splitOn ", goals = " (splitedStr!!1)
    let splitedStr3 = splitOn ", preConditions = " (splitedStr2!!1)
    let splitedStr4 = splitOn ", steps = [" (splitedStr3!!1)
    let splitedStr5 = splitOn "]}" (splitedStr4!!1)
    
    let name = ((splitOn "\"" (splitedStr2!!0))!!1)
    let goals = ((splitOn "\"" (splitedStr3!!0))!!1)
    let preConditions = ((splitOn "\"" (splitedStr4!!0))!!1)

    createTestCaseType name goals preConditions (stringsToSteps (removeLastElement splitedStr5))

stringsToTestCase :: [String] -> [TestCase]
stringsToTestCase [] = []
stringsToTestCase (current:body) = ((stringToTestCase current):(stringsToTestCase body))

main = do
    content <- readFile "data/testCases.dat"
    let listUser = content
    let lineUser = (lines listUser)

    print (stringsToTestCase lineUser)