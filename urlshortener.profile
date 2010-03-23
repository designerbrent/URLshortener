<?php

/**
 * Return a description of the profile for the initial installation screen.
 *
 * @return
 *   An array with keys 'name' and 'description' describing this profile.
 */
function urlshortener_profile_details() {
  return array(
    'name' => 'URL Shortener',
      'description' => 'URL Shortener is a profile to create a custom URL shortener site.'
    );
}

/**
 * Return an array of the modules to be enabled when this profile is installed.
 *
 * @return
 *  An array of modules to be enabled.
 */
function urlshortener_profile_modules() {
  return array(
    // Enable optional core modules next.
    'menu', 'taxonomy','help','update', 'syslog', 'path',

    // Then, enable any contributed modules here.
    'install_profile_api', 'admin_menu', 'adminrole', 'shorten', 'shorturl', 'tldrestrict', 'record_shorten', // 'devel',
  );
}

/**
* Implementation of hook_profile_tasks().
*/
function urlshortener_profile_tasks() {

  // Install the core required modules and our extra modules
  $core_required = array('block', 'filter', 'node', 'system', 'user');
  install_include(array_merge(urlshortener_profile_modules(), $core_required));

  // Make a 'maintainer' role
  install_add_role('staff');
  $rid = install_get_rid('staff');
  // Set some permissions for the role
  $perms = array(
    'use Shorten URLs page', 
    'export own statistics', 
    'view all statistics', 
    'view link details', 
    'view own statistics', 
    'change own username',
  );

  install_add_permissions($rid, $perms);

  // Change anonymous user's permissions - since anonymous user is always rid 1 we don't need to retrieve it
  $perms = array(
    'access content',
    'view all statistics', 
  );
  
  install_add_permissions(1, $perms);

  // Enable the Tao subtheme
  // install_enable_theme("blueprint");

  // Enable default theme
  install_default_theme("blueprint");

  // Put the navigation block in the sidebar because the sidebar looks awesome.
  install_init_blocks();
  // Recent comments
  install_set_block('user', 1, 'blueprint', 'right');


  // Set the front page to be fserver
  variable_set('shorten_service', 'This site');
  variable_set('shorten_www', '0');
  variable_set('site_frontpage', 'shorturl/all');
  variable_set('site_footer', 'Powered by <a href="http://www.drupal.org">Drupal</a> and created by <a href="http://positivechoices.com">PositiveChoices.com</a>.');


  // Add the "Page" content type
  $page_props = array(
    array(
      'module' => 'node',
      'description' => t('If you want to add a static page, like a contact page or an about page, use a page.'),
      'body_label' => 'Body',
      'custom' => TRUE,
      'modified' => TRUE,
      'locked' => FALSE,
    ),
  );
  
  install_create_content_type('page', 'Page', $page_props);

  // Create some instructional and example nodes.
  $node_props = array(
    'nid' => NULL,
    'title' => 'About',
    'body' => "This is a sample about us page that you can edit to fill with information about your URL shortener.",
    'path' => 'about',
    );
  install_save_node($node_props);
  
  // Setup some default menu items.
  $items = array(
    array('path' => '<front>', 'title' => t('Home'), 'weight' => 0, 'menu' => 'primary-links'),
    array('path' => 'node/1', 'title' => t('About'), 'weight' => 2, 'menu' => 'primary-links'),
  );

  install_menu_create_menu_items($items, 0);
  
  // Default page to not be promoted and have comments disabled.
  variable_set('node_options_page', array('status'));
  variable_set('comment_page', COMMENT_NODE_DISABLED);

  // Don't display date and author information for page nodes by default.
  $theme_settings = variable_get('theme_settings', array());
  $theme_settings['toggle_node_info_page'] = FALSE;
  $theme_settings['toggle_logo'] = FALSE;
  $theme_settings['default_logo'] = FALSE;
  $theme_settings['default_favicon'] = FALSE;
  variable_set('theme_settings', $theme_settings);


}

/**
* Perform any final installation tasks for this profile.
*
* @return
*   An optional HTML string to display to the user on the final installation
*   screen.
*/
function urlshortener_profile_final() {

  // Don't display date and author information for page nodes by default.
  $theme_settings = variable_get('theme_settings', array());
  $theme_settings['toggle_node_info_page'] = FALSE;
  variable_set('theme_settings', $theme_settings);

  // The return message is optional, if you omit it the default will be used.
  return '<p>'. (drupal_set_message() ? t('Please review the messages above before continuing on to <a href="@url">your new Profile Name site</a>.', array('@url' => url(''))) : t('You may now visit <a href="@url">your new Profile Name site</a>.', array('@url' => url('')))) .'</p><p>'. t('Don\'t forget to edit the <a href="@url">About page</a>', array('@url' => url('about'))) . '</p>';
}

/**
 * Implementation of hook_form_alter().
 */
function urlshortener_form_alter(&$form, $form_state, $form_id) {
  if ($form_id == 'install_configure') {
    $form['site_information']['site_name']['#default_value'] = 'URL Shortener';
    $form['site_information']['site_mail']['#default_value'] = 'admin@'. $_SERVER['HTTP_HOST'];
    $form['admin_account']['account']['name']['#default_value'] = 'admin';
    $form['admin_account']['account']['mail']['#default_value'] = 'admin@'. $_SERVER['HTTP_HOST'];
  }
}
