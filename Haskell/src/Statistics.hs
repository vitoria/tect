module Statistics where
    import Constants
    import GeneralPrints
    import Validation
    import System.IO.Unsafe
    import System.Directory
    import System.FilePath
    import Data.List
    import Control.Monad
    import Control.DeepSeq
    import Prelude hiding (readFile)
    import System.IO.Strict (readFile)

    import TestSuite
    import TestCase

    sumStatisticsProject :: Int -> [Suite] -> Float
    sumStatisticsProject _ [] = 0.0
    sumStatisticsProject projectId ((Suite id _ _ _):list) = (calculateStatiscs projectId id) + (sumStatisticsProject projectId list)

    calculateMediumStatisticsProject :: Int -> [Suite] -> Float
    calculateMediumStatisticsProject projectId suites = ((sumStatisticsProject projectId suites) / (fromIntegral (length suites)))

    getProjectResume :: [(Int, String)] -> String
    getProjectResume [] = []
    getProjectResume (((id, name)):projectsTouple) = (show id) ++ " - " ++ name ++ " - " ++ (show (calculateMediumStatisticsProject id (getSuitesList id))) ++ "%\n" ++ (getProjectResume projectsTouple)

    getProjectsStatistics :: [(Int, String)] -> IO()
    getProjectsStatistics projectsTouple = do
        putStrLn statistics_header
        putStrLn " ID - NOME DO PROJETO - MÉDIA DAS ESTATÍSTICAS DO PROJETO\n"
        putStrLn (getProjectResume projectsTouple)
        return ()


    getProjectsId :: [(Int, String)] -> [Int]
    getProjectsId [] = []
    getProjectsId ((id, name):list) = id:(getProjectsId list)

    chooseStatisticsAction :: Char -> [(Int, String)]  -> IO()
    chooseStatisticsAction option projectsTouple
        | option == '1' = do getProjectsStatistics projectsTouple
        | option == '2' = do statisticsFromAProject (getProjectsId projectsTouple)
        | otherwise = do print invalid_option


    isValidProjId :: Int -> [Int] -> Bool
    isValidProjId _ [] = False
    isValidProjId testedId (id:projectsId)
        | testedId == id = True
        | otherwise = isValidProjId testedId projectsId

    statisticsFromAProject :: [Int] -> IO()
    statisticsFromAProject projectsId = do
        putStrLn statistics_header
        putStrLn "Informe o ID de um projeto para visualizar seu relatório:"
        projectId <- getLine
        if isStringNumeric projectId
            then do
                if isValidProjId (read projectId) projectsId
                    then do
                        clearScreen
                        let suites = getSuitesList (read projectId)
                            outputString = generateStatisticsString (read projectId) suites
                        putStrLn statistics_header
                        putStrLn ("SUITE ID - NOME DA SUITE - TAXA DE TESTES QUE PASSARAM\n" ++ outputString)
                    else do
                        putStrLn ("Não existe projeto com o ID informado.")
            else do
                putStrLn "O ID informado é inválido."
    
    generateStatisticsString :: Int -> [Suite] -> String
    generateStatisticsString _ [] = []
    generateStatisticsString projectId ((Suite id name _ _):suites) = show id ++ " - " ++ name ++ " - " ++ (show (calculateStatiscs projectId id)) ++ "%\n" ++ (generateStatisticsString projectId suites)
    
    getSuitesList :: Int -> [Suite]
    getSuitesList projId = unsafePerformIO $ readSuites projId

    showStatisticsMenu :: IO()
    showStatisticsMenu = do
        printHeaderWithSubtitle statistics_menu 

    statisticsMenu :: [(Int, String)] -> IO()
    statisticsMenu projectsTouple = do
        showStatisticsMenu
        putStrLn choose_option
        input <- getLine
        if isOptionValid input '1' '3'
                then do
                    let option = input !! 0
                    if option == '3'
                        then putStrLn "Retornando ao menu anterior..."
                        else do
                            clearScreen
                            chooseStatisticsAction option projectsTouple
                            systemPause
                            statisticsMenu projectsTouple
                else do
                    putStrLn invalid_option
                    systemPause
                    statisticsMenu projectsTouple