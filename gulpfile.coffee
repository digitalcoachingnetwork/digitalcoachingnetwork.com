gulp =         require 'gulp'
gutil =        require 'gulp-util'
plumber =      require 'gulp-plumber'
notify = 			 require 'gulp-notify'
coffee =       require 'gulp-coffee'
http =         require 'http'
runSequence =  require 'run-sequence'
es =  				 require 'event-stream'
sass =         require 'gulp-sass'
stylus =       require 'gulp-stylus'
nib = 			   require 'nib'
autoprefixer = require 'gulp-autoprefixer'
minifycss =    require 'gulp-minify-css'
jshint =       require 'gulp-jshint'
rename =       require 'gulp-rename'
uglify =       require 'gulp-uglify'
concat =       require 'gulp-concat'
# imagemin =     require 'gulp-imagemin'
cache =        require 'gulp-cache'
livereload =   require 'gulp-livereload'
filter =       require 'gulp-filter'
del =          require 'del'
open =         require 'open'

notifyOnError = notify.onError("<%= error.message %>")

config =
	httpPort: 9882
	livereloadPort: '35729'

	# markup
	views: 'app/views/**/*'

	# styles
	srcCss: 'src/public/styles/**/*.css'
	srcStylus: 'src/public/styles/**/*.styl'
	srcSass: 'src/public/styles/**/*.s*ss'
	destCss: 'app/public/styles'
	cssConcatTarget: 'out.css'

	# scripts
	srcAllJs: 'src/**/*.js'
	srcAllCoffee: 'src/**/*.coffee'
	srcClientScripts: 'src/public/**/*.coffee'
	srcClientExclude: '!public/**/*.coffee'
	destClientScripts: 'app/public/scripts'
	jsConcatTarget: 'main.js'
	destServerScripts: 'app'

	# images
	srcImg: 'src/public/images/**/*.*'
	destImg: 'app/public/images'

# styles task
gulp.task 'styles', ->
	css = gulp.src(config.srcCss)
	stylusStream = gulp.src(config.srcStylus)
		.pipe(plumber(errorHandler: notifyOnError))
		.pipe(stylus({use: [nib()]}))
	sassStream = gulp.src(config.srcSass)
		.pipe(plumber(errorHandler: notifyOnError))
		.pipe(sass(indentedSyntax: true))

	es.merge(css, sassStream, stylusStream)
		.pipe(concat(config.cssConcatTarget))
		.pipe(autoprefixer('last 2 version', 'safari 5', 'ie 7', 'ie 8', 'ie 9', 'opera 12.1', 'ios 6', 'android 4'))
		.pipe(gulp.dest(config.destCss))
		.pipe(rename(suffix: '.min'))
		.pipe(minifycss())
		.pipe(gulp.dest(config.destCss))
		.pipe livereload(auto:false)

# compile client-side coffeescript, concat, & minify js
gulp.task 'clientScripts', ->
	gulp.src(config.srcClientScripts)
		.pipe(plumber(errorHandler: notifyOnError))
		.pipe(coffee().on('error', gutil.log))
		.pipe(concat(config.jsConcatTarget))
		.pipe(gulp.dest(config.destClientScripts))
		.pipe(rename(suffix: '.min'))
		.pipe(uglify())
		.pipe(gulp.dest(config.destClientScripts))
		.pipe livereload(auto:false)

# compile server-side coffeescript
gulp.task 'serverScripts', ->
	js = gulp.src(config.srcAllJs)
		.pipe(filter(['**/*', config.srcClientExclude]))
	compiledCoffee = gulp.src(config.srcAllCoffee)
		.pipe(filter(['**/*', config.srcClientExclude]))
		.pipe(plumber(errorHandler: notifyOnError))
		.pipe(coffee().on('error', gutil.log))
		# .pipe(jshint())
		# .pipe(jshint.reporter('default'))

	es.merge(js, compiledCoffee)
		.pipe(gulp.dest(config.destServerScripts))
		.pipe livereload(auto:false)

# minify images
# gulp.task 'images', ->
# 	gulp.src(config.srcImg)
# 		.pipe(imagemin())
# 		.pipe gulp.dest(config.destImg)

# clean
gulp.task 'clean', (cb)->
	del([
		config.destCss,
		'app/*.js',
		'app/controllers/*.js',
		'app/public/scripts/*.js'
	], cb)

# build
gulp.task 'build', (cb)->
	runSequence 'clean', [
		# 'plugins'
		'clientScripts'
		'serverScripts'
		'styles'
		# 'images'
	], cb

# gulp.task 'views', (cb)->
# 	livereload(auto:false)
# 	cb();

# site launcher
gulp.task 'open', ->
	open 'http://localhost:' + config.httpPort

gulp.task 'watch', (cb) ->

	gulp.watch([config.srcCss, config.srcSass, config.srcStylus], ['styles'])._watcher.on 'all', livereload
	gulp.watch(config.srcClientScripts, ['clientScripts'])._watcher.on 'all', livereload
	gulp.watch([config.srcAllJs, config.srcAllCoffee, '!' + config.srcClientScripts], ['serverScripts'])._watcher.on 'all', livereload
	# gulp.watch([config.views], ['views'])._watcher.on 'all', livereload
	# gulp.watch(config.srcImg, ['images'])._watcher.on 'all', livereload

# default task -- run 'gulp' from cli
gulp.task 'default', (cb) ->

	runSequence 'clean', [
		# 'plugins'
		'clientScripts'
		'serverScripts'
		'styles'
		# 'images'
	], 'watch', cb

	livereload.listen config.livereloadPort

