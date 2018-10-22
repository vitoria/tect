module Project where

    import Constants

    --Aqui seria armazenado o login do usuário logado no momento no sistema
    loggedUser = "lucascordeirobr"
    --

    data Project = Project {
        project_id :: Int,
        name :: String,
        project_description :: String,
        owner :: String,
        numberOfUsers :: Int, 
        users :: [String],
        numberOfRequests :: Int,
        requests :: [String]
    } deriving (Eq, Show)

    {-type Id = Int
    type Name = String
    type Description = String
    type Owner = String
    type NumberOfUsers = Int
    type Users = [String]
    type NumberOfRequests = Int
    type Requests = [String]
    type Project = (Id, Name, Description, Owner, NumberOfUsers, Users, NumberOfRequests, Requests)-}

    criarProjeto :: IO Project
    criarProjeto = do
        putStrLn (name_const)
        n <- getLine
        putStr (Constants.description)
        d <- getLine
        --O id deve ainda ser alterado para que verifique qual o ultimo id adicionado
        --e então o id atual possa ser o ultimo id + 1
        return Project {project_id = 1, name = n, project_description = d, owner = loggedUser, numberOfUsers = 0, users = [], numberOfRequests = 0, requests = []}
        