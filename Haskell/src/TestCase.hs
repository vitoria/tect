import Constants
import GeneralPrints

data Step = Step {
    description :: String,
    result :: String
} deriving (Eq, Show, Read) 

data TestCase = TestCase {
    name :: String,
    objective :: String,
    preConditions :: String,
    steps :: [Step]
} deriving (Eq, Show, Read) 

-- module TestCase where

-- Nome:
-- Objetivo:
-- Pré-condições:
--  - Passos de execução do caso de testes -
--  - Passo 1
-- Descrição do passo: 
-- Resultado esperado para o passo:
-- Deseja inserir outro passo (S/N)?
./
createTestCase :: IO()
createTestCase = do
    putStrLn name_const
    name <- getLine
    putStrLn goal
    goals <- getLine
    putStrLn preconditions
    preConditions <- getLine
    return ()

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