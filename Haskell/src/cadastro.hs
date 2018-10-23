import Constants
import System.IO
import Data.List

data User = User {
    name :: String,
    username :: String,
    password :: String
} deriving (Eq, Show)

-- Para fazer testes
aa = User {name = "Douglas", username = "douglaslimaxx", password = "123"}
dd = User {name = "Douglas", username = "douglasli", password = "123"}

a = "douglaslimaxx"
d = "douglasli"
b = "bubu"

aaa = [aa, dd]
ddd = [dd]
zzz = []
-- Teste/

registerNewUser :: IO ()
registerNewUser = do
                putStrLn (header)
                putStrLn (sign_up_header)
                putStrLn ("")
                putStr (name_const)
                n <- getLine
                u <- getUser
                putStr (password_const)
                p <- getLine
                verifySenha <- getPassword p
                putStrLn ("Usuário cadastrado com sucesso!")
                saveUser User {name = n, username = u, password = p}

getUser :: IO String
getUser = do 
                putStr (username_const)
                u <- getLine
                if (verifyExistingUser u aaa) -- lista (aaa) utilizada como paremetro deve ser uma lista gerada a partir do arquivo com os usuários
                    then do 
                        putStr ("Username já cadastrado\n")
                        getUser
                    else 
                        return u


getPassword :: String -> IO String
getPassword x = do 
                putStr (confirmation_password)
                senha <- getLine
                if senha == x 
                    then 
                        return senha 
                    else do
                        putStr ("Senhas não confere\n")
                        getPassword x

verifyExistingUser :: String -> [User] -> Bool
verifyExistingUser _ [] = False
verifyExistingUser a (x:xs) | verifyExistingUserAux a x == True = True
                                | otherwise = verifyExistingUser
                             a xs

verifyExistingUserAux :: String -> User -> Bool
verifyExistingUserAux u (User _ a _) = if u == a then True else False

saveUser :: User -> IO ()
saveUser (User n u p)= do
                arq <- openFile "data/users.dat" AppendMode
                hPutStr arq n
                hPutStr arq "\n"
                hPutStr arq u
                hPutStr arq "\n"
                hPutStr arq p
                hPutStr arq "\n"
                hFlush arq
                hClose arq

-- Para testar o cleanFile
user_path = "data/users.dat"

cleanFile :: String -> IO ()
cleanFile a = do
                arq <- openFile a WriteMode
                hPutStr arq ""
                hFlush arq
                hClose arq

readFileUsers :: IO [User]
readFileUsers = do
            content <- readFile "data/users.dat"
            let listUser = content
            let lineUser = (lines listUser)
            return (stringsToUser lineUser)


stringsToUser :: [String] -> [User]
stringsToUser [] = []
stringsToUser (x:(y:(z:xs))) = (User x y z) : stringsToUser xs