import Constants
import GeneralPrints

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

createStep :: String -> String -> Step
createStep details expectedResult = Step {
    details = details,
    expectedResult = expectedResult
}

createTestCaseType :: String -> String -> String -> TestCase
createTestCaseType name goals preConditions steps = TestCase {
    name = name,
    goals = goals,
    preConditions = preConditions,
    steps = steps
}



createTestCase :: IO()
createTestCase = do
    putStrLn name_const
    name <- getLine
    putStrLn goal
    goals <- getLine
    putStrLn preconditions
    preConditions <- getLine
    putStrLn case_steps_reading_header
    createSteps (createTestCaseType name goals preConditions []) 0 []
    return ()

createSteps :: TestCase -> Int -> [Step] -> IO()
createSteps testCase stepsQuantity steps = do
    putStrLn ("Passo " ++ show (stepsQuantity + 1))
    putStrLn case_step_description
    caseDescription <- getLine
    putStrLn case_step_expected_result
    caseExpectedResult <- getLine
    let currentStep = createStep caseDescription caseExpectedResult
    putStrLn case_step_continue_message
    resp <- getLine
    if resp == "N" || resp == "n"
        then do
            print "Should save the test case in the database"
            print (currentStep:steps)
    else do
        createSteps testCase (stepsQuantity + 1) (currentStep:steps)
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

main = do
    menu