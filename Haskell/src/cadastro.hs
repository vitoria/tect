import Constants
import System.IO

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

registerNewUser :: IO User
registerNewUser = do
                putStrLn (header)
                putStrLn (sign_up_header)
                putStrLn ("")
                putStr (name_const)
                n <- getLine
                u <-getUser
                putStr (password_const)
                p <- getLine
                verifySenha <- getPassword p
                putStrLn ("Usuário cadastrado com sucesso!")
                return User {name = n, username = u, password = p}

getUser :: IO String
getUser = do 
                putStr (username_const)
                u <- getLine
                if (verifyExistingUser
                 u aaa) -- lista (aaa) utilizada como paremetro deve ser uma lista gerada a partir do arquivo com os usuários
                    then 
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
                    else 
                        -- error "Senha não confere"
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