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

fazerCadastro :: IO User
fazerCadastro = do
                putStrLn (header)
                putStrLn (sign_up_header)
                putStrLn ("")
                putStr (name_const)
                n <- getLine
                u <-pegarUser
                putStr (password_const)
                p <- getLine
                verifySenha <- pegarSenha p
                putStrLn ("Usuário cadastrado com sucesso!")
                return User {name = n, username = u, password = p}

pegarUser :: IO String
pegarUser = do 
                putStr (username_const)
                u <- getLine
                if (verificarUserExistente u aaa) -- lista (aaa) utilizada como paremetro deve ser uma lista gerada a partir do arquivo com os usuários
                    then 
                        pegarUser
                    else 
                        return u


pegarSenha :: String -> IO String
pegarSenha x = do 
                putStr (confirmation_password)
                senha <- getLine
                if senha == x 
                    then 
                        return senha 
                    else 
                        -- error "Senha não confere"
                        pegarSenha x

verificarUserExistente :: String -> [User] -> Bool
verificarUserExistente _ [] = False
verificarUserExistente a (x:xs) | verificarUserExistenteAux a x == True = True
                                | otherwise = verificarUserExistente a xs

verificarUserExistenteAux :: String -> User -> Bool
verificarUserExistenteAux u (User _ a _) = if u == a then True else False

salvaUser :: User -> IO ()
salvaUser (User n u p)= do
                arq <- openFile "data/users.dat" AppendMode
                hPutStr arq n
                hPutStr arq "\n"
                hPutStr arq u
                hPutStr arq "\n"
                hPutStr arq p
                hPutStr arq "\n"
                hFlush arq
                hClose arq

-- Para testar o limparArquivo
user_path = "data/users.dat"

limparArquivo :: String -> IO ()
limparArquivo a = do
                arq <- openFile a WriteMode
                hPutStr arq ""
                hFlush arq
                hClose arq