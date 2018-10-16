type Name = String
type Username = String
type Password = String
type User = (Name, Username, Password)

fazerCadastro :: IO User
fazerCadastro = do
                putStr ("Nome: ")
                name <- getLine
                putStr ("Username: ")
                username <- getLine
                putStr ("Senha: ")
                password <- getLine
                verifySenha <- pegarSenha password
                return (name, username, password)

pegarSenha :: String -> IO String
pegarSenha x = do 
                putStr ("Digite a senha novamente: ")
                senha <- getLine
                if senha == x 
                    then 
                        return senha 
                    else 
                        pegarSenha x

