import Constants
type Name = String
type Username = String
type Password = String
type User = (Name, Username, Password)

fazerCadastro :: IO User
fazerCadastro = do
                putStr (name)
                name <- getLine
                putStr (username)
                username <- getLine
                putStr (password)
                password <- getLine
                verifySenha <- pegarSenha password
                return (name, username, password)

pegarSenha :: String -> IO String
pegarSenha x = do 
                putStr (confirmation_password)
                senha <- getLine
                if senha == x 
                    then 
                        return senha 
                    else 
                        pegarSenha x

