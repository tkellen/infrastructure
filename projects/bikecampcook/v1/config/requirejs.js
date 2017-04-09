require.config({

  // override data-main from script tag during debug mode
  baseUrl: '/',

  // automatically require on page load in debug mode
  deps: ['cs!site/index'],

  // automatically require this for production build
  insertRequire: ['cs!site/index'],

  // map bower components to nice paths
  paths: {
    site: 'scripts',
    jquery: 'bower_components/jquery/jquery',
    'amd-loader': 'bower_components/amd-loader/amd-loader',
    'coffee-script': 'bower_components/coffee-script/index',
    text: 'bower_components/requirejs-plugins/lib/text',
    json: 'bower_components/requirejs-plugins/src/json',
    cjs: 'bower_components/cjs/cjs',
    cs: 'bower_components/require-cs/cs',
    modernizr: 'bower_components/modernizr/modernizr',
    placeholder: 'bower_components/jquery-placeholder/jquery.placeholder',
    waypoints: 'bower_components/jquery-waypoints/waypoints',
    waypoints_sticky: 'bower_components/jquery-waypoints/shortcuts/sticky-elements/waypoints-sticky',
    scrollto: 'bower_components/jquery.scrollTo/jquery.scrollTo',
    forms: 'bower_components/jquery-form/jquery.form',
    numeric: 'bower_components/jquery-numeric/jquery-numeric',
    query_string: 'bower_components/query-string/query-string'
  },

  // load non-amd dependencies
  shim: {
    modernizr: {
      exports: 'modernizr'
    },
    waypoints_sticky: ['waypoints'],
    waypoints: ['jquery'],
    scrollto: ['jquery'],
    placeholder: ['jquery'],
    forms: ['jquery'],
    numeric: ['jquery']
  },

  // modules not included in optimized build
  stubModules: ['amd-loader', 'coffee-script', 'text', 'json', 'cjs', 'cs']

});
