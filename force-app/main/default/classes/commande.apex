// Création d'un cloud dans BIMData
BIMDataAPI instance = BIMDataAPI.new_session();
instance.createCloud('test');
instance.inviteUser('ogossegardet@upmind.fr');


// Création d'un projet dans BImdata
BIMDataAPI instance = BIMDataAPI.new_session();
instance.cloudId = '25737'; // Id du cloud de la commande précedente
instance.createProject('test','ma description');


// Création d'un token 
BIMDataAPI instance = BIMDataAPI.new_session();
instance.cloudId = '25737';
instance.projectId = '832106'; // Id du projet de la commande précédente
system.debug(instance.createProjectToken());
// => Récupération d'un token 




