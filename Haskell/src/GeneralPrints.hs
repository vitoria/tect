module GeneralPrints where

    import System.Process
    import Constants

    printHeader :: IO()
    printHeader = do
        putStrLn header2

    printHeaderWithSubtitle :: String -> IO()
    printHeaderWithSubtitle subtitle = do
        clearScreen
        printHeader
        putStrLn subtitle
        putStrLn ""

    systemPause :: IO()
    systemPause = do
        putStrLn ("\n" ++ pause_msg)
        line <- getLine
        clearScreen

    clearScreen :: IO ()
    clearScreen = do
        _ <- system "clear"
        return ()

    readOption :: IO Int
    readOption = do
<<<<<<< HEAD
        putStrLn ("\n" ++ choose_option)
        line <- getLine
        return (read line :: Int)
=======
        putStrLn choose_option
        line <- getLine
        return (read line :: Int)
>>>>>>> Organizei os menus
