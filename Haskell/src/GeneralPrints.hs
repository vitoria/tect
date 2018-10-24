module GeneralPrints where

    import System.Process
    import Constants

    printHeader :: IO()
    printHeader = do
        putStrLn header2

    printHeaderWithSubtitle :: String -> IO()
    printHeaderWithSubtitle subtitle = do
        printHeader
        putStrLn subtitle

    systemPause :: IO()
    systemPause = do
        putStrLn pause_msg
        line <- getLine
        clearScreen

    clearScreen :: IO ()
    clearScreen = do
        _ <- system "clear"
        return ()

    readOption :: IO Int
    readOption = do
        putStrLn choose_option
        line <- getLine
        return (read line :: Int)