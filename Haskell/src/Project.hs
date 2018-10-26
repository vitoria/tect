import Constants
import GeneralPrints
import System.IO.Unsafe
import System.Directory
import System.FilePath
import Data.List
import Control.Monad
import Control.DeepSeq
import Control.Exception

import Prelude hiding (readFile)
import System.IO.Strict (readFile)

--Aqui seria armazenado o login do usuário logado no momento no sistema
-- loggedUser = "lucas"
loggedUser = "lucas"
split_character = ','
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

generateUnlinedString :: String -> Char -> String
generateUnlinedString [] _ = []
generateUnlinedString (ch:str) delim
    | ch == delim = '\n':(generateUnlinedString str delim)
    | otherwise = ch:(generateUnlinedString str delim)

split :: String -> Char -> [String]
split [] _ = []
split str delim = lines (generateUnlinedString str delim)
    
stringListToString :: [String] -> String
stringListToString [] = ""
stringListToString (x:xs)
    | xs == [] = x
    | otherwise = x ++ "," ++ (stringListToString xs)

eliminateInitialEmptyString :: [String] -> [String]
eliminateInitialEmptyString (x:xs) = xs

stringListToProjectList :: [String] -> [Project]
stringListToProjectList [] = []
stringListToProjectList (pId:(name:(pDes:(owner:(nOfUsers:(users:(nOfRequests:(requests:strList)))))))) = (createProject (read pId) name pDes owner (read nOfUsers) (split users split_character) (read nOfRequests) (split requests split_character)):(stringListToProjectList strList)

projectListToString :: [Project] -> String
projectListToString [] = []
projectListToString (project:list) = (projectToString project) ++ (projectListToString list)

projectListToStringList :: [Project] -> [String]
projectListToStringList projectList = lines (projectListToString projectList)

projectsToStringShow :: [Project] -> String
projectsToStringShow [] = []
projectsToStringShow ((Project {project_id = id, name = pName}):projects) = (" " ++ (show id) ++ " - " ++ pName ++ "\n") ++ (projectsToStringShow projects)

showProjects :: Int -> IO()
showProjects numTrash = do
    let projects = unsafePerformIO $ readProjects
    putStrLn list_projects_header
    putStrLn "ID - Nome do Projeto"
    putStrLn (projectsToStringShow projects)

readProjects :: IO [Project]
readProjects = do
    let filePath = data_folder_path ++ "/projects.dat" 
    if unsafePerformIO $ doesFileExist filePath
        then do
            fileContents <- readFile filePath
            evaluate (force fileContents)
            let contentsList = lines fileContents
            return (stringListToProjectList contentsList)
        else do
            return []

searchProjectId :: Int -> [Project] -> Project
searchProjectId projectId [] = (Project {project_id = -1, name = "NOT FOUND", project_description = "NOT FOUND", owner = "NOT FOUND", numberOfUsers = -1, users = [], numberOfRequests = -1, requests = []})
searchProjectId projectId (project:projects)
    | getProjectId project == projectId = project
    | otherwise = searchProjectId projectId projects
            
searchProject :: Int -> IO Project
searchProject id = do
    let projects = unsafePerformIO $ readProjects 
    let project = searchProjectId id projects
    return Project {project_id = getProjectId project, name = getProjectName project, project_description = getProjectDescription project, owner = getProjectOwner project, numberOfUsers = getProjectNumOfUsers project, users = getProjectUsers project, numberOfRequests = getProjectNumOfReq project, requests = getProjectRequests project}

writeProjects :: [Project] -> IO()
writeProjects projects = do
    let filePath = data_folder_path ++ "/projects.dat"
    let projectFolderPath = data_folder_path ++ "/"
    let projectsToFile = (projectListToString projects)
    if unsafePerformIO $ doesDirectoryExist data_folder_path
        then do
            if not (unsafePerformIO $ doesDirectoryExist projectFolderPath)
                then do
                    createDirectory projectFolderPath
                else do
                    putStrLn "Gravando projetos..."
        else do
            createDirectory projectFolderPath
                
    rnf projectsToFile `seq` (writeFile filePath $ projectsToFile)            

getProjectId :: Project -> Int
getProjectId (Project {project_id = id}) = id 

getProjectName :: Project -> String
getProjectName (Project {name = proj_name}) = proj_name

getProjectDescription :: Project -> String
getProjectDescription (Project {project_description = proj_description}) = proj_description

getProjectOwner :: Project -> String
getProjectOwner (Project {owner = own}) = own

getProjectNumOfUsers :: Project -> Int
getProjectNumOfUsers (Project {numberOfUsers = numOfUsers}) = numOfUsers

getProjectUsers :: Project -> [String]
getProjectUsers (Project {users = usrs}) = usrs

getProjectNumOfReq :: Project -> Int
getProjectNumOfReq (Project {numberOfRequests = numOfReq}) = numOfReq

getProjectRequests :: Project -> [String]
getProjectRequests (Project {requests = req}) = req

generateNewProjectId :: [Project] -> Int
generateNewProjectId [] = 1
generateNewProjectId projects = (getProjectId (last projects)) + 1

createProject :: Int -> String -> String -> String -> Int -> [String] -> Int -> [String] -> Project
createProject id nameInput descriptionInput loggedOwner nOfUsers usrs nOfRequests rqsts = Project {project_id = id, name = nameInput, project_description = descriptionInput, owner = loggedOwner, numberOfUsers = nOfUsers, users = usrs, numberOfRequests = nOfRequests, requests = rqsts}
        
createNewProject :: IO()
createNewProject = do
    let projects = unsafePerformIO $ readProjects
    putStrLn ("Informe o nome do projeto: ")
    nameInput <- getLine
    putStrLn ("Informe a descrição do projeto: ")
    descriptionInput <- getLine
    let newProject = createProject (generateNewProjectId projects) nameInput descriptionInput loggedUser 0 [] 0 []
    let newProjects = projects ++ (newProject:[])
    writeProjects newProjects
    putStrLn("Projeto criado com sucesso")

editProjects :: Project -> [Project] -> [Project]
editProjects _ [] = []
editProjects newProject (project:projects)
    | getProjectId newProject == getProjectId project  = (newProject:projects)
    | otherwise = (project:(editProjects newProject projects))

askForPermissionProject :: Project -> IO()
askForPermissionProject project = do
    let projects = unsafePerformIO $ readProjects 
    putStrLn (show project)
    let newProject = createProject (getProjectId project) (getProjectName project) (getProjectDescription project) (getProjectOwner project) (getProjectNumOfUsers project) (getProjectUsers project) ((getProjectNumOfReq project) + 1) (((getProjectRequests project)) ++ (loggedUser:[]))
    putStrLn (show newProject) 
    let newProjects = editProjects newProject projects
    writeProjects newProjects

askForPermission :: IO()
askForPermission = do 
    putStrLn("Informe o id do projeto que deseja ter permissão:")
    id <- getLine
    let project = unsafePerformIO $ searchProject (read id)
    if getProjectId project > 0
        then do
            askForPermissionProject project 
            putStrLn("Pedido de permissão realizado com sucesso")
        else putStrLn("Projeto com id informado não está cadastrado.")

isOptionValidUserMenu :: Int -> Bool
isOptionValidUserMenu option = option >= 1 && option <= 8

viewProjectInformation :: Project -> IO()
viewProjectInformation project = do
    putStrLn ("-------Informações de Projeto-------")
    putStrLn ("Nome: " ++ getProjectName project)
    putStrLn ("Descrição: " ++ getProjectDescription project)

editProjectName :: Project -> IO String
editProjectName project = do
    putStrLn ("-------Editar nome do projeto-------")
    putStrLn ("Digite o novo nome do projeto")
    name <- getLine
    let newProject = createProject (getProjectId project) name (getProjectDescription project) (getProjectOwner project) (getProjectNumOfUsers project) (getProjectUsers project) (getProjectNumOfReq project) (getProjectRequests project)
    let projects = unsafePerformIO $ readProjects
    let newProjects = editProjects newProject projects
    writeProjects newProjects
    return ""

editProjectDescription :: Project -> IO String
editProjectDescription project = do
    putStrLn ("-------Editar descricao do projeto-------")
    putStrLn ("Digite a nova descricao do projeto")
    des <- getLine
    let newProject = createProject (getProjectId project) (getProjectName project) des (getProjectOwner project) (getProjectNumOfUsers project) (getProjectUsers project) (getProjectNumOfReq project) (getProjectRequests project)
    let projects = unsafePerformIO $ readProjects
    let newProjects = editProjects newProject projects
    writeProjects newProjects
    return ""

verifyPermissionRequests :: Project -> IO()
verifyPermissionRequests project = do
    putStrLn "Pedido de acesso ao projeto do usuário "
    putStrLn "Deseja conceder acesso a esse usuário: S/N"
    option <- getLine
    if option == "S"
        then do
            --updateProjectUsers getProjectRequests project
            print "Acesso concedido"
        else do
            putStrLn "Acesso não concedido"
            systemPause

excludeProjectFromFile :: Project -> [Project] -> [Project]
excludeProjectFromFile deleteProject (project:projects)
    | getProjectId project == getProjectId deleteProject = [] ++ projects
    | otherwise = (project:[]) ++ excludeProjectFromFile deleteProject projects

chooseOwnerProcedure :: Project -> Int -> IO()
chooseOwnerProcedure project 1 = do 
    viewProjectInformation project
    systemPause
    showProjectMenu project
chooseOwnerProcedure project 2 = do 
    editProjectName project
    showProjectMenu project
chooseOwnerProcedure project 3 = do 
    editProjectDescription project
    showProjectMenu project
chooseOwnerProcedure project 4 = do 
    verifyPermissionRequests project
    showProjectMenu project
chooseOwnerProcedure project 5 = do
    let projects = readProjects
    let newProjects = excludeProjectFromFile project (unsafePerformIO $ projects)
    writeProjects newProjects
    print "Projeto excluido com sucesso"
chooseOwnerProcedure project 6 = do
    print "Gerenciar suites de testes"
    showProjectMenu project
chooseOwnerProcedure project 7 = do 
    print "Saindo do projeto..."

chooseUserProcedure :: Project -> Int -> IO()
chooseUserProcedure project 1 = do 
    print "Gerenciar"
    showProjectMenu project
chooseUserProcedure project 2 = do print "Sair do projeto"


showProjectMenu :: Project -> IO()
showProjectMenu project = do
    let projectOwner = getProjectOwner project
    print projectOwner
    print loggedUser
    printHeaderWithSubtitle main_header
    if loggedUser == projectOwner
        then do
            putStrLn(project_menu_owner)
            putStrLn choose_option
            input <- getLine
            let option = read input :: Int
            if(isOptionValidProjectOwner option)
                then do
                    chooseOwnerProcedure project option
                    systemPause
                    menu
                else do
                    putStrLn invalid_option
                    systemPause
                    menu
        else do
            putStrLn(project_menu_user)
            putStrLn choose_option
            input <- getLine
            let option = read input :: Int
            if(isOptionValidProjectUser option)
                then do
                    chooseUserProcedure project option
                    systemPause
                    menu
                else do
                    putStrLn invalid_option
                    systemPause
                    menu

isOptionValidProjectOwner :: Int -> Bool
isOptionValidProjectOwner option = option >= 1 && option <= 7

isOptionValidProjectUser :: Int -> Bool
isOptionValidProjectUser option = option >= 1 && option <= 2

chooseProcedure :: Int -> IO()
chooseProcedure 1 = do 
    print "Usuario logado: "
    print loggedUser
chooseProcedure 2 = do createNewProject
chooseProcedure 3 = do askForPermission
chooseProcedure 4 = do showProjects 0
chooseProcedure 5 = do 
    let projects = unsafePerformIO $ readProjects
    putStrLn ("Digite o id do projeto a ser gereneciado:")
    id <- getLine
    let project = unsafePerformIO $ searchProject (read id)
    showProjectMenu project
    print "Projeto editado"
chooseProcedure 6 = do print "CREATE"
chooseProcedure 7 = do print "CREATE"
chooseProcedure 8 = do print "CREATE"
chooseProcedure option = do print "NOT CREATE"
        
showUserMenu :: IO()
showUserMenu = do 
    printHeaderWithSubtitle main_header
    putStrLn main_menu

projectToString :: Project -> String
projectToString (Project project_id name project_description owner numberOfUsers users numberOfRequests requests) = (show project_id) ++ "\n" ++ name ++ "\n" ++ project_description ++ "\n" ++ owner ++ "\n" ++ (show numberOfUsers) ++ "\n" ++ stringListToString users ++ "\n" ++ (show numberOfRequests) ++ "\n" ++ stringListToString requests ++ "\n"    

menu :: IO()
menu = do
    showUserMenu
    putStrLn choose_option
    input <- getLine
    let option = read input :: Int
    if isOptionValidUserMenu option
        then do
            chooseProcedure option
            systemPause
            menu
    else do
        putStrLn invalid_option
        systemPause
        menu
            
main = do
    menu