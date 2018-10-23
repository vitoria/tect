module Validation where
    
    import Constants

    isCharANumber :: Char -> Bool
    isCharANumber ch = ch `elem` ['0'..'9']

    isCharInInterval :: Char -> Char -> Char -> Bool
    isCharInInterval ch intervalBegin intervalEnd = ch `elem` [intervalBegin..intervalEnd]

    isOptionInputStringValid :: String -> Bool
    isOptionInputStringValid [] = False
    isOptionInputStringValid str = not (length str > 1)

    isOptionValid :: String -> Char -> Char -> Bool
    isOptionValid input intervalBegin intervalEnd = if isOptionInputStringValid input
                                                        then isCharInInterval (input !! 0) intervalBegin intervalEnd
                                                        else False