<?php
// Auth Details.
define('USERNAME', 'mmmartin');
define('PASSWORD', 'bunnyfunster');

// Slim PHP
require 'Slim/Slim.php';
require 'Views/TwigView.php';

// Paris and Idiorm
require 'Paris/idiorm.php';
require 'Paris/paris.php';

// Models
require 'models/Task.php';
require 'models/User.php';

// Configuration
TwigView::$twigDirectory = __DIR__ . '/Twig/lib/Twig/';

// ORM::configure('mysql:host=localhost;dbname=mm_work');
ORM::configure('mysql:host=localhost;dbname=task_list');
ORM::configure('username', 'root');
ORM::configure('password', '');

// define constants for menu bar state machine
define("SCREEN_HOME", 0);
define("SCREEN_ADMIN", 1);
define("SCREEN_ADD", 2);


// home = 0, admin = 1, add = 2
$screen = SCREEN_HOME;


// Start Slim and set up logging
$app = new Slim(array('view' => new TwigView,
   'debug' => true,
   'log.enable' => true,
   'log.logger' => new Slim_Logger('./Logs', 4)
));

$log = $app->getLog();


//Auth Check.
$authCheck = function() use ($app, $log) {

	$authRequest 	= isset($_SERVER['PHP_AUTH_USER'], $_SERVER['PHP_AUTH_PW']);
	$authUser 		= $authRequest && $_SERVER['PHP_AUTH_USER'] === USERNAME;
	$authPass 		= $authRequest && $_SERVER['PHP_AUTH_PW'] === PASSWORD;

	$log->info('Req: '.$authRequest);
	$log->info('User: '.$authUser);
	$log->info('Pass: '.$authPass);

	if (! $authUser || ! $authPass) {
		$app->response()->header('WWW-Authenticate: Basic realm="My Blog Administration"', '');
		$app->response()->header('HTTP/1.1 401 Unauthorized', '');
		$app->response()->body('<h1>Please enter valid administration credentials</h1>');
		$app->response()->send();
		exit;
	}
};

// Blog Homepage.
$app->get('/', $authCheck, function() use ($app, $screen, $log) {
	$screen = SCREEN_HOME;
	$log->info('get/');
	$tasks = Model::factory('Task')
					->order_by_asc('rank')
					->find_many();
	return $app->render('blog_home.html', array('tasks' => $tasks, 'screen'=>$screen));		
});

// Blog View.
$app->get('/view/(:id)', function($id) use ($app, $screen, $log){
	$screen = SCREEN_HOME;
	$log->info('get/view/(:id)');
	$task = Model::factory('Task')->find_one($id);
	if (! $task instanceof Task) {
		$app->notFound();
	}
	$screen = SCREEN_HOME;
	return $app->render('blog_detail.html', array('task' => $task,  'screen'=>$screen));
});



// Admin Home.
$app->get('/admin', $authCheck, function() use ($app, $screen, $log){
	$screen = SCREEN_ADMIN;
	$log->info('/admin)');
	$tasks = Model::factory('Task')
					->order_by_asc('rank')
					->find_many();
	$screen = 1;					
	return $app->render('admin_home.html', array('tasks' => $tasks,  'screen'=>$screen));
});

// Admin Add.
$app->get('/admin/add', $authCheck, function() use ($app, $screen, $log){
	$log->info('/admin/add');
	$screen = SCREEN_ADD;
	return $app->render('admin_input.html', array('action_name' => 'Add', 'action_url' => '/admin/add',  'screen'=>$screen));
});

// Admin Add - POST.
$app->post('/admin/add', $authCheck, function() use ($app, $screen, $log){
	$log->info('/admin/add post');
	$task 			= Model::factory('Task')->create();
	$task->summary 	= $app->request()->post('summary');
	$task->content 	= $app->request()->post('content');
	$task->reporter = $app->request()->post('reporter');
	$task->owner 	= $app->request()->post('owner');
	$task->status 	= $app->request()->post('status');
	//todo - need to append to rank (dependant on context)
	//$task->rank 	= $app->request()->post('rank');
	$task->timecreated = date('Y-m-d H:i:s');
	$task->save();
	
	$log->info('Redirecting to admin from add');
	$screen = SCREEN_ADMIN;					
	$app->redirect('/admin');
});

// Admin Edit.
$app->get('/admin/edit/(:id)', $authCheck, function($id) use ($app, $screen, $log){
	$log->info('/admin/edit/(:id)');
	$task = Model::factory('Task')->find_one($id);
	if (! $task instanceof Task) {
		$app->notFound();
	}	
	$screen = 2;
	return $app->render('admin_input.html', array(
		'action_name' 	=> 	'Edit', 
		'action_url' 	=> 	'/admin/edit/' . $id,
		'task'		=> 	$task,
		'screen'=>$screen
	));
});

// Admin Edit - POST.
$app->post('/admin/edit/(:id)', $authCheck, function($id) use ($app, $screen, $log){
	$log->info('/admin/edit/(:id) - POST');
	$task = Model::factory('Task')->find_one($id);
	if (! $task instanceof Task) {
		$app->notFound();
	}
	
	$task->summary 	= $app->request()->post('summary');
	$task->owner 	= $app->request()->post('owner');
	$task->status 	= $app->request()->post('status');
	$task->timecreated = date('Y-m-d H:i:s');
	$task->save();

	$log->info('Redirecting to admin from edit');
	$screen = SCREEN_ADMIN;

	$app->redirect('/admin');
});

// Admin Delete.
$app->get('/admin/delete/(:id)', $authCheck, function($id) use ($app, $screen, $log){
	$log->info('/admin/delete/(:id) -');
	$task = Model::factory('Task')->find_one($id);
	if ($task instanceof Task) {
		$task->delete();
	}
	$screen = SCREEN_ADMIN;				
	$log->info('Redirecting to admin from delete');
	$app->redirect('/admin');
});



// Slim Run.
$app->run();