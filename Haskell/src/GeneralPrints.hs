module GeneralPrints where

import Constants

printHeader :: IO()
printHeader = do
    putStrLn header

printHeaderWithSubtitle :: String -> IO()
printHeaderWithSubtitle subtitle = do
    printHeader
    putStrLn subtitle