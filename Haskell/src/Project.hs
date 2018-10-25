import Constants
import GeneralPrints
import System.IO
import System.IO.Unsafe
import System.Directory
import System.FilePath
import Data.List
import Control.Monad
import Control.DeepSeq

--Aqui seria armazenado o login do usuário logado no momento no sistema
loggedUser = "lucascordeirobr"
emptyUsers = "NONE"
emptyRequests = "NONE"
--

data Project = Project {
    project_id :: Int,
    name :: String,
    project_description :: String,
    owner :: String,
    numberOfUsers :: Int, 
    users :: String,
    numberOfRequests :: Int,
    requests :: String
} deriving (Eq, Show)

stringListToProjectList :: [String] -> [Project]
stringListToProjectList [] = []
stringListToProjectList (pId:(name:(pDes:(owner:(nOfUsers:(users:(nOfRequests:(requests:strList)))))))) = (createProject (read pId) name pDes owner (read nOfUsers) users (read nOfRequests) requests):(stringListToProjectList strList)

projectListToString :: [Project] -> String
projectListToString [] = []
projectListToString (project:list) = (projectToString project) ++ (projectListToString list)

projectListToStringList :: [Project] -> [String]
projectListToStringList projectList = lines (projectListToString projectList)

projectsToStringShow :: [Project] -> String
projectsToStringShow [] = []
projectsToStringShow ((Project {project_id = id, name = pName}):projects) = (" " ++ (show id) ++ " - " ++ pName ++ "\n") ++ (projectsToStringShow projects)

showProjects :: IO()
showProjects = do
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
            let contentsList = lines fileContents
            return (stringListToProjectList contentsList)
        else do
            return []

searchProjectId :: Int -> [Project] -> Project
searchProjectId projectId [] = (Project {project_id = -1, name = "NOT FOUND", project_description = "NOT FOUND", owner = "NOT FOUND", numberOfUsers = -1, users = "NOT FOUND", numberOfRequests = -1, requests = "NOT FOUND"})
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
    print projects
    let filePath = data_folder_path ++ "/projects.dat"
    let projectFolderPath = data_folder_path ++ "/"
    let projectsToFile = (projectListToString projects)
    print projectsToFile
    if unsafePerformIO $ doesDirectoryExist data_folder_path
        then do
            if not (unsafePerformIO $ doesDirectoryExist projectFolderPath)
                then do
                    createDirectory projectFolderPath
                else do
                                putStrLn "Gravando projetos..."
        else do
            createDirectory (data_folder_path ++ "/")
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

getProjectUsers :: Project -> String
getProjectUsers (Project {users = usrs}) = usrs

getProjectNumOfReq :: Project -> Int
getProjectNumOfReq (Project {numberOfRequests = numOfReq}) = numOfReq

getProjectRequests :: Project -> String
getProjectRequests (Project {requests = req}) = req

generateNewProjectId :: [Project] -> Int
generateNewProjectId [] = 1
generateNewProjectId projects = (getProjectId (last projects)) + 1

createProject :: Int -> String -> String -> String -> Int -> String -> Int -> String -> Project
createProject id nameInput descriptionInput loggedOwner nOfUsers usrs nOfRequests rqsts = Project {project_id = id, name = nameInput, project_description = descriptionInput, owner = loggedOwner, numberOfUsers = nOfUsers, users = usrs, numberOfRequests = nOfRequests, requests = rqsts}
        
createNewProject :: IO()
createNewProject = do
    let projects = unsafePerformIO $ readProjects
    putStrLn ("Informe o nome do projeto: ")
    nameInput <- getLine
    putStr ("Informe a descrição do projeto: ")
    descriptionInput <- getLine
    let newProject = createProject (generateNewProjectId projects) nameInput descriptionInput loggedUser 0 emptyUsers 0 emptyRequests
    let newProjects = projects ++ (newProject:[])
    writeProjects newProjects
    putStrLn("Projeto criado com sucesso")

editProjects :: Project -> [Project] -> [Project]
editProjects newProject (project:projects)

    | getProjectId newProject == getProjectId project  = (newProject:projects)
    | otherwise = (project:(editProjects newProject projects))

askForPermissionProject :: Project -> IO()
askForPermissionProject project = do
    let projects = unsafePerformIO $ readProjects
    let newProject = createProject (getProjectId project) (getProjectName project) (getProjectDescription project) (getProjectOwner project) (getProjectNumOfUsers project) (getProjectUsers project) ((getProjectNumOfReq project) + 1) loggedUser
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

isOptionValid :: Int -> Bool
isOptionValid option = option >= 1 && option <= 8

chooseProcedure :: Int -> IO()
chooseProcedure 1 = do print "MEU USUARIO"
chooseProcedure 2 = do createNewProject
chooseProcedure 3 = do askForPermission
chooseProcedure 4 = do showProjects
chooseProcedure 5 = do 
    let projects = unsafePerformIO $ readProjects
    putStrLn ("Digite o id do projeto a ser gereneciado:")
    id <- getLine
    print "Redirecionando ao menu do projeto..."
--    projectMenu project id
chooseProcedure 6 = do print "CREATE"
chooseProcedure 7 = do print "CREATE"
chooseProcedure 8 = do print "CREATE"
chooseProcedure option = do print "NOT CREATE"
        
showUserMenu :: IO()
showUserMenu = do 
    printHeaderWithSubtitle main_header
    putStrLn main_menu

projectToString :: Project -> String
projectToString (Project project_id name project_description owner numberOfUsers users numberOfRequests requests) = (show project_id) ++ "\n" ++ name ++ "\n" ++ project_description ++ "\n" ++ owner ++ "\n" ++ (show numberOfUsers) ++ "\n" ++ users ++ "\n" ++ (show numberOfRequests) ++ "\n" ++ requests ++ "\n"    

menu :: IO()
menu = do
    showUserMenu
    putStrLn choose_option
    input <- getLine
    let option = read input :: Int
    if isOptionValid option
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