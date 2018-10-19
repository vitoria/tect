import Constants

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
                putStr (name_const)
                n <- getLine
                putStr (username_const)
                u <- getLine
                putStr (password_const)
                p <- getLine
                verifySenha <- pegarSenha p
                return User {name = n, username = u, password = p}

pegarSenha :: String -> IO String
pegarSenha x = do 
                putStr (confirmation_password)
                senha <- getLine
                if senha == x 
                    then 
                        return senha 
                    else 
                        pegarSenha x

verificarUserExistente :: String -> [User] -> Bool
verificarUserExistente _ [] = False
verificarUserExistente a (x:xs) | verificarUserExistenteAux a x == True = True
                                | otherwise = verificarUserExistente a xs

verificarUserExistenteAux :: String -> User -> Bool
verificarUserExistenteAux u (User _ a _) = if u == a then True else False