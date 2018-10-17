import Constants

data User = User {
    name :: String,
    username :: String,
    password :: String
} deriving (Eq, Show)


{-type Name = String
type Username = String
type Password = String
type User = (Name, Username, Password)-}

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

{-verificarUserExistente [User]-}

