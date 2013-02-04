<?php
// Auth Details.
define('USERNAME', 'admin');
define('PASSWORD', 'password');

// Slim PHP
require 'Slim/Slim.php';
require 'Views/TwigView.php';

// Paris and Idiorm
require 'Paris/idiorm.php';
require 'Paris/paris.php';

// Models
require 'models/Task.php';

// Configuration
TwigView::$twigDirectory = __DIR__ . '/Twig/lib/Twig/';

ORM::configure('mysql:host=localhost;dbname=task_list');
ORM::configure('username', 'root');
ORM::configure('password', '');

// Start Slim.
$app = new Slim(array(
	'view' => new TwigView
));



//Auth Check.
$authCheck = function() use ($app) {
	$authRequest 	= isset($_SERVER['PHP_AUTH_USER'], $_SERVER['PHP_AUTH_PW']);
	$authUser 		= $authRequest && $_SERVER['PHP_AUTH_USER'] === USERNAME;
	$authPass 		= $authRequest && $_SERVER['PHP_AUTH_PW'] === PASSWORD;

	if (! $authUser || ! $authPass) {
		$app->response()->header('WWW-Authenticate: Basic realm="My Blog Administration"', '');
		$app->response()->header('HTTP/1.1 401 Unauthorized', '');
		$app->response()->body('<h1>Please enter valid administration credentials</h1>');
		$app->response()->send();
		exit;
	}
};



// Blog Homepage.
$app->get('/', function() use ($app) {
	$tasks = Model::factory('Task')
					->order_by_desc('rank')
					->find_many();
					
	return $app->render('blog_home.html', array('tasks' => $tasks));		
});

// Blog View.
$app->get('/view/(:id)', function($id) use ($app) {
	$task = Model::factory('Task')->find_one($id);
	if (! $task instanceof Task) {
		$app->notFound();
	}
	
	return $app->render('blog_detail.html', array('task' => $task));
});



// Admin Home.
$app->get('/admin', $authCheck, function() use ($app) {
	$tasks = Model::factory('Task')
					->order_by_desc('rank')
					->find_many();
					
	return $app->render('admin_home.html', array('tasks' => $tasks));
});

// Admin Add.
$app->get('/admin/add', $authCheck, function() use ($app) {
	return $app->render('admin_input.html', array('action_name' => 'Add', 'action_url' => '/admin/add'));
});	

// Admin Add - POST.
$app->post('/admin/add', $authCheck, function() use ($app) {
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
	
	$app->redirect('/admin');
});

// Admin Edit.
$app->get('/admin/edit/(:id)', $authCheck, function($id) use ($app) {
	$task = Model::factory('Task')->find_one($id);
	if (! $task instanceof Task) {
		$app->notFound();
	}	
	
	return $app->render('admin_input.html', array(
		'action_name' 	=> 	'Edit', 
		'action_url' 	=> 	'/admin/edit/' . $id,
		'task'		=> 	$task
	));
});

// Admin Edit - POST.
$app->post('/admin/edit/(:id)', $authCheck, function($id) use ($app) {
	$task = Model::factory('Task')->find_one($id);
	if (! $task instanceof Task) {
		$app->notFound();
	}
	
	$task->summary 	= $app->request()->post('summary');
	$task->owner 	= $app->request()->post('owner');
	$task->status 	= $app->request()->post('status');
	$task->timecreated = date('Y-m-d H:i:s');
	$task->save();
	
	$app->redirect('/admin');
});

// Admin Delete.
$app->get('/admin/delete/(:id)', $authCheck, function($id) use ($app) {
	$task = Model::factory('Task')->find_one($id);
	if ($task instanceof Task) {
		$task->delete();
	}
	
	$app->redirect('/admin');
});



// Slim Run.
$app->run();