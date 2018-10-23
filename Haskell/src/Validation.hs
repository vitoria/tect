module Validation where
    
    import Constants

    isCharANumber :: Char -> Bool
    isCharANumber ch = ch `elem` ['0'..'9']

    isCharInInterval :: Char -> Char -> Char -> Bool
    isCharInInterval ch intervalBegin intervalEnd = ch `elem` [intervalBegin..intervalEnd]

    isOptionInputStringValid :: String -> Bool
    isOptionInputStringValid str = not (length str > 1)

    isOptionValid :: String -> Char -> Char -> Bool
    isOptionValid input intervalBegin intervalEnd = (isCharInInterval (input !! 0) intervalBegin intervalEnd) && (isOptionInputStringValid input)